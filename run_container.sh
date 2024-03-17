#!/bin/bash
# date: 2024-03-17
# function: run docker container
# author: xuyq
set -e
IMAGE_USER=$USER
docker run -it \
           --rm \
           -u ${IMAGE_USER} \
           -v ${PWD}/nav2_ws:/home/${IMAGE_USER}/nav2_ws \
           --name ${USER}_dev \
           -w /home/${IMAGE_USER}/nav2_ws \
           ubuntu22.04-ros2_humble/${IMAGE_USER}

exec "$@"