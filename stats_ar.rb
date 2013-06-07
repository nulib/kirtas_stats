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
end

class JobInfo < ActiveRecord::Base
  self.table_name = "JBPM_VARIABLEINSTANCE"
end

##########################

def get_all_jobs_hash
  something = Hash.new
  ProcessInstance.all.each do |process|
    something[ process.ID_ ] = process.attributes
    # all_jobs_hash[ process.ID_.to_s ] => process.attributes
  end
  something
end

all_jobs = get_all_jobs_hash
# p all_jobs.first
p all_jobs[ 6252 ]

current_jobs = 0
all_jobs.each { |key, value| current_jobs += 1 if value[ "END_" ] == nil && value[ "PROCESSDEFINITION_" ] > 10 }
p current_jobs

# p all_jobs
# p all_jobs.count

def get_open_jobs
  ProcessInstance.where( "END_ is null and PROCESSDEFINITION_ > 10" )
end

def get_job_info( job_num )
  JobInfo.where( "PROCESSINSTANCE_ = ?", job_num )
end

def get_job_info_hash( job_info )
  job_info_hash = {}
  job_info.each { |job| job_info_hash = { job.STRINGVALUE_ => job.NAME_ } }
  p job_info_hash
end

def get_all_tasks
  Task.all
end

def get_job_tasks( job_num )
  Task.where( "PROCINST_ = ?", job_num )
end


# jobs = ProcessInstance.new
# job_info = JobInfo.new

# open_jobs = get_open_jobs()
# puts open_jobs.count

# open_jobs.each do |job|
#   p "#{ job.ID_ } has #{ get_job_tasks( job ).count }"
#   # p "#{job.ID_} latest status is #{get_job_tasks( job ).each { |task| max task.START_ }}"
# end


# open_jobs.each do |job|
#   a_job = job_info.get_job_info( job.ID_ )
#   a_job_hash = {}
#   a_job.each { |job| a_job_hash[ job.NAME_ ] = job.STRINGVALUE_ }
#   p a_job_hash[ "electronic_bib_id" ]
#   p a_job_hash[ "title" ]
# end



# open_jobs.each do |job|
#   job_num = job.ID_
#   # job_title = job_info.get_job_info( job_num )
#   # job_info.get_job_info( job_num ).each { |info| p job_num.to_s + " - " + info.STRINGVALUE_ if info.NAME_ == "title" }
#   p get_job_info_hash( get_job_info( job_num ) )
# end
# p job_info.get_job_info( open_jobs.first.ID_ ).last.NAME_
