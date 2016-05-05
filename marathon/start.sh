#!/bin/bash


set -x

source init.sh
source zk/init.sh

image=`cat images|grep marathon`

init-docker-client $1
docker run -d \
  -e MARATHON_HOSTNAME=$1 \
  -e LIBPROCESS_IP=$1 \
  -e MARATHON_HTTPS_ADDRESS=$1 \
  -e MARATHON_HTTP_ADDRESS=$1 \
  -e MARATHON_MASTER=$MESOS_ZK \
  -e MARATHON_ZK=$MARATHON_ZK \
  --name marathon-node$2 --net host --restart always $image
