#!/bin/bash
set -x

source init.sh
source zk/init.sh

ID=1
for host in $HOSTS
do
  init-docker-client $host
  M=`docker exec -it mesos-master-node$ID mesos-resolve $MESOS_ZK|tail -n 1`
  docker exec -it mesos-master-node$ID mesos-execute --master=$M --name="cluster-test" --command="echo cluster-test successfully > /tmp/hello.out"
  ID=$((ID + 1))
done

