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

		json = RestClient.get "http://localhost:9010/job/list"
		return json

	end

	def write_to_db(json, db_connection, db_dataset)

		jobs = JSON.parse(json)

		jobs.each do |item|
			item.each do |k, v|
				
			end
		end

		db_connection.transaction do
		    db_dataset.insert(
		      :path_suffix => "#{inner_dir}",
		      :path_type => "DIRECTORY",
		      :space_consumed => "#{space_consumed}",
		      :space_quota => "#{space_quota}",
		      :space_used => "#{space_used}",
		      :file_count => "#{file_count}",
		      :user => "#{user}",
		      :group => "#{group}",
		      :access_time => "#{access_time}",
		      :replication => "#{replication}",
		      :permission => "#{permission}",
		      :block_size => "#{block_size}",
		      :created_at => @created_at = Time.now
		      )
		    end

		
	end
end