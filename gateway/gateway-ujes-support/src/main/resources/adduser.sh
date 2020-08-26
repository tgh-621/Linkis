#!/usr/bin/env bash
mkdir -p /tmp/linkis/$1
echo $1=$2 >> ../conf/upf.properties
su - hdfs << EOF
hadoop dfs -mkdir -p /user/$1
hadoop dfs -chown root:hdfs /user/$1
hadoop dfs -mkdir -p /tmp/linkis/$1
hadoop dfs -chmod 777 /tmp/linkis/$1
EOF
