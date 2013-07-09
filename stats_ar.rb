require 'active_record'
require 'yaml'
require 'date'
require 'csv'
require_relative 'get_projects'

config = YAML::load(
    File.open('config/database.yml'))

ActiveRecord::Base.establish_connection(
    config["development"])

class Token < ActiveRecord::Base
	self.table_name = "JBPM_TOKEN"
end

class Node < ActiveRecord::Base
	self.table_name = "JBPM_NODE"
end

class JobInfo < ActiveRecord::Base
	self.table_name = "JBPM_VARIABLEINSTANCE"
end

##########################


class KirtasStats
	include ProjectList

	@@fiscal_start = @@fiscal_end = nil
	@@period_start = @@period_end = nil

	@@CSV_FILE = "stats-#{Time.now.strftime( "%Y-%m-%d-%H-%M-%S" )}.csv"

	def initialize( project = nil )

		@project = project

		@BASE_SQL = "
			SELECT t.ID_
			FROM JBPM_TOKEN t
			LEFT JOIN JBPM_NODE n
			ON t.NODE_ = n.ID_
			LEFT JOIN JBPM_VARIABLEINSTANCE v
			ON t.ID_ = v.PROCESSINSTANCE_
			WHERE v.NAME_ = 'projects'"
		
		@PROJECT_SQL = project.nil? ? "" : "
			and FIND_IN_SET( '#{project}', v.STRINGVALUE_ )"
		
		@SELECT_STATUSES = [
			"Scan",
			"Select File Move Destination",
			"Batch",
			"Touchup",
			"Quality Control",
			"Move to precopy node",
			"MoveProcessingFiles",
			"MoveFilesToArchival",
			"MoveFoldoutsToArchival",
			"Standard Pages Ingest Script",
			"Book Builder",
			"Associate rescans",
			"Confirm Foldouts Done",
			"Import Foldouts",
			"Foldout Ingest Script",
			"Approve",
			"PDF Generation Script" ]
		
		get_fiscal_start_end unless @@fiscal_start && @@fiscal_end
		get_period_start_end unless @@period_start && @@period_end
	end

	def get_fiscal_start_end
		@@fiscal_start = Date.parse( "2012-09-01" ).strftime( "%Y-%m-%d" )
		@@fiscal_end = Date.parse( "2013-08-31" ).strftime( "%Y-%m-%d" )

		puts "The current fiscal year is #{@@fiscal_start} to #{@@fiscal_end}."
		print "Enter a new fiscal start date (Enter to keep default): "
		new_fiscal_start = gets.chomp
		return if new_fiscal_start.empty?
		print "Enter a new fiscal end date: "
		new_fiscal_end = gets.chomp
		@@fiscal_start = Date.parse( new_fiscal_start ).strftime( "%Y-%m-%d" )
		@@fiscal_end = Date.parse( new_fiscal_end ).strftime( "%Y-%m-%d" )
	end

	def get_prev_month_start_end
		prev_month = Date.today.prev_month.month
		prev_month_year = Date.today.prev_month.year
		prev_month_start = Date.new( prev_month_year, prev_month, 1 ).strftime( "%Y-%m-%d" )
		prev_month_end = Date.new( prev_month_year, prev_month, -1 ).strftime( "%Y-%m-%d" )
		return prev_month_start, prev_month_end
	end

	def get_period_start_end
		@@period_start = get_prev_month_start_end.first
		@@period_end = get_prev_month_start_end.last

		puts "The current period is #{@@period_start} to #{@@period_end}."
		print "Enter a new period start date (Enter to keep default): "
		new_period_start = gets.chomp
		return if new_period_start.empty?
		print "Enter a new period end date: "
		new_period_end = gets.chomp
		@@period_start = Date.parse( new_period_start ).strftime( "%Y-%m-%d" )
		@@period_end = Date.parse( new_period_end ).strftime( "%Y-%m-%d" )
	end
	
	def status_stats_this_period( arr )
		status_stats = {}
		arr.each do |status|
			status_sql = "
				and n.NAME_ = '#{status}'
				and t.START_ between '#{@@fiscal_start}' and '#{@@period_end}'
				and t.END_ is NULL
				and t.NODEENTER_ >= '#{@@fiscal_start}'"
			sql = @BASE_SQL + status_sql + @PROJECT_SQL
			# puts sql
			status_stats[ status ] = Token.find_by_sql( sql )
		end
		return status_stats
	end
	
	def jobs_killed_this_period
		jobs_killed_monthly_sql = "
			and n.NAME_ != 'Book Done'
			and t.END_ is not NULL
			and t.END_ between '#{@@period_start}' and '#{@@period_end}'"
		Token.find_by_sql( @BASE_SQL + jobs_killed_monthly_sql + @PROJECT_SQL )
	end
	
	def jobs_approved_this_period
		jobs_approved_monthly_sql = "
			and n.NAME_ = 'Approve'
			and t.START_ >= '#{@@fiscal_start}'
			and t.NODEENTER_ between '#{@@period_start}' and '#{@@period_end}'"
		Token.find_by_sql( @BASE_SQL + jobs_approved_monthly_sql + @PROJECT_SQL )
	end
	
	def jobs_created_this_fiscal_year
		jobs_created_sql = "
			and t.START_ between '#{@@fiscal_start}' and '#{@@period_end}'"
		# p @@fiscal_start
		# p @@fiscal_end
		# p @@period_start
		# p @@period_end
		Token.find_by_sql( @BASE_SQL + jobs_created_sql + @PROJECT_SQL )
	end
	
	def books_done_this_period
		books_done_yearly_sql = "
			and n.NAME_ = 'Book Done'
			and t.END_ between '#{@@period_start}' and '#{@@period_end}'"
		sql = @BASE_SQL + books_done_yearly_sql + @PROJECT_SQL
		# puts sql
		Token.find_by_sql( sql )
	end
	
	def jobs_active_this_fiscal_year
		jobs_active_sql = "
			and t.END_ is NULL
			and t.NODE_ > 351
			and t.START_ between '#{@@fiscal_start}' and '#{@@period_end}'"
		Token.find_by_sql( @BASE_SQL + jobs_active_sql + @PROJECT_SQL )
	end

	def display_stats
		puts ""
		# p @@period_start
		# p @@period_end
		puts "Fiscal year:".ljust( 25, '. ' ) + "#{@@fiscal_start} - #{@@fiscal_end}"
		puts "Period:".ljust( 25, '. ' ) + "#{@@period_start} - #{@@period_end}"
		puts ""
		puts "jobs_created_this_fiscal_year:".ljust( 50, '. ' ) + "#{jobs_created_this_fiscal_year.size}"
		puts "jobs_active_this_fiscal_year:".ljust( 50, '. ' ) + "#{jobs_active_this_fiscal_year.size}"
		puts "books_done_this_period:".ljust( 50, '. ' ) + "#{books_done_this_period.size}"
		puts "jobs_killed_this_period:".ljust( 50, '. ' ) + "#{jobs_killed_this_period.size}"
		puts "\nJobs currently at ..."
		status_stats_this_period( @SELECT_STATUSES ).each do |key, value|
			puts "#{key}".ljust( 50, '. ' ) + "#{value.size}"
		end
	end

	def print_stats_to_csv
		CSV.open( @@CSV_FILE, "ab" ) do |csv|
			csv << [ "Collection", ProjectList::project_index_to_name( @project ) ]
			csv << [ "Fiscal year", "#{@@fiscal_start} - #{@@fiscal_end}" ]
			csv << [ "Period","#{@@period_start} - #{@@period_end}" ]
			csv << [ "jobs_created_this_fiscal_year","#{jobs_created_this_fiscal_year.size}" ]
			csv << [ "jobs_active_this_fiscal_year","#{jobs_active_this_fiscal_year.size}" ]
			csv << [ "books_done_this_period","#{books_done_this_period.size}" ]
			csv << [ "jobs_killed_this_period","#{jobs_killed_this_period.size}" ]
			status_stats_this_period( @SELECT_STATUSES ).each do |key, value|
				csv << [ "#{key}" , "#{value.size}" ]
			end
		end
	end
end

include ProjectList

stats = KirtasStats.new
puts ""
puts ProjectList::project_index_to_name
puts "*" * 50
stats.display_stats
stats.print_stats_to_csv

project_list_hash = ProjectList::get_projects
project_list_hash.each do |key, value|
	project_stats = KirtasStats.new( key )
	puts ""
	puts ProjectList::project_index_to_name( key )
	puts "*" * 50
	project_stats.display_stats
	project_stats.print_stats_to_csv
end