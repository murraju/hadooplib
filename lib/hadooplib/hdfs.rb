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
  
  
  def initialize(default_name, path, conf_dir, principal, keytab_file)
    
    # config files must be in classpath for hadoop to find them
    unless $CLASSPATH.include? conf_dir
      $CLASSPATH << conf_dir
    end

    core_site = jruby_class_loader.getResource("core-site.xml")
    hdfs_site = jruby_class_loader.getResource("hdfs-site.xml")
    
    puts ''
    raise "Could not find core-site.xml" unless core_site
    puts "Found #{core_site}"

    raise "Could not find hdfs-site.xml" unless hdfs_site
    puts "Found #{hdfs_site}"
    puts ''
    
    conf = Configuration.new
    #conf.set("fs.default.name", default_name)
    conf.get('fs.default.name')
    conf.set("hadoop.security.group.mapping", "org.apache.hadoop.security.ShellBasedUnixGroupsMapping")
    UserGroupInformation.setConfiguration(conf)
    puts "Logging in as #{principal} with keytab #{keytab_file}"
    UserGroupInformation.loginUserFromKeytab(principal, keytab_file)
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
    # Write to JSON
    outer_fs = fs.list_status(top_dir)
    @total_dir_count += outer_fs.length
    outer_fs.each do |myfs|
      if myfs.is_dir
        inner_dir = myfs.get_path.to_s.gsub(uri, "")
        inner_path = Path.new(inner_dir)
        cs = fs.get_content_summary(inner_path)
        replication = myfs.get_replication
        permission  = myfs.get_permission
        block_size  = myfs.get_block_size
        space_consumed = cs.get_space_consumed
        space_quota = cs.get_space_quota
        space_used = cs.get_length
        file_count = cs.file_count
        @total_file_count += file_count
        user = myfs.get_owner
        group = myfs.get_group
        access_time = java.util.Date.new(myfs.get_modification_time)
        #access_time = Time.at(file_access_time).to_java(java.util.Date)
        items = {
          :path_suffix => "#{inner_dir}",
          :path_type => "DIRECTORY",
          :space_consumed => "#{space_consumed}",
          :space_quota => "#{space_quota}",
          :space_used => "#{space_used}",
          :file_count => "#{file_count}",
          :user => "#{user}",
          :group => "#{group}",
          :access_time => "#{access_time}",
          :replication => "0",
          :permission => "#{permission}",
          :block_size => "#{block_size}"
        }
        @hdfs_items << items 
        #puts "#{inner_dir}:#{space_consumed}:#{space_quota}:#{space_used}:#{user}:#{group}:#{access_time}:#{replication}"
        hdfs_recurse(inner_path, fs, uri, cs)
      else
        dir_with_file = myfs.get_path.to_s.gsub(uri, "")
        user = myfs.get_owner
        group = myfs.get_group
        space_consumed = myfs.getLen
        space_used = myfs.getLen
        space_quota = '-1'
        file_count = '1'
        access_time = java.util.Date.new(myfs.get_modification_time)
        replication = myfs.get_replication
        permission  = myfs.get_permission
        block_size  = myfs.get_block_size
        items = {
          :path_suffix => "#{dir_with_file}",
          :path_type => "FILE",
          :space_consumed => "#{space_consumed}",
          :space_quota => "#{space_quota}",
          :space_used => "#{space_used}",
          :file_count => "#{file_count}",
          :user => "#{user}",
          :group => "#{group}",
          :access_time => "#{access_time}",
          :replication => "#{replication}",
          :permission => "#{permission}",
          :block_size => "#{block_size}"
        }
        @hdfs_items << items
        #puts "#{dir_with_file}:#{space_consumed}:#{space_quota}:#{space_used}:#{user}:#{group}:#{access_time}:#{replication}" 
      end 
    end
    return @hdfs_items.to_json
  end


