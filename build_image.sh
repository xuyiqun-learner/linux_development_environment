#!/bin/bash
# date: 2024-03-17
# function: build docker image script
# author: xuyq

set -e
docker build -t ubuntu22.04-ros2_humble/$USER .
exec "$@"