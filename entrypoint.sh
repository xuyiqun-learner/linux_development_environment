#!/bin/bash
set -e
mv /tmp/cross-compile-configure.cmake /tmp/colcon_build.sh /home/xyq/nav2_ws/
exec "$@"