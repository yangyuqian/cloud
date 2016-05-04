#!/bin/bash

export HOSTS=`cat ./hosts`
export IMAGES=`cat ./images`

function init-docker-client(){
  echo "DOCKER_HOST=tcp://$1:2375"
  export DOCKER_HOST="tcp://$1:2375"
}
