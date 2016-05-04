#!/bin/bash -

function pull-images(){
  for image in $@
  do
    docker pull $image
  done
}

source init.sh

for host in $HOSTS
do
  init-docker-client $host
  pull-images $IMAGES
done

./reset.sh
