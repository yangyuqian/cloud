#!/bin/bash

source init.sh

function remove-useless-images(){
  for regex in $USELESS_REGEX
  do
    docker images|grep $regex|awk '{print $3}'|xargs docker rmi
  done
}

function remove-useless-containers(){
  for regex in $USELESS_REGEX
  do
    docker ps -a|grep -i exit|grep $regex|awk '{print $1}'|xargs docker rm -v --force
  done
}

for host in $HOSTS
do
  init-docker-client $host
  remove-useless-images
done

for host in $HOSTS
do
  init-docker-client $host
  remove-useless-containers
done
