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




class HDFS
  
  # Initialize
  # Default Name example - hdfs://localhost:8020
  # Path example - '/'
  
  def initialize(default_name, path)
    conf = Configuration.new
    conf.set("fs.default.name", default_name)
    @fs=org.apache.hadoop.fs.FileSystem.get(conf)
    @top_dir=Path.new(path)
    @uri=@fs.get_uri.to_s
    @cs = ContentSummary.new
    @hdfs_items = []
    @total_file_count = 0
    @total_dir_count = 0
    
    #Explicit return vs Ruby last
    return @fs, @top_dir, @uri, @cs, @hdfs_items,  @total_file_count, @total_dir_count 
  end

  

  def hdfs_recurse(top_dir, fs, uri, cs)
    
    outer_fs = fs.list_status(top_dir)
    @total_dir_count += outer_fs.length
    outer_fs.each do |myfs|
      if myfs.is_dir
        inner_dir = myfs.get_path.to_s.gsub(uri, "")
        inner_path = Path.new(inner_dir)
        cs = fs.get_content_summary(inner_path)
        space_consumed = cs.get_space_consumed
        space_quota = cs.get_space_quota
        space_used = cs.get_length
        file_count = cs.file_count
        @total_file_count += file_count
        user = myfs.get_owner
        group = myfs.get_group
        file_access_time = myfs.get_modification_time
        access_time = Time.at(file_access_time).to_java(java.util.Date)
        items = {
          :inner_dir => "#{inner_dir}",
          :space_consumed => "#{space_consumed}",
          :space_quota => "#{space_quota}",
          :space_used => "#{space_used}",
          :file_count => "#{file_count}",
          :user => "#{user}",
          :group => "#{group}",
          :access_time => "#{access_time}"
        }
        @hdfs_items << items 
        #puts "#{inner_dir}:#{space_consumed}:#{space_quota}:#{space_used}:#{user}:#{group}:#{access_time}"
        hdfs_recurse(inner_path, fs, uri, cs)   
      end 
    end
    return @hdfs_items.to_json
  end

  def hdfs_recurse_write_to_db(top_dir, fs, uri, cs)
    
    outer_fs = fs.list_status(top_dir)
    @total_dir_count += outer_fs.length
    outer_fs.each do |myfs|
      if myfs.is_dir
        inner_dir = myfs.get_path.to_s.gsub(uri, "")
        inner_path = Path.new(inner_dir)
        cs = fs.get_content_summary(inner_path)
        space_consumed = cs.get_space_consumed
        space_quota = cs.get_space_quota
        space_used = cs.get_length
        file_count = cs.file_count
        @total_file_count += file_count
        user = myfs.get_owner
        group = myfs.get_group
        file_access_time = myfs.get_modification_time
        access_time = Time.at(file_access_time).to_java(java.util.Date)
        @db_connection.transaction do
              @dataset.insert(
                :inner_dir => "#{inner_dir}",
                :space_consumed => "#{space_consumed}",
                :space_quota => "#{space_quota}",
                :space_used => "#{space_used}",
                :file_count => "#{file_count}",
                :user => "#{user}",
                :group => "#{group}",
                :access_time => "#{access_time}",
                :created_at => @created_at = Time.now
                ) 
        end
        puts "Created record #{inner_dir}:#{space_consumed}:#{space_quota}:#{space_used}:#{user}:#{group}:#{access_time}"
        hdfs_recurse(inner_path, fs, uri, cs)   
      end 
    end
  end

end