# Original method without non_dir path

  # def hdfs_recurse(top_dir, fs, uri, cs)
    
  #   # Write to JSON
  #   outer_fs = fs.list_status(top_dir)
  #   @total_dir_count += outer_fs.length
  #   outer_fs.each do |myfs|
  #     if myfs.is_dir
  #       inner_dir = myfs.get_path.to_s.gsub(uri, "")
  #       inner_path = Path.new(inner_dir)
  #       cs = fs.get_content_summary(inner_path)
  #       replication = myfs.get_replication
  #       space_consumed = cs.get_space_consumed
  #       space_quota = cs.get_space_quota
  #       space_used = cs.get_length
  #       file_count = cs.file_count
  #       @total_file_count += file_count
  #       user = myfs.get_owner
  #       group = myfs.get_group
  #       access_time = java.util.Date.new(myfs.get_modification_time)
  #       #access_time = Time.at(file_access_time).to_java(java.util.Date)
  #       items = {
  #         :directory => "#{inner_dir}",
  #         :space_consumed => "#{space_consumed}",
  #         :space_quota => "#{space_quota}",
  #         :space_used => "#{space_used}",
  #         :file_count => "#{file_count}",
  #         :user => "#{user}",
  #         :group => "#{group}",
  #         :access_time => "#{access_time}",
  #         :replication => "#{replication}"
  #       }
  #       @hdfs_items << items 
  #       #puts "#{inner_dir}:#{space_consumed}:#{space_quota}:#{space_used}:#{user}:#{group}:#{access_time}:#{replication}"
  #       hdfs_recurse(inner_path, fs, uri, cs)   
  #     end 
  #   end
  #   return @hdfs_items.to_json
  # end

  
  def hdfs_recurse_write_to_stdout(top_dir, fs, uri, cs)
    # Write to STDOUT as csv
    # puts "Directory,Space Consumed,Space Quota,Space Used,File Count,Owner,Group,Modification Time, Replication"
    outer_fs = fs.list_status(top_dir)
    @total_dir_count += outer_fs.length
    outer_fs.each do |myfs|
      if myfs.is_dir
        inner_dir = myfs.get_path.to_s.gsub(uri, "")
        inner_path = Path.new(inner_dir)
        cs = fs.get_content_summary(inner_path)
        replication = fs.get_replication(inner_path)
        space_consumed = cs.get_space_consumed
        space_quota = cs.get_space_quota
        space_used = cs.get_length
        file_count = cs.file_count
        @total_file_count += file_count
        user = myfs.get_owner
        group = myfs.get_group
        access_time = java.util.Date.new(myfs.get_modification_time)
        #access_time = Time.at(file_access_time).to_java(java.util.Date)
        puts "#{inner_dir},#{space_consumed},#{space_quota},#{space_used},#{file_count},#{user},#{group},#{access_time},#{replication}"
        hdfs_recurse_write_to_stdout(inner_path, fs, uri, cs)
      # else
      #   dir_with_file = myfs.get_path.to_s.gsub(uri, "")
      #   user = myfs.get_owner
      #   group = myfs.get_group
      #   space_consumed = myfs.getLen
      #   space_used = myfs.getLen
      #   space_quota = ''
      #   access_time = java.util.Date.new(myfs.get_modification_time)
      #   replication = myfs.get_replication
      #   puts "#{dir_with_file},#{space_consumed},#{space_quota},#{space_used},#{file_count},#{user},#{group},#{access_time},#{replication}"   
      end 
    end
    #puts "Total Directories: #{@total_dir_count} and Total Files: #{@total_file_count}"
  end

  def hdfs_recurse_write_to_db(top_dir, fs, uri, cs, db_connection, db_dataset)
    # Write to DB. Currently has dependency on Sequel and Postgres
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
          replication = myfs.get_replication
          permission  = myfs.get_permission
          block_size  = myfs.get_block_size
          @total_file_count += file_count
          user = myfs.get_owner
          group = myfs.get_group
          access_time = java.util.Date.new(myfs.get_modification_time)
          #access_time = Time.at(file_access_time).to_java(java.util.Date)
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
          puts "Created record #{inner_dir}:#{space_consumed}:#{space_quota}:#{space_used}:#{file_count}:#{user}:#{group}:#{access_time}:#{replication}:#{permission}:#{block_size}"
          hdfs_recurse_write_to_db(inner_path, fs, uri, cs, db_connection, db_dataset) 
        else
          dir_with_file = myfs.get_path.to_s.gsub(uri, "")
          user = myfs.get_owner
          group = myfs.get_group
          space_consumed = myfs.getLen
          space_used = myfs.getLen
          space_quota = '-1'
          file_count = '1'
          access_time = java.util.Date.new(myfs.get_modification_time)
          replication = myfs.get_replication
          permission  = myfs.get_permission
          block_size  = myfs.get_block_size
          db_connection.transaction do
                db_dataset.insert(
                  :path_suffix => "#{dir_with_file}",
                  :path_type => "FILE",
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
            puts "Created record #{dir_with_file}:#{space_consumed}:#{space_quota}:#{space_used}:#{file_count}:#{user}:#{group}:#{access_time}:#{replication}:#{permission}:#{block_size}"   
        end
    end
  end

  def get_data_nodes(fs)
    hosts = {}
    nodes = fs.get_data_node_stats
    nodes.each do |node|
      hosts  = { :data_node => "#{node}" }
    end
    hosts.to_json
  end
end










