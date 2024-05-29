# syntax=docker/dockerfile:1.2

FROM ubuntu:24.04 as builder

# Setup arguments and environment variables
ARG PACKAGES="ninja-build,pkg-config,clang-format,build-essential,ccache,git,wget,curl,zsh,libpulse-dev,libavcodec-dev,libavdevice-dev,libavfilter-dev,libavformat-dev,libv4l2rds0,libv4l-dev,libavutil-dev,libswresample-dev,libswscale-dev,qt6-base-dev,qt6-base-private-dev,libqt6svg6-dev,qt6-wayland,qt6-image-formats-plugins,libx264-dev,libcurl4-openssl-dev,libmbedtls-dev,libgl1-mesa-dev,libjansson-dev,libluajit-5.1-dev,python3-dev,libx11-dev,libxcb-randr0-dev,libxcb-shm0-dev,libxcb-xinerama0-dev,libxcb-composite0-dev,libxcomposite-dev,libxinerama-dev,libvlccore-dev,libvlccore9,libvlc5,libvlc-dev,libxcb1-dev,libx11-xcb-dev,libclalsadrv-dev,libghc-alsa-core-dev,libalsaplayer-dev,libxcb-xfixes0-dev,swig,libcmocka-dev,libxss-dev,libglvnd-dev,libgles2-mesa-dev,libwayland-dev,librist-dev,libsrt-openssl-dev,libvpl-dev,libva-drm2,libxkbcommon-x11-dev,libxkbcommon-dev,libpci-dev,libva-dev,libvala-0.56-dev,libffmpeg-nvenc-dev,libpipewire-0.3-dev,libqrcodegencpp-dev,uthash-dev,nlohmann-json3-dev,libwebsocketpp-dev,libasio-dev,libspeexdsp-dev,libdrm-dev"
ARG ENABLE_BUILD=ON
ARG CMAKE_DEFAULTS=ON
ARG CMAKE_CEF_DIR='-DCEF_ROOT_DIR="/home/cef_binary_5060_linux_x86_64"'
ARG CMAKE_OPTIONS=""
ENV ENABLE_BUILD=${ENABLE_BUILD}
ENV CMAKE_DEFAULTS=${CMAKE_DEFAULTS}
ENV CMAKE_OPTIONS=${CMAKE_OPTIONS}
ENV CMAKE_CEF_DIR=${CMAKE_CEF_DIR}
ENV CMAKE_OPTIONS_DEFAULT="-DENABLE_PIPEWIRE=OFF -DENABLE_AJA=0 -DENABLE_WEBRTC=0 -DQT_VERSION=6"

# Create necessary directories
RUN mkdir -p /tmp /home/obs-studio /usr/local/cmake-3.29.3-linux-x86_64 

# Install curl to download nanolayer
RUN apt-get update && apt-get install -y curl

# Download and extract the file in one RUN command to minimize layer size
RUN curl -L "https://github.com/devcontainers-contrib/nanolayer/releases/download/v0.5.6/nanolayer-x86_64-unknown-linux-gnu.tgz" -o /tmp/nanolayer.tgz \
    && tar -xzf /tmp/nanolayer.tgz -C /usr/local/bin \
    && rm /tmp/nanolayer.tgz

# Install base dependencies using nanolayer
# Nanolayer is a tool that helps you keep your Dockerfile layers small.
#It does so by automatically deleting any installation leftovers 
#(such as apt-get update lists, ppas, etc) after the installation is done.
# https://github.com/devcontainers-contrib/nanolayer


RUN  nanolayer install apt-get ${PACKAGES} 

# Download and install CMake
RUN wget -O /opt/cmake.sh https://github.com/Kitware/CMake/releases/download/v3.29.3/cmake-3.29.3-linux-x86_64.sh \
    && chmod +x /opt/cmake.sh \
    && /opt/cmake.sh --skip-license --prefix=/usr/local --include-subdir

# Link CMake binaries
RUN ln -s /usr/local/cmake-3.29.3-linux-x86_64/bin/* /usr/local/bin/

# Clone OBS Studio
RUN git clone --recursive https://github.com/obsproject/obs-studio.git /home/obs-studio

# Download and extract CEF
RUN wget -O /tmp/cef.tar.xz https://cdn-fastly.obsproject.com/downloads/cef_binary_5060_linux_x86_64_v3.tar.xz \
    && tar -xvf /tmp/cef.tar.xz -C /home \
    && rm /tmp/cef.tar.xz
# Download .net script
RUN wget -o /home/dotnet.sh https://dotnet.microsoft.com/download/dotnet/scripts/v1/dotnet-install.sh

# Copy and exec the build script
#COPY build.sh /home/obs-studio/build.sh
#RUN  chmod +x /home/obs-studio/build.sh && /home/obs-studio/build.sh

RUN cd /home/obs-studio && \
    if [ "$ENABLE_BUILD" = "ON" ]; then \
        cmake -S . -B docker-build -G Ninja \
        -DCEF_ROOT_DIR="/home/cef_binary_5060_linux_x86_64" \
        -DENABLE_PIPEWIRE=OFF \
        -DENABLE_AJA=0 \
        -DENABLE_WEBRTC=0 \
        -DQT_VERSION=6; \
    fi

FROM ubuntu:24.04 AS dev_env

COPY --from=builder \
  /home/obs-studio /home/obs-studio \
  /usr/local/cmake-3.29.3-linux-x86_64 /usr/local/cmake-3.29.3-linux-x86_64 \
  /home/cef_binary_5060_linux_x86_64 /home/cef_binary_5060_linux_x86_64 \
  /home/dotnet.sh /home/dotnet.sh/  \
  /usr/local/bin/ /usr/local/bin/

#RUN chmod +x /home/dotnet.sh && /home/dotnet.sh --install-dir /usr/local/bin 
#RUN rm /home/dotnet.sh && \
RUN ln -s /usr/local/cmake-3.29.3-linux-x86_64/bin/* /usr/local/bin/
