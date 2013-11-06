require_relative '../generate_stats_sql.rb'

class WriteStatsSQL

  def write_file
    k = GenerateStatsSQL.new

    f = File.open( 'sql_input/sql-2013-10-20.in', 'w' ) { |f|
      f.puts( k.jobs_started_this_year )
      f.puts( k.jobs_done_this_year )
      f.puts( k.jobs_killed_this_year )
      f.puts( k.jobs_started_this_quarter )
      f.puts( k.jobs_done_this_quarter )
      f.puts( k.jobs_killed_this_quarter )
      f.puts( k.jobs_started_this_month )
      f.puts( k.jobs_done_this_month )
      f.puts( k.jobs_killed_this_month )
    }
  end

end

describe WriteStatsSQL do

  it 'writes a file' do
    w = WriteStatsSQL.new
    w.write_file

    expect( f = File.open( 'sql_input/sql-2013-10-20.in' ) ).to_not be_nil
  end

  it 'writes all the appropriate SQL to the file' do

    today       = Date.today
    month_start = Date.new( today.year, today.month, 1 )
    month_end   = Date.new( today.year, today.month, -1 )
  
    jobs_started_this_year_sql = 
      "SELECT count( * ) " <<
      "FROM JBPM_TOKEN t " <<
      "LEFT JOIN JBPM_NODE n " <<
      "ON t.NODE_ = n.ID_ " <<
      "LEFT JOIN JBPM_VARIABLEINSTANCE v " <<
      "ON t.ID_ = v.PROCESSINSTANCE_ " <<
      "WHERE v.NAME_ = 'projects' " <<
      "and t.START_ between '2013-09-01' and '2014-08-31';"


    jobs_started_this_quarter_sql = 
      "SELECT count( * ) " <<
      "FROM JBPM_TOKEN t " <<
      "LEFT JOIN JBPM_NODE n " <<
      "ON t.NODE_ = n.ID_ " <<
      "LEFT JOIN JBPM_VARIABLEINSTANCE v " <<
      "ON t.ID_ = v.PROCESSINSTANCE_ " <<
      "WHERE v.NAME_ = 'projects' " <<
      "and t.START_ between '2013-09-01' and '2013-11-30';"


    jobs_started_this_month_sql = 
      "SELECT count( * ) " <<
      "FROM JBPM_TOKEN t " <<
      "LEFT JOIN JBPM_NODE n " <<
      "ON t.NODE_ = n.ID_ " <<
      "LEFT JOIN JBPM_VARIABLEINSTANCE v " <<
      "ON t.ID_ = v.PROCESSINSTANCE_ " <<
      "WHERE v.NAME_ = 'projects' " <<
      "and t.START_ between '#{month_start}' and '#{month_end}';"


    jobs_done_this_year_sql = 
      "SELECT count( * ) " <<
      "FROM JBPM_TOKEN t " <<
      "LEFT JOIN JBPM_NODE n " <<
      "ON t.NODE_ = n.ID_ " <<
      "LEFT JOIN JBPM_VARIABLEINSTANCE v " <<
      "ON t.ID_ = v.PROCESSINSTANCE_ " <<
      "WHERE v.NAME_ = 'projects' " <<
      "and n.NAME_ = 'Book Done' " <<
      "and t.END_ between '2013-09-01' and '2014-08-31';"


    jobs_done_this_quarter_sql = 
      "SELECT count( * ) " <<
      "FROM JBPM_TOKEN t " <<
      "LEFT JOIN JBPM_NODE n " <<
      "ON t.NODE_ = n.ID_ " <<
      "LEFT JOIN JBPM_VARIABLEINSTANCE v " <<
      "ON t.ID_ = v.PROCESSINSTANCE_ " <<
      "WHERE v.NAME_ = 'projects' " <<
      "and n.NAME_ = 'Book Done' " <<
      "and t.END_ between '2013-09-01' and '2013-11-30';"


    jobs_done_this_month_sql = 
      "SELECT count( * ) " <<
      "FROM JBPM_TOKEN t " <<
      "LEFT JOIN JBPM_NODE n " <<
      "ON t.NODE_ = n.ID_ " <<
      "LEFT JOIN JBPM_VARIABLEINSTANCE v " <<
      "ON t.ID_ = v.PROCESSINSTANCE_ " <<
      "WHERE v.NAME_ = 'projects' " <<
      "and n.NAME_ = 'Book Done' " <<
      "and t.END_ between '#{month_start}' and '#{month_end}';"


    jobs_killed_this_year_sql = 
      "SELECT count( * ) " <<
      "FROM JBPM_TOKEN t " <<
      "LEFT JOIN JBPM_NODE n " <<
      "ON t.NODE_ = n.ID_ " <<
      "LEFT JOIN JBPM_VARIABLEINSTANCE v " <<
      "ON t.ID_ = v.PROCESSINSTANCE_ " <<
      "WHERE v.NAME_ = 'projects' " <<
      "and n.NAME_ != 'Book Done' " <<
      "and t.END_ is not NULL " <<
      "and t.END_ between '2013-09-01' and '2014-08-31';"


    jobs_killed_this_quarter_sql = 
      "SELECT count( * ) " <<
      "FROM JBPM_TOKEN t " <<
      "LEFT JOIN JBPM_NODE n " <<
      "ON t.NODE_ = n.ID_ " <<
      "LEFT JOIN JBPM_VARIABLEINSTANCE v " <<
      "ON t.ID_ = v.PROCESSINSTANCE_ " <<
      "WHERE v.NAME_ = 'projects' " <<
      "and n.NAME_ != 'Book Done' " <<
      "and t.END_ is not NULL " <<
      "and t.END_ between '2013-09-01' and '2013-11-30';"


    jobs_killed_this_month_sql = 
      "SELECT count( * ) " <<
      "FROM JBPM_TOKEN t " <<
      "LEFT JOIN JBPM_NODE n " <<
      "ON t.NODE_ = n.ID_ " <<
      "LEFT JOIN JBPM_VARIABLEINSTANCE v " <<
      "ON t.ID_ = v.PROCESSINSTANCE_ " <<
      "WHERE v.NAME_ = 'projects' " <<
      "and n.NAME_ != 'Book Done' " <<
      "and t.END_ is not NULL " <<
      "and t.END_ between '#{month_start}' and '#{month_end}';"
    
    k = WriteStatsSQL.new
    k.write_file
    f = File.open( 'sql_input/sql-2013-10-20.in' ).readlines( "\n" ).each { |line| line.chomp! }

    expect( f ).to include( jobs_started_this_year_sql,
                            jobs_done_this_year_sql,
                            jobs_killed_this_year_sql,
                            jobs_started_this_quarter_sql,
                            jobs_done_this_quarter_sql,
                            jobs_killed_this_quarter_sql,
                            jobs_started_this_month_sql,
                            jobs_done_this_month_sql,
                            jobs_killed_this_month_sql )
  end

  it 'writes the appropriate SQL to the file once' do

    k = WriteStatsSQL.new
    k.write_file
    n = File.open( 'sql_input/sql-2013-10-20.in' ).readlines( "\n" ).count
    
    expect( n ).to eql( 9 )

  end
  
end