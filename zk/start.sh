#!/bin/bash
set -x

source init.sh
source zk/init.sh


image=`cat images|grep zookeeper`
hosts=`cat hosts|sed ':a;N;$!ba;s/\n/,/g'`

init-docker-client $1
docker run -d \
-e MYID=$2 \
-e LIBPROCESS_IP=$1 \
-e SERVERS=$hosts \
--name=zk-node$2 --net=host --restart=always $image

