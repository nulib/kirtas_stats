require_relative '../kirtas_stats_sql'


class KirtasStatsSQL

  def jobs_started_this_year
    yearly_start = GetDates::yearly_start_end.first
    yearly_end   = GetDates::yearly_start_end.last

    @BASE_SQL <<
    "and t.START_ between '#{ yearly_start }' and '#{ yearly_end }';"
  end

  def jobs_started_this_quarter
    quarterly_start = GetDates::quarterly_start_end.first
    quarterly_end   = GetDates::quarterly_start_end.last

    @BASE_SQL <<
    "and t.START_ between '#{ quarterly_start }' and '#{ quarterly_end }';"
  end

  def jobs_started_this_month
    monthly_start = GetDates::monthly_start_end.first
    monthly_end   = GetDates::monthly_start_end.last

    @BASE_SQL <<
    "and t.START_ between '#{ monthly_start }' and '#{ monthly_end }';"
  end

  def jobs_done_this_year
    yearly_start = GetDates::yearly_start_end.first
    yearly_end   = GetDates::yearly_start_end.last

    @BASE_SQL <<
    "and n.NAME_ = 'Book Done' " <<
    "and t.END_ between '#{ yearly_start }' and '#{ yearly_end }';"
  end

  def jobs_done_this_quarter
    quarterly_start = GetDates::quarterly_start_end.first
    quarterly_end   = GetDates::quarterly_start_end.last

    @BASE_SQL <<
    "and n.NAME_ = 'Book Done' " <<
    "and t.END_ between '#{ quarterly_start }' and '#{ quarterly_end }';"
  end

  def jobs_done_this_month
    monthly_start = GetDates::monthly_start_end.first
    monthly_end   = GetDates::monthly_start_end.last

    @BASE_SQL <<
    "and n.NAME_ = 'Book Done' " <<
    "and t.END_ between '#{ monthly_start }' and '#{ monthly_end }';"
  end

  def jobs_killed_this_year
    yearly_start = GetDates::yearly_start_end.first
    yearly_end   = GetDates::yearly_start_end.last

    @BASE_SQL <<
    "and n.NAME_ != 'Book Done' " <<
    "and t.END_ is not NULL " <<
    "and t.END_ between '#{ yearly_start }' and '#{ yearly_end }';"
  end

  def jobs_killed_this_quarter
    quarterly_start = GetDates::quarterly_start_end.first
    quarterly_end   = GetDates::quarterly_start_end.last

    @BASE_SQL <<
    "and n.NAME_ != 'Book Done' " <<
    "and t.END_ is not NULL " <<
    "and t.END_ between '#{ quarterly_start }' and '#{ quarterly_end }';"
  end

  def jobs_killed_this_month
    monthly_start = GetDates::monthly_start_end.first
    monthly_end   = GetDates::monthly_start_end.last

    @BASE_SQL <<
    "and n.NAME_ != 'Book Done' " <<
    "and t.END_ is not NULL " <<
    "and t.END_ between '#{ monthly_start }' and '#{ monthly_end }';"
  end

end




describe KirtasStatsSQL do

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
  
      k = KirtasStatsSQL.new
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
  
      k = KirtasStatsSQL.new
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
        "and t.START_ between '2013-10-01' and '2013-10-31';"
  
      k = KirtasStatsSQL.new
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
  
      k = KirtasStatsSQL.new
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
  
      k = KirtasStatsSQL.new
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
        "and t.END_ between '2013-10-01' and '2013-10-31';"
  
      k = KirtasStatsSQL.new
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
  
      k = KirtasStatsSQL.new
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
  
      k = KirtasStatsSQL.new
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
        "and t.END_ between '2013-10-01' and '2013-10-31';"
  
      k = KirtasStatsSQL.new
      expect( k.jobs_killed_this_month ).to eq( jobs_killed_this_month_sql )
  
    end
  end

end