#!/usr/bin/ruby
#
# usage: ruby fetch-format-data.rb
# fetches and formats data and writes files
#
# Copyright 2020 by zunda <zundan at gmail.com>
#
# Permission is granted for use, copying, modification, distribution,
# and distribution of modified versions of this work as long as the
# above copyright notice is included.
#
require 'csv'
require 'time'
require 'json'
require 'open-uri'
require 'fileutils'

JAPAN_PREF_NAMES={
	'北海道' => 'Hokkaido',
	'青森県' => 'Aomori',
	'岩手県' => 'Iwate',
	'宮城県' => 'Miyagi',
	'秋田県' => 'Akita',
	'山形県' => 'Yamagata',
	'福島県' => 'Fukushima',
	'茨城県' => 'Ibaraki',
	'栃木県' => 'Tochigi',
	'群馬県' => 'Gunma',
	'埼玉県' => 'Saitama',
	'千葉県' => 'Chiba',
	'東京都' => 'Tokyo',
	'神奈川県' => 'Kanagawa',
	'新潟県' => 'Niigata',
	'富山県' => 'Toyama',
	'石川県' => 'Ishikawa',
	'福井県' => 'Fukui',
	'山梨県' => 'Yamanashi',
	'長野県' => 'Nagano',
	'岐阜県' => 'Gifu',
	'静岡県' => 'Shizuoka',
	'愛知県' => 'Aichi',
	'三重県' => 'Mie',
	'滋賀県' => 'Shiga',
	'京都府' => 'Kyoto',
	'大阪府' => 'Osaka',
	'兵庫県' => 'Hyogo',
	'奈良県' => 'Nara',
	'和歌山県' => 'Wakayama',
	'鳥取県' => 'Tottori',
	'島根県' => 'Shimane',
	'岡山県' => 'Okayama',
	'広島県' => 'Hiroshima',
	'山口県' => 'Yamaguchi',
	'徳島県' => 'Tokushima',
	'香川県' => 'Kagawa',
	'愛媛県' => 'Ehime',
	'高知県' => 'Kochi',
	'福岡県' => 'Fukuoka',
	'佐賀県' => 'Saga',
	'長崎県' => 'Nagasaki',
	'熊本県' => 'Kumamoto',
	'大分県' => 'Oita',
	'宮崎県' => 'Miyazaki',
	'鹿児島県' => 'Kagoshima',
	'沖縄県' => 'Okinawa',
}

# input
GLOBAL_CONFIRMED='https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv'
US_CONFIRMED='https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv'
CORONA_GO_JP='https://opendata.corona.go.jp/api/Covid19JapanAll'
CORONA_GO_JP_CUTOVER = Time.utc(2021, 1, 1)
JAPAN_CONFIRMED='https://raw.githubusercontent.com/kaz-ogiwara/covid19/master/data/prefectures.csv'
TOKYO_CONFIRMED='https://stopcovid19.metro.tokyo.lg.jp/data/130001_tokyo_covid19_patients.csv'

# running average
AVG_HALF_WIDTH  = 3 # days
AVG_STEP = 1  # days

# output
REGIONS='src/assets/regions.json'
FOOTNOTE='src/assets/footnote.json'

def parsedate(str)
	if str =~ %r[\d+/\d+/\d+]
		Time.strptime(str + ' +0000', '%m/%d/%y %z')
	elsif str =~ %r[\d{4,4}-\d\d-\d\d]
		Time.strptime(str + ' +0000', '%Y-%m-%d %z')
	else
		nil
	end
end

def parse_data(location, **opts)
  parser = opts[:parser] || CSV
  if parser == CSV
    parser_opts = {headers: true}
  else
    parser_opts = {}
  end
  if opts[:local]
    location = File.basename(location)  # to test this script locally
  end
  begin
    yield parser.parse(URI.open(location).read.gsub(/\r\n/, "\n"), **parser_opts)
  rescue OpenURI::HTTPError => error
    raise error.exception("#{location}: #{error.message}")
  end
end

def count_up_jhu(hash, row, region)
  row.each do |h, count|
    next unless count
    date = parsedate(h)
    next unless date
    begin
      i = Integer(count.sub(/\.0+$/, ''))
      if i > 0
        hash[region][date] += i
      end
    rescue TypeError => error
      raise error.exception(data.inspect)
    end
  end
end

if __FILE__ == $0
  timestamps = {refreshed: Time.now.utc}
  footnote =<<_END
Data were refreshed around #{Time.now.utc.strftime("%Y-%m-%d %H:%M %Z")}.
_END
  counts = Hash.new{|h, region| h[region] = Hash.new{|j, date| j[date] = 0}}

  $stderr.puts "Fetching and counting global data"
  parse_data(GLOBAL_CONFIRMED) do |x|
    x.each do |data|
      c = data['Country/Region'].strip
      s = data['Province/State']&.strip
      count_up_jhu(counts, data, [c])
      count_up_jhu(counts, data, [c, s]) if s and not s.empty?
      count_up_jhu(counts, data, ['World'])
    end
  end

  $stderr.puts "Fetching and counting data for US"
  parse_data(US_CONFIRMED) do |x|
    x.each do |data|
      c = data['Country_Region'].strip
      s = data['Province_State'].strip
      a = data['Admin2']&.strip
      count_up_jhu(counts, data, [c, s])
      count_up_jhu(counts, data, [c, s, a]) if a and not a.empty?
    end
  end
  footnote += <<_END
