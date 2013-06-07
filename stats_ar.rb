require 'active_record'
require 'yaml'

config = YAML::load(
    File.open('config/database.yml'))

ActiveRecord::Base.establish_connection(
    config["development"])

class Task < ActiveRecord::Base
    self.table_name = "JBPM_TASKINSTANCE"
end

class ProcessInstance < ActiveRecord::Base
  self.table_name = "JBPM_PROCESSINSTANCE"

  def get_open_jobs
    ProcessInstance.where( "END_ is null and PROCESSDEFINITION_ > 10" )
  end
end

class JobInfo < ActiveRecord::Base
  self.table_name = "JBPM_VARIABLEINSTANCE"

  def get_job_info( job_num )
    JobInfo.where( "PROCESSINSTANCE_ = ?", job_num )
  end
end

def get_job_info_hash( job_info )
  job_info_hash = {}
  job_info.each { |job| job_info_hash = { job.STRINGVALUE_ => job.NAME_ } }
  p job_info_hash
end


jobs = ProcessInstance.new
job_info = JobInfo.new

open_jobs = jobs.get_open_jobs()
puts open_jobs.count

open_jobs.each do |job|
  a_job = job_info.get_job_info( job.ID_ )
  a_job_hash = {}
  a_job.each { |job| a_job_hash[ job.NAME_ ] = job.STRINGVALUE_ }
  p a_job_hash[ "electronic_bib_id" ]
  p a_job_hash[ "title" ]
end



# open_jobs.each do |job|
#   job_num = job.ID_
#   # job_title = job_info.get_job_info( job_num )
#   # job_info.get_job_info( job_num ).each { |info| p job_num.to_s + " - " + info.STRINGVALUE_ if info.NAME_ == "title" }
#   p get_job_info_hash( get_job_info( job_num ) )
# end
# p job_info.get_job_info( open_jobs.first.ID_ ).last.NAME_
