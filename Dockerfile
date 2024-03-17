# date: 2024-04.17
# purpose: construct development environment
# auther: xuyq
from osrf/ros:humble-desktop-full

ENV LOCAL_USER xyq
ARG UID=1000 # run command "id -u xyq" to get
ARG GID=1000 # run command "id -g xyq" to get
ARG USER=xyq
## add a sudo user
RUN addgroup --gid $GID $USER && \
    adduser --uid $UID --gid $GID --disabled-password --gecos '' $USER && \
    echo "$USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

COPY arm64-cross-compile-sources.list /etc/apt/sources.list.d
    ## replace official sources.list and ros2-latest.list
WORKDIR /tmp
RUN sed -i "s@http://\(security\|archive\).ubuntu.com@[arch=amd64] http://mirrors.cloud.tencent.com@g" /etc/apt/sources.list && \
    sed -i "s@http://packages.ros.org@http://mirrors.cloud.tencent.com@g" /etc/apt/sources.list.d/ros2-latest.list && \
    ## install cross compile arm64 dependencies'libraries
    dpkg --add-architecture arm64 && \
    apt update && \
    apt install -y vim:amd64 htop:amd64 gcc-aarch64-linux-gnu:amd64 g++-aarch64-linux-gnu:amd64 python3-pip:amd64 pkg-config:amd64 extract:amd64
    ## install navigation2 dependencies

RUN apt update && \
    apt install -y libpython3.10-dev:arm64 python3-dev:amd64 ros-humble-rosidl-default-generators:amd64 libspdlog-dev:arm64 \
    ros-humble-geometry-msgs:arm64

    ## install pythonlibs
    # wget http://ports.ubuntu.com/pool/universe/r/ros-catkin-pkg/python3-catkin-pkg_0.4.16-1_all.deb && \
    
    # apt install -fy ./python3-catkin-pkg_0.4.16-1_all.deb --allow-downgrades && \
    # apt install -y ros-humble-ament-cmake-core:amd64

COPY --chown=$USER:$USER cross-compile-configure.cmake colcon_build.sh entrypoint.sh /tmp/

ENTRYPOINT [ "/tmp/entrypoint.sh" ]
CMD [ "/bin/bash" ]