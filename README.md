hadooplib (beta)
================

A JRuby based Hadoop Client Library allowing to build Hadoop Management Applications in Ruby. Covers basic HDFS and MapRed functions using the native Hadoop 1.1.2 APIs.


Version 0.0.1

First set of HDFS functions.

Requirements
============

Java 1.6 or 1.7 (OpenJDK or HotSpotVM) with JRuby 1.7.3

Install
=======

Due to the size of this gem (contains the Hadoop jars), it is not available on rubygems.org. To build and install the gem, please follow the instructions below.

	1. Install JRuby 1.7.3
	2. git clone https://github.com/murraju/hadooplib.git
	3. cd hadooplib
	4. rake build
	5. gem install pkg/hadooplib-<version>.gem

Usage (example)
===============

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



Features
========

1. HDFS - get HDFS metrics after recursively traversing the filesystem. Output to console, csv, or db (postgres). 
2. MapRed - in-progress (check for updates)


ToDo
====

*More HDFS and begin MapRed functions


== Contributing to hadooplib
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

== Copyright

Copyright (c) 2013 Murali Raju. See LICENSE.txt for further details.






