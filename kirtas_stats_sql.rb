require_relative 'get_projects'
require_relative 'get_dates'

# The KirtasStats class gathers statistics by querying a MySQL database
class KirtasStatsSQL
  include ProjectList
  include GetDates

  attr_reader :run_time


  # @@fiscal_start and @@fiscal_end are class variables
  # The class can be used for all books or books from a specific project
  # Using class vars means we can ask the user to set the dates once
  # and use the same date across multiple instances (an instance per project)

  @@fiscal_start = @@fiscal_end = nil
  @@period_start = @@period_end = nil

  @@run_time = Time.now.strftime( "%Y-%m-%d-%H-%M-%S" )

  

  def initialize( project = nil )

    @project = project

    @run_time = @@run_time
    @filename = "sql_input/sql-#{@run_time}.in"

    @BASE_SQL = "
SELECT count( * )
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
  
  def append_to_sql_infile( description, sql )
    File.open( @filename, "a" ) do |file|
      project = ProjectList::project_index_to_name( @project )
      file.write( "SELECT '#{ project },#{ description }' AS ' ';" )
      file.write( @BASE_SQL + sql + @PROJECT_SQL + ";\n\n" )
    end
  end

  # Find the jobs sent to 'Book Done' during the specified period
  # Book start: anytime
  # Book approve: monthly
  def books_done_this_period
    books_done_this_period_sql = "
and n.NAME_ = 'Book Done'
and t.END_ between '#{@@period_start}' and '#{@@period_end}'"
    append_to_sql_infile( __method__, books_done_this_period_sql )
  end
  
  # Find the jobs created between the beginning of the fiscal year and the end of the specified period
  # Job start: this month
  def jobs_created_this_fiscal_year
    jobs_created_sql = "
and t.START_ between '#{@@fiscal_start}' and '#{@@period_end}'"
    append_to_sql_infile( __method__, jobs_created_sql )
  end
  
  # Find the number of jobs sent to the 'Approve' stage (complete but awaiting copyright review)
  # Job start: this year
  # Job to approve: current period
  def jobs_approved_this_period
    jobs_approved_this_period_sql = "
and n.NAME_ = 'Approve'
and t.START_ >= '#{@@fiscal_start}'
and t.NODEENTER_ between '#{@@period_start}' and '#{@@period_end}'"
    append_to_sql_infile( __method__, jobs_approved_this_period_sql )
  end

  # Find the jobs that were created this fiscal year and are active at the end of the specified period
  # Job start: this year
  # Job end: null
  def jobs_active_this_fiscal_year
    jobs_active_sql = "
and t.END_ is NULL
and t.NODE_ > 351
and t.START_ >= '#{@@fiscal_start}'"
    append_to_sql_infile( __method__, jobs_active_sql )
  end

  # Find the number of jobs that ended but were not at 'Book Done' (killed)
  # Job start: anytime
  # Killed: this period
  def jobs_killed_this_period
    jobs_killed_this_period_sql = "
and n.NAME_ != 'Book Done'
and t.END_ is not NULL
and t.END_ between '#{@@period_start}' and '#{@@period_end}'"
    append_to_sql_infile( __method__, jobs_killed_this_period_sql )
  end
  
  def status_stats_this_period
    @SELECT_STATUSES.each do |status|
      status_sql = "
and n.NAME_ = '#{status}'
and t.END_ is NULL"
      append_to_sql_infile( "at_" + status.downcase.gsub( /\s/, '_' ), status_sql )
    end
  end

  def write_stats
    books_done_this_period
    jobs_created_this_fiscal_year
    jobs_approved_this_period
    jobs_killed_this_period
    jobs_active_this_fiscal_year
    status_stats_this_period  
  end

end
