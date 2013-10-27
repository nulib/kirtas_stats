require 'yaml'

class RunStatsSQL
  attr_reader :config

  def initialize
    @config = YAML::load( File.open( 'config/database.yml' ) )[ "repository" ][ "production" ]
  end

  def run_mysql_test
    `mysql >& mysql_out`
  end

  def run_mysql_test_connect
    `mysql -h #{ @config[ "host" ] } -u #{ @config[ "username" ] } -p#{ @config[ "password" ] } #{ @config[ "database" ] } -e "show tables;" >& mysql_out`
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
    file_exist = File.exist?( 'mysql_out' )
    File.delete( 'mysql_out' )

    expect( file_exist ).to be_true
  end

  it "captures the output of the mysql client" do
    c = RunStatsSQL.new
    c.run_mysql_test
    f = File.open( 'mysql_out' )
    file_contents = f.readlines.first.start_with?( "ERROR" )
    f.close
    File.delete( f )

    expect( file_contents ).to be_true
  end

  it "connects to the MySQL database on Repository" do
    sample_output = %w[
      Tables_in_jbpmdb
      HILOSEQUENCES
      JBPM_ACTION
      JBPM_BYTEARRAY
      JBPM_BYTEBLOCK
      JBPM_COMMENT
      JBPM_DECISIONCONDITIONS
      JBPM_DELEGATION
      JBPM_EVENT
      JBPM_EXCEPTIONHANDLER
      JBPM_ID_GROUP
      JBPM_ID_MEMBERSHIP
      JBPM_ID_PERMISSIONS
      JBPM_ID_USER
      JBPM_JOB
      JBPM_LOG
      JBPM_MODULEDEFINITION
      JBPM_MODULEINSTANCE
      JBPM_NODE
      JBPM_POOLEDACTOR
      JBPM_PROCESSDEFINITION
      JBPM_PROCESSINSTANCE
      JBPM_RUNTIMEACTION
      JBPM_SWIMLANE
      JBPM_SWIMLANEINSTANCE
      JBPM_TASK
      JBPM_TASKACTORPOOL
      JBPM_TASKCONTROLLER
      JBPM_TASKINSTANCE
      JBPM_TOKEN
      JBPM_TOKENVARIABLEMAP
      JBPM_TRANSITION
      JBPM_VARIABLEACCESS
      JBPM_VARIABLEINSTANCE
      JMS_MESSAGES
      JMS_ROLES
      JMS_SUBSCRIPTIONS
      JMS_TRANSACTIONS
      JMS_USERS
      TIMERS ]

    c = RunStatsSQL.new
    c.run_mysql_test_connect
    f = File.open( 'mysql_out' )
    output = f.readlines.each { |line| line.chomp! }
    f.close
    File.delete( f )

    expect( output ).to eql( sample_output )
  end
end