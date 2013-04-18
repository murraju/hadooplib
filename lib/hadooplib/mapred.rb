# Author:: Murali Raju (<murali.raju@appliv.com>)
# Copyright:: Copyright (c) 2013 Murali Raju.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# This implementation uses huahin-manager for MapReduce until mapred/mapreduce api issues are resolved.
# There currently is a problem importing JobClient within JRuby. Extending huahin-manager is another option. 

class MapReduce

	def initialize
		#TODO - pass url as part of configuration
		@mapred_rest_api_url = "http://localhost:9010"
	end

	def get_all_jobs
		json = RestClient.get "#{@mapred_rest_api_url}/job/list"
		return json
	end

	def write_to_db(json, db_connection, db_dataset)
		jobs = JSON.parse(json)

		jobs.each do |item|
			job_id = item['jobid']
			map_complete_percent = item['mapComplete']
			job_name = item['name']
			job_priority = item['priority']
			reduce_complete_percent = item['reduceComplete']
			scheduling_info = item['schedulingInfo']
			start_time = item['startTime']
			job_state = item['state']
			user = item['user']

			db_connection.transaction do
			    db_dataset.insert(
			      :job_id => "#{job_id}",
			      :map_complete_percent => "#{map_complete_percent}",
			      :job_name => "#{job_name}",
			      :job_priority => "#{job_priority}",
			      :reduce_complete_percent => "#{reduce_complete_percent}",
			      :scheduling_info => "#{scheduling_info}",
			      :start_time => "#{start_time}",
			      :job_name => "#{job_name}",
			      :job_state => "#{job_state}",
			      :user => "#{user}",
			      :created_at => @created_at = Time.now
			      )
			 end
			 puts "Created record #{job_id}:#{map_complete_percent}:#{job_name}:#{job_priority}:#{reduce_complete_percent}:#{scheduling_info}:#{start_time}:#{job_name}:#{job_state}:#{user}"
		end		
	end
end