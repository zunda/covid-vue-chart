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

# input
GLOBAL_CONFIRMED='https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv'
US_CONFIRMED='https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_US.csv'
JAPAN_CONFIRMED='https://raw.githubusercontent.com/kaz-ogiwara/covid19/master/data/prefectures.csv'

# output
REGIONS='src/assets/regions.json'
TIMESERIES='src/assets/timeSeries.json'

def parsedate(str)
	if str =~ %r[\d+/\d+/\d+]
		Time.strptime(str + ' +0000', '%m/%d/%y %z')
	else
		nil
	end
end

def count_up_jhu(hash, row, region)
  row.each do |h, count|
    next unless count
    date = parsedate(h)
    next unless date
    begin
      i = Integer(count)
      if i > 0
        hash[region][date] += i
      end
    rescue TypeError => error
      raise error.exception(data.inspect)
    end
  end
end

counts = Hash.new{|h, region| h[region] = Hash.new{|j, date| j[date] = 0}}

$stderr.puts "Fetching and counting global data"
CSV.parse(open(GLOBAL_CONFIRMED).read, headers:true).each do |data|
  c = data['Country/Region'].strip
  s = data['Province/State']&.strip
  count_up_jhu(counts, data, [c])
  count_up_jhu(counts, data, [c, s]) if s and not s.empty?
  count_up_jhu(counts, data, ['World'])
end

$stderr.puts "Fetching and counting data for US"
CSV.parse(open(US_CONFIRMED).read, headers:true).each do |data|
  c = data['Country_Region'].strip
  s = data['Province_State'].strip
  a = data['Admin2']&.strip
  count_up_jhu(counts, data, [c, s])
  count_up_jhu(counts, data, [c, s, a]) if a and not a.empty?
end

$stderr.puts "Fetching and counting data for Japan"
CSV.parse(open(JAPAN_CONFIRMED).read, headers:true).each do |data|
  region = ['Japan', data['都道府県'].strip]
  date = Time.utc(data['年'], data['月'], data['日'])
  counts[region][date] += Integer(data['患者数（2020年3月28日からは感染者数）'])
end

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

$stderr.puts "Formatting data"
time_series = Hash.new
counts.each_pair do |r, c|
  time_series[r.join("/")] = c.keys.sort.map{|d| {x: d.strftime("%Y-%m-%d"), y: c[d]}}
end
File.open(TIMESERIES, 'w') do |f|
  f.print time_series.to_json
end
