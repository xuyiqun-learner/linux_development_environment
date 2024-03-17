#!/bin/bash
colcon build --merge-install --cmake-args -DBUILD_TESTING=0 -DCMAKE_TOOLCHAIN_FILE=$(PWD)/cross-compile-configure.cmake