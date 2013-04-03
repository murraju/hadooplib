


Example Usage
=============
require 'hadooplib'

default_name = 'hdfs://localhost:8020'
path = '/'

hdfs_client = HDFS.new
fs, top_dir, uri, cs = hdfs_client.setup_environment(default_name, path)

hdfs_client.hdfs_recurse(top_dir, fs, uri, cs)

