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


require 'java'
require 'nokogiri'
require 'rest-client'
require 'json'
require 'hadooplib/hdfs'
require 'hadooplib/mapred'
require 'hadooplib/jars/commons-configuration-1.9.jar'
require 'hadooplib/jars/commons-lang-2.6.jar'
require 'hadooplib/jars/commons-logging-1.1.1.jar'
require 'hadooplib/jars/hadoop-ant-1.1.2.jar'
require 'hadooplib/jars/hadoop-client-1.1.2.jar'
require 'hadooplib/jars/hadoop-core-1.1.2.jar'
require 'hadooplib/jars/hadoop-examples-1.1.2.jar'
require 'hadooplib/jars/hadoop-minicluster-1.1.2.jar'
require 'hadooplib/jars/hadoop-test-1.1.2.jar'
require 'hadooplib/jars/hadoop-tools-1.1.2.jar'


#Load java_imports
java_import java.net.URL
java_import java.net.InetSocketAddress
java_import java.text.SimpleDateFormat
java_import java.util.Collection
java_import java.util.List

# java_import java.io.BufferedInputStream
# java_import java.io.BufferedOutputStream
# java_import java.io.File;
# java_import java.io.FileInputStream
# java_import java.io.FileOutputStream
# java_import java.io.InputStream
# java_import java.io.OutputStream

java_import java.io.IOException

java_import org.apache.hadoop.conf.Configuration

java_import org.apache.hadoop.fs.ContentSummary
java_import org.apache.hadoop.fs.DU
java_import org.apache.hadoop.fs.FileStatus
java_import org.apache.hadoop.fs.FileSystem
java_import org.apache.hadoop.fs.FileUtil
java_import org.apache.hadoop.fs.FsShell
java_import org.apache.hadoop.fs.Path
java_import org.apache.hadoop.fs.PathFilter
java_import org.apache.hadoop.fs.ContentSummary
java_import org.apache.hadoop.fs.FileStatus
java_import org.apache.hadoop.fs.FileSystem
java_import org.apache.hadoop.fs.BlockLocation
java_import org.apache.hadoop.fs.FSDataInputStream
java_import org.apache.hadoop.fs.FSDataOutputStream
java_import org.apache.hadoop.fs.Path

java_import org.apache.hadoop.hdfs.DFSClient
java_import org.apache.hadoop.hdfs.DistributedFileSystem
java_import org.apache.hadoop.hdfs.protocol.DatanodeInfo


java_import org.apache.hadoop.mapred.JobConf
java_import org.apache.hadoop.mapred.JobQueueInfo
java_import org.apache.hadoop.mapred.jobcontrol.JobControl

java_import org.apache.hadoop.mapreduce.ClusterMetrics
java_import org.apache.hadoop.mapreduce.JobStatus
java_import org.apache.hadoop.mapreduce.lib.jobcontrol.ControlledJob
java_import org.apache.hadoop.mapreduce.Job

java_import org.apache.hadoop.security.UserGroupInformation



