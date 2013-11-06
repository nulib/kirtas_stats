require_relative '../generate_stats_sql'

describe GenerateStatsSQL do

  today       = Date.today
  month_start = Date.new( today.year, today.month, 1 )
  month_end   = Date.new( today.year, today.month, -1 )


  context 'generates the SQL for jobs started ' do

    it 'in the current year' do
  
      jobs_started_this_year_sql = 
        "SELECT count( * ) " <<
        "FROM JBPM_TOKEN t " <<
        "LEFT JOIN JBPM_NODE n " <<
        "ON t.NODE_ = n.ID_ " <<
        "LEFT JOIN JBPM_VARIABLEINSTANCE v " <<
        "ON t.ID_ = v.PROCESSINSTANCE_ " <<
        "WHERE v.NAME_ = 'projects' " <<
        "and t.START_ between '2013-09-01' and '2014-08-31';"
  
      k = GenerateStatsSQL.new
      expect( k.jobs_started_this_year ).to eq( jobs_started_this_year_sql )
  
    end
  
    it 'in the current quarter' do
  
      jobs_started_this_quarter_sql = 
        "SELECT count( * ) " <<
        "FROM JBPM_TOKEN t " <<
        "LEFT JOIN JBPM_NODE n " <<
        "ON t.NODE_ = n.ID_ " <<
        "LEFT JOIN JBPM_VARIABLEINSTANCE v " <<
        "ON t.ID_ = v.PROCESSINSTANCE_ " <<
        "WHERE v.NAME_ = 'projects' " <<
        "and t.START_ between '2013-09-01' and '2013-11-30';"
  
      k = GenerateStatsSQL.new
      expect( k.jobs_started_this_quarter ).to eq( jobs_started_this_quarter_sql )
  
    end
  
    it 'in the current month' do
      
      jobs_started_this_month_sql = 
        "SELECT count( * ) " <<
        "FROM JBPM_TOKEN t " <<
        "LEFT JOIN JBPM_NODE n " <<
        "ON t.NODE_ = n.ID_ " <<
        "LEFT JOIN JBPM_VARIABLEINSTANCE v " <<
        "ON t.ID_ = v.PROCESSINSTANCE_ " <<
        "WHERE v.NAME_ = 'projects' " <<
        "and t.START_ between '#{month_start}' and '#{month_end}';"
  
      k = GenerateStatsSQL.new
      expect( k.jobs_started_this_month ).to eq( jobs_started_this_month_sql )
  
    end
  end
  context 'generates the SQL for jobs done ' do

    it 'in the current year' do
  
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
  
      k = GenerateStatsSQL.new
      expect( k.jobs_done_this_year ).to eq( jobs_done_this_year_sql )
  
    end
  
    it 'in the current quarter' do
  
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
  
      k = GenerateStatsSQL.new
      expect( k.jobs_done_this_quarter ).to eq( jobs_done_this_quarter_sql )
  
    end
  
    it 'in the current month' do

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
  
      k = GenerateStatsSQL.new
      expect( k.jobs_done_this_month ).to eq( jobs_done_this_month_sql )
  
    end
  end
  context 'generates the SQL for jobs killed ' do

    it 'in the current year' do
  
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
  
      k = GenerateStatsSQL.new
      expect( k.jobs_killed_this_year ).to eq( jobs_killed_this_year_sql )
  
    end
  
    it 'in the current quarter' do
  
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
  
      k = GenerateStatsSQL.new
      expect( k.jobs_killed_this_quarter ).to eq( jobs_killed_this_quarter_sql )
  
    end
  
    it 'in the current month' do
  
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
  
      k = GenerateStatsSQL.new
      expect( k.jobs_killed_this_month ).to eq( jobs_killed_this_month_sql )
  
    end
  end

  it 'generates the same SQL after multiple calls' do

    jobs_started_this_quarter_sql = 
      "SELECT count( * ) " <<
      "FROM JBPM_TOKEN t " <<
      "LEFT JOIN JBPM_NODE n " <<
      "ON t.NODE_ = n.ID_ " <<
      "LEFT JOIN JBPM_VARIABLEINSTANCE v " <<
      "ON t.ID_ = v.PROCESSINSTANCE_ " <<
      "WHERE v.NAME_ = 'projects' " <<
      "and t.START_ between '2013-09-01' and '2013-11-30';"
  
    k = GenerateStatsSQL.new
    k.jobs_started_this_quarter
    k.jobs_started_this_quarter
    k.jobs_started_this_quarter
    k.jobs_started_this_quarter
    expect( k.jobs_started_this_quarter ).to eq( jobs_started_this_quarter_sql )

  end

  it 'generates the same SQL when called in different order' do

    jobs_started_this_quarter_sql = 
      "SELECT count( * ) " <<
      "FROM JBPM_TOKEN t " <<
      "LEFT JOIN JBPM_NODE n " <<
      "ON t.NODE_ = n.ID_ " <<
      "LEFT JOIN JBPM_VARIABLEINSTANCE v " <<
      "ON t.ID_ = v.PROCESSINSTANCE_ " <<
      "WHERE v.NAME_ = 'projects' " <<
      "and t.START_ between '2013-09-01' and '2013-11-30';"
  
    k = GenerateStatsSQL.new
    k.jobs_started_this_year
    k.jobs_started_this_year
    k.jobs_started_this_year
    k.jobs_started_this_year
    expect( k.jobs_started_this_quarter ).to eq( jobs_started_this_quarter_sql )

  end

end