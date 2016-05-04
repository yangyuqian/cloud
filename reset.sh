#!/bin/bash

echo "remove existing containers..."
docker ps -aq|xargs docker kill
docker ps -qa|xargs docker rm -v --force
docker images|grep -i none|awk '{print $3}'|xargs docker rmi
