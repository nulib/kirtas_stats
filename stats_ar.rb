  require 'active_record'
require 'yaml'
require 'csv'
require_relative 'get_projects'
require_relative 'get_dates'

# Database configuration loaded from file
config = YAML::load(
    File.open('config/database.yml'))

# Database connection initiated
ActiveRecord::Base.establish_connection(
    config["development"])

# Create a class for each table used from jbpmdb
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

# The KirtasStats class gathers statistics by querying a MySQL database
class KirtasStats
  include ProjectList
  include GetDates


  # @@fiscal_start and @@fiscal_end are class variables
  # The class can be used for all books or books from a specific project
  # Using class vars means we can ask the user to set the dates once
  # and use the same date across multiple instances (an instance per project)

  @@fiscal_start = @@fiscal_end = nil
  @@period_start = @@period_end = nil

  @@CSV_FILE = "csv_output/stats-#{Time.now.strftime( "%Y-%m-%d-%H-%M-%S" )}.csv"

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
    
    unless @@fiscal_start && @@fiscal_end
      @@fiscal_start, @@fiscal_end = GetDates::fiscal_start_end
    end

    unless @@period_start && @@period_end
      @@period_start, @@period_end = GetDates::period_start_end
    end
  end
  
  def status_stats_this_period( arr )
    status_stats = {}
    arr.each do |status|
      status_sql = "
        and n.NAME_ = '#{status}'
        and t.END_ is NULL"
      sql = @BASE_SQL + status_sql + @PROJECT_SQL
      status_stats[ status ] = Token.find_by_sql( sql )
    end
    return status_stats
  end
  
  # Find the number of jobs that ended but were not at 'Book Done' (killed)
  def jobs_killed_this_period
    jobs_killed_monthly_sql = "
      and n.NAME_ != 'Book Done'
      and t.END_ is not NULL
      and t.END_ between '#{@@period_start}' and '#{@@period_end}'"
    Token.find_by_sql( @BASE_SQL + jobs_killed_monthly_sql + @PROJECT_SQL )
  end
  
  # Find the number of jobs sent to the 'Approve' stage (complete but awaiting copyright review)
  def jobs_approved_this_period
    jobs_approved_monthly_sql = "
      and n.NAME_ = 'Approve'
      and t.START_ >= '#{@@fiscal_start}'
      and t.NODEENTER_ between '#{@@period_start}' and '#{@@period_end}'"
    Token.find_by_sql( @BASE_SQL + jobs_approved_monthly_sql + @PROJECT_SQL )
  end
  
  # Find the jobs created between the beginning of the fiscal year and the end of the specified period
  def jobs_created_this_fiscal_year
    jobs_created_sql = "
      and t.START_ between '#{@@fiscal_start}' and '#{@@period_end}'"
    query = @BASE_SQL + jobs_created_sql + @PROJECT_SQL
    Token.find_by_sql( @BASE_SQL + jobs_created_sql + @PROJECT_SQL )
  end
  
  # Find the jobs sent to 'Book Done' during the specified period
  def books_done_this_period
    books_done_yearly_sql = "
      and n.NAME_ = 'Book Done'
      and t.END_ between '#{@@period_start}' and '#{@@period_end}'"
    sql = @BASE_SQL + books_done_yearly_sql + @PROJECT_SQL
    Token.find_by_sql( sql )
  end
  
  # Find the jobs that were created this fiscal year and are active at the end of the specified period
  def jobs_active_this_fiscal_year
    jobs_active_sql = "
      and t.END_ is NULL
      and t.NODE_ > 351
      and t.NODEENTER_ between '#{@@fiscal_start}' and '#{@@period_end}'"
    Token.find_by_sql( @BASE_SQL + jobs_active_sql + @PROJECT_SQL )
  end

  # Format and display the stats to the terminal
  def display_stats
    puts ""
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

  # Format and save the stats to a CSV file
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