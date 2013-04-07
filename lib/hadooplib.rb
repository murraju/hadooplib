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
require 'hadooplib/jars/commons-configuration-1.9.jar'
require 'hadooplib/jars/commons-lang-2.6.jar'
require 'hadooplib/jars/commons-logging-1.1.1.jar'
require 'hadooplib/jars/hadoop-ant-1.1.2.21.jar'
require 'hadooplib/jars/hadoop-ant.jar'
require 'hadooplib/jars/hadoop-client-1.1.2.21.jar'
require 'hadooplib/jars/hadoop-client.jar'
require 'hadooplib/jars/hadoop-core-1.1.2.21.jar'
require 'hadooplib/jars/hadoop-core.jar'
require 'hadooplib/jars/hadoop-examples-1.1.2.21.jar'
require 'hadooplib/jars/hadoop-examples.jar'
require 'hadooplib/jars/hadoop-minicluster-1.1.2.21.jar'
require 'hadooplib/jars/hadoop-minicluster.jar'
require 'hadooplib/jars/hadoop-test-1.1.2.21.jar'
require 'hadooplib/jars/hadoop-test.jar'
require 'hadooplib/jars/hadoop-tools-1.1.2.21.jar'
require 'hadooplib/jars/hadoop-tools.jar'



#Load imports
import java.net.URL
import java.net.InetSocketAddress
import java.text.SimpleDateFormat
import java.util.Collection
import java.util.List

import java.io.BufferedInputStream
import java.io.BufferedOutputStream
import java.io.File;
import java.io.FileInputStream
import java.io.FileOutputStream
import java.io.IOException
import java.io.InputStream
import java.io.OutputStream


import org.apache.hadoop.conf.Configuration
import org.apache.hadoop.fs.ContentSummary
import org.apache.hadoop.fs.DU
import org.apache.hadoop.fs.FileStatus
import org.apache.hadoop.fs.FileSystem
import org.apache.hadoop.fs.FileUtil
import org.apache.hadoop.fs.FsShell
import org.apache.hadoop.fs.Path
import org.apache.hadoop.fs.PathFilter
import org.apache.hadoop.fs.ContentSummary
import org.apache.hadoop.fs.FileStatus
import org.apache.hadoop.fs.FileSystem
import org.apache.hadoop.fs.BlockLocation
import org.apache.hadoop.fs.FSDataInputStream
import org.apache.hadoop.fs.FSDataOutputStream
import org.apache.hadoop.fs.Path
import org.apache.hadoop.hdfs.DFSClient
import org.apache.hadoop.hdfs.DistributedFileSystem
import org.apache.hadoop.hdfs.DistributedFileSystem
import org.apache.hadoop.hdfs.protocol.DatanodeInfo


import org.apache.hadoop.mapred.JobConf




