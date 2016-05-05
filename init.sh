#!/bin/bash

export HOSTS=`cat ./hosts`
export IMAGES=`cat ./images`

function init-docker-client(){
  echo "DOCKER_HOST=tcp://$1:2375"
  export DOCKER_HOST="tcp://$1:2375"
}

export MESOS_ZK="zk://"

ID=1
for host in $HOSTS
do
  export MESOS_ZK="$MESOS_ZK"
  if test $ID -gt 1
  then
    export MESOS_ZK="$MESOS_ZK,"
  fi

  export MESOS_ZK="${MESOS_ZK}${host}:2181"

  ID=$((ID + 1))
done
export ZK_CLUSTER="$MESOS_ZK"
export MESOS_ZK="$ZK_CLUSTER/mesos"
export MARATHON_ZK="$ZK_CLUSTER/marathon"

echo $MESOS_ZK
