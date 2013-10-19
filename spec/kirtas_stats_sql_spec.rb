require_relative '../kirtas_stats_sql'


class KirtasStatsSQL

  def jobs_started_this_year

    @BASE_SQL +
    "and t.START_ between '2013-09-01' and '2014-08-31';"

  end

  def jobs_started_this_quarter

    @BASE_SQL +
    "and t.START_ between '2013-09-01' and '2013-11-30';"

  end

end




describe KirtasStatsSQL do

  it 'generates the SQL for jobs started in the current year' do

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

  it 'generates the SQL for jobs started in the current quarter' do

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

end