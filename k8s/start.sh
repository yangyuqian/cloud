#!/bin/bash
set -x
source init.sh

cat << EOF > mesos-cloud.conf
[mesos-cloud]
  mesos-master        = zk://${ZK_IP}:${ZK_PORT}/mesos
  http-client-timeout = 5s
  state-cache-ttl     = 20s
EOF

ps -ef|grep km|awk '{print $2}'|xargs kill -9

km apiserver \
  --address=${MY_IP} \
  --etcd-servers=http://${KUBERNETES_MASTER_IP}:4001 \
  --service-cluster-ip-range=10.10.10.0/24 \
  --port=$K8S_API_PORT \
  --cloud-provider=mesos \
  --secure-port=0 \
  --cloud-config=./mesos-cloud.conf \
  --v=5 >> ./log/apiserver.log 2>&1 &

sleep 5

km controller-manager \
  --master=${MY_IP}:$K8S_API_PORT \
  --cloud-provider=mesos \
  --cloud-config=./mesos-cloud.conf  \
  --v=1 > ./log/controller.log 2>&1 &

sleep 5

km scheduler \
  --address=0.0.0.0 \
  --mesos-master=${KUBERNETES_MASTER_IP}:5050 \
  --etcd-servers=http://${KUBERNETES_MASTER_IP}:4001 \
  --mesos-user=root \
  --api-servers=${MY_IP}:$K8S_API_PORT \
  --cluster-dns=10.10.10.10 \
  --cluster-domain=cluster.local \
  --v=2 > ./log/scheduler.log 2>&1

