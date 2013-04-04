


Example Usage
=============
	require 'hadooplib'

	default_name = 'hdfs://localhost:8020'
	path = '/'

	hdfs_client = HDFS.new(default_name, path)
	fs = hdfs_client.instance_variable_get(:@fs)
	top_dir = hdfs_client.instance_variable_get(:@top_dir)
	uri = hdfs_client.instance_variable_get(:@uri)
	cs = hdfs_client.instance_variable_get(:@cs)

	items = hdfs_client.hdfs_recurse(top_dir, fs, uri, cs)

	hdfs_items = JSON.parse(items)

	hdfs_items.each do |item|
	  item.each do |k, v|
	    puts "#{k}: #{v}"
	  end
	end 

	puts "Total Diectories: #{hdfs_client.instance_variable_get(:@total_dir_count)} and Total Files: #{total = hdfs_client.instance_variable_get(:@total_file_count)}"