Global and US data are from <a href="https://github.com/CSSEGISandData/COVID-19">CSSEGISandData/COVID-19</a> &copy; 2020 Johns Hopkins University, educational and academic research purposes only.
_END

  $stderr.puts "Fetching and counting data for Japan for earlier data"
  parse_data(JAPAN_CONFIRMED) do |x|
    x.each do |data|
      date = Time.utc(data['year'], data['month'], data['date'])
      if date < CORONA_GO_JP_CUTOVER
        region = ['Japan', data['prefectureNameE'].strip]
        counts[region][date] = Integer(data['testedPositive'].gsub(/,/, ''))
      end
    end
  end
  footnote += <<_END
Data for Japan before #{CORONA_GO_JP_CUTOVER.strftime("%Y-%m-%d")} are from <a href="https://github.com/kaz-ogiwara/covid19">kaz-ogiwara/covid19</a> &copy; TOYO KEIZAI ONLINE.
_END

  $stderr.puts "Fetching and counting data for Japan"
  parse_data(CORONA_GO_JP, parser: JSON) do |json|
    json['itemList'].each do |data|
      date = parsedate(data['date'])
      if date >= CORONA_GO_JP_CUTOVER
        region = ['Japan', JAPAN_PREF_NAMES[data['name_jp']]]
        counts[region][date] = Integer(data['npatients'])
      end
    end
  end
  footnote += <<_END
Data for Japan are from and &copy; by <a href="https://corona.go.jp/dashboard/">Office for Novel Coronavirus Disease Control, Cabinet Secretariat, Government of Japan</a>.
_END

  $stderr.puts "Fetching and counting data for Tokyo"
  c = Hash.new{0}
  parse_data(TOKYO_CONFIRMED) do |x|
    x.each do |data|
      next unless data['公表_年月日']
      begin
        date = Time.strptime(data['公表_年月日'] + " UTC", "%Y-%m-%d %z")
      rescue NoMethodError => err
        raise err.exception(data.inspect)
      end
      c[date] += 1
    end
  end
  r = ['Japan', 'Tokyo']
  counts.delete(r)
  n = 0
  c.keys.sort.each do |date|
    n += c[date]
    counts[r][date] = n
  end
  footnote += <<_END
Data for Tokyo are from <a href="https://stopcovid19.metro.tokyo.lg.jp/">stopcovid19.metro.tokyo.lg.jp</a> &copy; 2020 Tokyo Metropolitan Government.
_END

  $stderr.puts "Listing regions"
  region_tree = Array.new
  r = counts.keys.sort
  i = 0
  n = r.length
  while i < n
    c = r[i][0]
    region_tree << {id: c, label: c}
    i += 1
    while i < n and c == r[i][0]
      cs = "#{r[i][0]}/#{r[i][1]}"
      region_tree.last[:children] ||= Array.new
      region_tree.last[:children] << {id: cs, label: r[i][1]}
      i += 1
      while i < n and cs == "#{r[i][0]}/#{r[i][1]}"
        csa = "#{r[i][0]}/#{r[i][1]}/#{r[i][2]}"
        region_tree.last[:children].last[:children] ||= Array.new
        region_tree.last[:children].last[:children] << {id: csa, label: r[i][2]}
        i += 1
      end
    end
  end
  File.open(REGIONS, 'w') do |f|
    f.print region_tree.to_json
  end

  footnote += <<_END
Check licenses and fork me at <a href="https://github.com/zunda/covid-vue-chart">zunda/covid-vue-chart</a>.
_END

  $stderr.puts "Calculating moving average"
  new_cases = Hash.new{|h, region| h[region] = Hash.new{|j, date| j[date] = 0}}
  avg_half_width = AVG_HALF_WIDTH * 24 * 3600
  avg_step = AVG_STEP * 24 * 3600
  counts.each_pair do |region, cumul|
    dates = cumul.keys.sort

    p = 0
    diffs = dates.map{|d| x = cumul[d] - p; p = cumul[d]; [d, x]}.to_h

    i1 = 0
    i2 = 0
    imax = dates.length

    d1 = dates.first - avg_half_width
    d2 = dates.last - avg_half_width
    d1.to_i.step(d2.to_i, avg_step).each do |x|
      d = Time.at(x).utc
      dmin = d - avg_half_width
      dmax = d + avg_half_width
      while i1 < imax and dates[i1] < dmin
        i1 += 1
      end
      if i2 < i1
        i2 = i1
      end
      while i2 < imax and dates[i2] <= dmax
        i2 += 1
      end
      if i2 - i1 > 0
        new_cases[region][d] = dates[i1...i2].map{|x| diffs[x]}.inject(0.0, :+) / (i2 - i1)
      else
        new_cases[region][d] = 0
      end
    end
  end

  $stderr.puts "Formatting data"
  {cumulativeCases: counts, newCases: new_cases}.each_pair do |type, input|
    input.each_pair do |r, c|
      ts = c.keys.sort
      data = ts.map{|d| {x: d.to_i * 1000, y: c[d]}}

      dst = "public/#{type}/#{r.join("/")}.json.gz"
      FileUtils.mkdir_p(File.dirname(dst))
      File.open(dst, 'w') do |f|
        gz = Zlib::GzipWriter.new(f)
        gz.write data.to_json
        gz.close
      end
      ts = Time.at(ts[-1])
      FileUtils.touch(dst, mtime: ts)
    end
  end

  File.open(FOOTNOTE, 'w') do |f|
    f.print footnote.to_json
  end
end
