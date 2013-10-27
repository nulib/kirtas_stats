require 'yaml'

class RunStatsSQL
  attr_reader :config

  def initialize
    @config = YAML::load( File.open( 'config/database.yml' ) )[ "repository" ][ "development" ]
  end

  def run_mysql_test
    `mysql >& mysql_out`
  end
end

describe RunStatsSQL do

  it "reads a configuration file" do
    c = RunStatsSQL.new

    expect( c.config[ 'database' ] ).to eql( 'jbpmdb' )
  end

  it "runs the mysql client" do
    c = RunStatsSQL.new
    c.run_mysql_test
    f = File.open( 'mysql_out' )
    file_new = ( f.ctime < Time.now ) && ( f.ctime > Time.now - 60 )
    f.close
    File.delete( f )

    expect( file_new ).to be_true
  end

  it "captures the output of the mysql client" do
    c = RunStatsSQL.new
    c.run_mysql_test
    f = File.open( 'mysql_out' )
    file_exist = f.readlines.first.start_with?( "ERROR" )
    f.close
    File.delete( f )

    expect( file_exist ).to be_true
  end
end