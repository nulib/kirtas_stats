require 'active_record'
require 'yaml'

config = YAML::load(
    File.open('config/database.yml'))

ActiveRecord::Base.establish_connection(
    config["development"])

class JBPM_TASKINSTANCE < ActiveRecord::Base
	self.table_name = "JBPM_TASKINSTANCE"

	def get_open_jobs
		JBPM_TASKINSTANCE.where( END_: nil )
	end
end

tasks = JBPM_TASKINSTANCE.new
open_jobs = tasks.get_open_jobs()
open_jobs.each { |job| puts job.PROCINST_ }