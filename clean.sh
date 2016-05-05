#!/bin/bash

source init.sh

function remove-useless-images(){
  for regex in $USELESS_REGEX
  do
    docker images|grep $regex|awk '{print $3}'|xargs docker rmi
  done
}

for host in $HOSTS
do
  init-docker-client $host
  remove-useless-images
done

