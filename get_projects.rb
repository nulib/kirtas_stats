require 'net/http'
require 'json'


module ProjectList

  def self.get_projects
    uri = URI( 'http://repository.library.northwestern.edu/jbpm-console/mbservices/getprojects' )
    projects_json = Net::HTTP.get( uri )
    
    projects_hash = JSON.parse( projects_json )
    
    projects = {}
    projects_hash[ 'root' ].each do |el|
      projects[ el[ "PROJECT_ID" ] ] = el[ "PROJECT_NAME" ]
    end
    
    return projects
  end

  def self.project_index_to_name( index = nil )
    project_list_hash = get_projects
    index.nil? ? "All Books" : project_list_hash[ index ]
  end

end