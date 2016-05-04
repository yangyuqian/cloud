#!/bin/bash -

function pull-images(){
  for image in $@
  do
    docker pull $image
  done
}

function init-docker-client(){
  export DOCKER_HOST="tcp://$1:2375"
}

source init.sh
for host in $HOSTS
do
  init-docker-client $host
  pull-images $IMAGES
done
