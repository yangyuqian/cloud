#!/bin/bash


set -x

source init.sh
source zk/init.sh

haproxy_image=`cat images|grep mesoscloud/haproxy`
marathon_haproxy_image=`cat images|grep yangyuqian/haproxy-marathon`

init-docker-client $1
docker run -d \
  -e MARATHON=$1:8080 \
  -e ZK=$ZK_HOSTS \
  --name=marathon-haproxy-node$2 \
  --net=host \
  --restart=always $marathon_haproxy_image

docker run -d \
  -e ZK=$ZK_HOSTS \
  --name=haproxy-node$2 \
  --net=host \
  --restart=always $haproxy_image
