require_relative 'kirtas_stats_sql'
require_relative 'get_projects'

require 'yaml'

include ProjectList

stats_sql = KirtasStatsSQL.new
stats_sql.write_stats

project_list_hash = ProjectList::get_projects
project_list_hash.each do |key, value|
  project_stats_sql = KirtasStatsSQL.new( key )
  project_stats_sql.write_stats
end

infile  = "sql_input/sql-#{stats_sql.run_time}.in"
outfile = "sql_output/sql-#{stats_sql.run_time}.out"

# Database configuration loaded from file
config = YAML::load(
    File.open('config/database.yml'))[ "production" ]

`mysql -h #{ config[ "host" ] } -u #{ config[ "username" ] } -p#{ config[ "password" ] } --skip-column-names #{config[ "database" ] } < #{infile} > #{outfile}`

daily = stats_sql.run_time.slice( 0, 10 )
f = File.readlines( outfile ).each_slice( 2 ).to_a
h = Hash.new { |k, v| v = Hash.new }

f.each do |pair|
  a, b = pair.first.chomp.split( ',' )
  c = pair.last.chomp.to_i
  h[ a ] = h[ a ].merge( Hash[ b, c ] )
end

daily_hash = Hash[ daily, h ]

