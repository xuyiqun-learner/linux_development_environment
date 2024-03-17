#!/bin/bash
source /opt/ros/humbel/setup.bash
colcon build --merge-install --cmake-args -DBUILD_TESTING=0 -DCMAKE_TOOLCHAIN_FILE=${PWD}/cross-compile-configure.cmake