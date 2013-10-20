require_relative '../generate_stats_sql.rb'

class WriteStatsSQL

  def write_file

    f = File.open( 'sql_input/sql-2013-10-20.in', 'a' )
    f.close

  end

end

describe WriteStatsSQL do

  it 'writes a file containing all the stats SQL statements' do
    w = WriteStatsSQL.new
    w.write_file

    expect( f = File.open( 'sql_input/sql-2013-10-20.in' ) ).to_not be_nil
  end
  
end