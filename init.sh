#!/bin/bash

export HOSTS=`cat ./hosts`
export IMAGES=`cat ./images`
export USELESS_REGEX=`cat ./useless`

export ETCD_MASTER_IP=`tail -n 1 ./hosts`

export KUBERNETES_MASTER_IP=`head -n 1 ./hosts`
export KUBERNETES_MASTER=http://${KUBERNETES_MASTER_IP}:8888
export ZK_IP=$KUBERNETES_MASTER_IP
export ZK_PORT=2181

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

export ETCD_IMAGE=`grep etcd ./images`

echo $MESOS_ZK

export K8S_API_PORT=8080
export PATH=`pwd`/k8s:$PATH
export MY_IP=192.168.33.10
mkdir -p log
