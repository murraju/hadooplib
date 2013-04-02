#Initialize
conf = Configuration.new
conf.set("fs.default.name", "hdfs://localhost:8020")
fs=org.apache.hadoop.fs.FileSystem.get(conf)
uri=fs.get_uri.to_s
cs = ContentSummary.new
top_dir=Path.new('/')


#HDFS recurse
@total_file_count = 0
@total_dir_count = 0



def hdfs_recurse(top_dir, fs, uri)
  
  items = []
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
      @hdfs_items = {
        :inner_dir => "#{inner_dir}",
        :space_consumed => "#{space_consumed}",
        :space_quota => "#{space_quota}",
        :space_used => "#{space_used}",
        :file_count => "#{file_count}",
        :user => "#{user}",
        :group => "#{group}",
        :access_time => "#{access_time}"
      }
      items << @hdfs_items
      hdfs_recurse(inner_path, fs, uri)
    end
  end
  return items.to_json
end

