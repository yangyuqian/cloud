#!/bin/bash
set -x

source init.sh
source zk/init.sh

image=`cat images|grep mesos-slave`

init-docker-client $1
docker run -d \
  -e MESOS_HOSTNAME=$1 \
  -e LIBPROCESS_IP=$1 \
  -e MESOS_IP=$1 \
  -e MESOS_MASTER=$MESOS_ZK \
  -e DOCKER_API_VERSION=v1.21 \
  -v /sys/fs/cgroup:/sys/fs/cgroup \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v /var/lib/docker:/var/lib/docker \
  -v /tmp:/tmp \
  --hostname mesos-slave-node$2 \
  --name mesos-slave-node$2 --net host --privileged --restart always \
  $image
