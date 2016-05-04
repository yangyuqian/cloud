#!/bin/bash

echo "remove existing containers..."
docker ps -aq|xargs docker kill
docker ps -qa|xargs docker rm -v --force

sleep 1
echo "start zookeeper node"
docker run -d \
-e MYID=1 \
-e LIBPROCESS_IP=192.168.33.11 \
-e SERVERS="192.168.33.11,192.168.33.12,192.168.33.13" \
--name=zookeeper --net=host --restart=always mesoscloud/zookeeper

echo "start mesos master"
sleep 1
docker run -d \
-e MESOS_HOSTNAME=192.168.33.11 \
-e LIBPROCESS_IP=192.168.33.11 \
-e MESOS_IP=192.168.33.11 \
-e MESOS_QUORUM=1 \
-e MESOS_ZK=zk://192.168.33.11:2181,192.168.33.12:2181,192.168.33.13:2181/mesos \
--name mesos-master --net host --restart always mesoscloud/mesos-master:0.24.1-centos-7

echo "start mesos slave"
sleep 1
# start the mesos slave with some attributes, which will determine specific deploy strategies
docker run -d \
-e MESOS_HOSTNAME=192.168.33.11 \
-e LIBPROCESS_IP=192.168.33.11 \
-e MESOS_IP=192.168.33.11 \
-e MESOS_MASTER=zk://192.168.33.11:2181,192.168.33.12:2181,192.168.33.13:2181/mesos \
-v /sys/fs/cgroup:/sys/fs/cgroup \
-v /var/run/docker.sock:/var/run/docker.sock \
--name slave --net host --privileged --restart always \
mesoscloud/mesos-slave:0.24.1-centos-7 mesos-slave --attributes='rack:web;'

echo "start marathon master"
docker run -d \
-e MARATHON_HOSTNAME=192.168.33.11 \
-e LIBPROCESS_IP=192.168.33.11 \
-e MARATHON_HTTPS_ADDRESS=192.168.33.11 \
-e MARATHON_HTTP_ADDRESS=192.168.33.11 \
-e MARATHON_MASTER=zk://192.168.33.11:2181,192.168.33.12:2181,192.168.33.13:2181/mesos \
-e MARATHON_ZK=zk://192.168.33.11:2181,192.168.33.12:2181,192.168.33.13:2181/marathon \
--name marathon --net host --restart always mesoscloud/marathon:0.11.0-centos-7
