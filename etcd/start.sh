#!/bin/bash
set -x
source init.sh

docker run -d --hostname $KUBERNETES_MASTER_IP --name etcd \
  -p 4001:4001 -p 7001:7001 $ETCD_IMAGE \
  --listen-client-urls http://0.0.0.0:4001 \
  --advertise-client-urls http://${KUBERNETES_MASTER_IP}:4001

