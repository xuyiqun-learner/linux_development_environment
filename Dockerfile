# date: 2024-04.17
# purpose: construct development environment
# auther: xuyq
from ubuntu:jammy-20240227

ENV LOCAL_USER xyq
ARG UID=1000 # run command "id -u xyq" to get
ARG GID=1000 # run command "id -g xyq" to get
ARG USER=xyq
# add a sudo user
RUN sed -i "s@http://\(security\|archive\).ubuntu.com@[arch=amd64] http://mirrors.cloud.tencent.com@g" /etc/apt/sources.list && \
    apt update && \
    apt install -y sudo && \
    addgroup --gid $GID $USER && \
    adduser --uid $UID --gid $GID --disabled-password --gecos '' $USER && \
    echo "$USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# install usual package
RUN apt update && \
    apt install -q -y --no-install-recommends \
    vim \
    htop \
    gcc-aarch64-linux-gnu \
    g++-aarch64-linux-gnu \
    python3-pip \ 
    pkg-config \
    extract

# install packages that ros2 development neeed
RUN apt-get update && apt-get install -q -y --no-install-recommends \
    bash-completion \
    dirmngr \
    gnupg2 \
    python3-flake8 \
    python3-flake8-blind-except \
    python3-flake8-builtins \
    python3-flake8-class-newline \
    python3-flake8-comprehensions \
    python3-flake8-deprecated \
    python3-flake8-docstrings \
    python3-flake8-import-order \
    python3-flake8-quotes \
    python3-pip \
    python3-pytest-repeat \
    python3-pytest-rerunfailures \
    && rm -rf /var/lib/apt/lists/*

# setup keys
RUN set -eux; \
       key='C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654'; \
       export GNUPGHOME="$(mktemp -d)"; \
       gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key"; \
       mkdir -p /usr/share/keyrings; \
       gpg --batch --export "$key" > /usr/share/keyrings/ros2-latest-archive-keyring.gpg; \
       gpgconf --kill all; \
       rm -rf "$GNUPGHOME"

# setup sources.list
RUN echo "deb [ signed-by=/usr/share/keyrings/ros2-latest-archive-keyring.gpg ] http://packages.ros.org/ros2/ubuntu jammy main" > /etc/apt/sources.list.d/ros2-latest.list
    ## install navigation2 dependencies

COPY arm64-cross-compile-sources.list /etc/apt/sources.list.d
# RUN sed -i "s@http://packages.ros.org@http://mirrors.cloud.tencent.com@g" /etc/apt/sources.list.d/ros2-latest.list && \
    ## install cross compile arm64 dependencies'libraries
RUN dpkg --add-architecture arm64 && \
    apt update && \
    apt install ros-dev-tools:amd64
    # apt install -q -y --no-install-recommends \ 
    # libpython3.10-dev:arm64 \
    # python3-dev:amd64 \
    # ros-humble-rosidl-default-generators:arm64 \
    # libspdlog-dev:arm64 \
    # ros-humble-geometry-msgs:arm64

    ## install pythonlibs
    # wget http://ports.ubuntu.com/pool/universe/r/ros-catkin-pkg/python3-catkin-pkg_0.4.16-1_all.deb && \
    
    # apt install -fy ./python3-catkin-pkg_0.4.16-1_all.deb --allow-downgrades && \
    # apt install -y ros-humble-ament-cmake-core:amd64

COPY --chown=$USER:$USER cross-compile-configure.cmake colcon_build.sh entrypoint.sh /tmp/

ENTRYPOINT [ "/tmp/entrypoint.sh" ]
CMD [ "/bin/bash" ]
