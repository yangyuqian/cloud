#!/bin/bash
set -x

source init.sh
source zk/init.sh

image=`cat images|grep mesos-master`

init-docker-client $1
docker run -d \
  -e MESOS_HOSTNAME=$1 \
  -e LIBPROCESS_IP=$1 \
  -e MESOS_IP=$1 \
  -e MESOS_QUORUM=$2 \
  -e MESOS_ZK=$MESOS_ZK \
  -e DOCKER_API_VERSION=v1.21 \
  --hostname mesos-master-node$2 \
  --name mesos-master-node$2 --net host --restart always $image
