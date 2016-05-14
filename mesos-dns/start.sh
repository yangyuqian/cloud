#!/bin/bash


set -x

source init.sh
source zk/init.sh

image=`cat images|grep mesos-dns`

init-docker-client $1
docker run -d \
  -e LIBPROCESS_IP=$1 \
  -v "/home/vagrant/config.json:/config.json" \
  --name mesos-dns-node$2 \
  --restart always \
  --net host $image /mesos-dns -v=2 -config=/config.json
