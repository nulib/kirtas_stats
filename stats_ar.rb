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
config_repo = YAML::load( File.open( 'config/database.yml' ) )[ "repository" ][ "production" ]

`mysql -h #{ config_repo[ "host" ] } -u #{ config_repo[ "username" ] } -p#{ config_repo[ "password" ] } --skip-column-names #{ config_repo[ "database" ] } < #{ infile } > #{ outfile }`

daily = stats_sql.run_time.slice( 0, 10 )
f = File.readlines( outfile ).each_slice( 2 ).to_a
h = Hash.new { |k, v| v = Hash.new }

f.each do |pair|
  a, b = pair.first.chomp.split( ',' )
  c = pair.last.chomp.to_i
  h[ a ] = h[ a ].merge( Hash[ b, c ] )
end

daily_hash = Hash[ daily, h ]
sql_insert_filename = "sql_insert/sql-insert-" + daily + ".sql"

f = File.new( sql_insert_filename, "a+" )

daily_hash.each do |daily_key, proj_hash|
  proj_hash.each do |proj_key, stats_hash|
    sql_insert_table = "INSERT INTO dailies( daily_date, project"
    sql_insert_values = " ) VALUES ( " + daily_key.to_s
    sql_insert_values += ", " + proj_key.to_s
    stats_hash.each do |stats_key, value|
      sql_insert_table += ", " + stats_key.to_s
      sql_insert_values += ", " + value.to_s
  end
  f.puts sql_insert_table + sql_insert_values + ");"
  end
end

f.close

config_test = YAML::load( 
  File.open( 'config/database.yml' ) )[ "local" ][ "development" ]

`mysql -h #{ config_test[ "host" ] } -u #{ config_test[ "username" ] } -p#{ config_test[ "password" ] } #{ config_test[ "database" ] } < #{sql_insert_filename}`
