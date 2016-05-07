#!/bin/bash

source init.sh

for host in $HOSTS
do
  init-docker-client $host
  docker ps -aq|xargs docker kill
  docker ps -qa|xargs docker rm -v --force
  docker images|grep -i none|awk '{print $3}'|xargs docker rmi
done

ps -ef|grep km|awk '{print $2}'|xargs kill -9
