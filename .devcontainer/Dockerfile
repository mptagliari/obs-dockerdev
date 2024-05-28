# OBS Studio build environment for VSCode by Matheus Tagliari - mptagliari@gmail.com
FROM ubuntu:24.04 as base

# Setup arguments and environment variables
ARG ENABLE_BUILD=OFF
ARG CMAKE_DEFAULTS=OFF
ARG CMAKE_OPTIONS=""
ENV ENABLE_BUILD=${ENABLE_BUILD}
ENV CMAKE_DEFAULTS=${CMAKE_DEFAULTS}
ENV CMAKE_OPTIONS=${CMAKE_OPTIONS}
ENV CMAKE_OPTIONS_DEFAULT="-DCEF_ROOT_DIR=\"/home/cef\" -DENABLE_PIPEWIRE=OFF -DENABLE_AJA=0 -DENABLE_WEBRTC=0 -DQT_VERSION=6"

# Create necessary directories
RUN mkdir -p /home/obs-studio /home/cef /usr/local/cmake-3.29.3-linux-x86_64 

# Install base dependencies
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
&& apt-get install -y \
ninja-build \
pkg-config \
clang-format \
build-essential \
curl \
ccache \
git \
wget \
zsh \
nano \
libpulse-dev \
libavcodec-dev \
libavdevice-dev \
libavfilter-dev \
libavformat-dev \
libavutil-dev \
libswresample-dev \
libswscale-dev \
libx264-dev \
libcurl4-openssl-dev \
libmbedtls-dev \
libgl1-mesa-dev \
libjansson-dev \
libluajit-5.1-dev \
python3-dev \
libx11-dev \
libxcb-randr0-dev \
libxcb-shm0-dev \
libxcb-xinerama0-dev \
libxcb-composite0-dev \
libxcomposite-dev \
libxinerama-dev \
libxcb1-dev \
libx11-xcb-dev \
libxcb-xfixes0-dev \
swig \
libcmocka-dev \
libxss-dev \
libglvnd-dev \
libgles2-mesa-dev \
libwayland-dev \
librist-dev \
libsrt-openssl-dev \
libpci-dev \
libffmpeg-nvenc-dev \
libpipewire-0.3-dev \
libqrcodegencpp-dev \
uthash-dev \
# Clean up
&& rm -rf /var/lib/apt/lists/*  

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

WORKDIR /home/obs-studio

# Conditional build steps based on environment variables
RUN if [ "$ENABLE_BUILD" = "ON" ]; then \
        if [ "$CMAKE_DEFAULTS" = "ON" ]; then \
            cmake -S . -B docker-build -G Ninja ${CMAKE_OPTIONS_DEFAULT}; \
        elif [ -z "${CMAKE_OPTIONS}" ]; then \
            echo "No CMAKE_OPTIONS provided, using defaults."; \
            cmake -S . -B docker-build -G Ninja ${CMAKE_OPTIONS_DEFAULT}; \
        else \
            echo "Using provided CMAKE_OPTIONS"; \
            cmake -S . -B docker-build -G Ninja ${CMAKE_OPTIONS}; \
        fi \
    fi

# Development environment stage
FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04 as dev_env

COPY --from=base /home/obs-studio /home/obs-studio
COPY --from=base /usr/local/cmake-3.29.3-linux-x86_64 /usr/local/cmake-3.29.3-linux-x86_64
COPY --from=base /home/cef /home/cef

RUN ln -s /usr/local/cmake-3.29.3-linux-x86_64/bin/* /usr/local/bin/

WORKDIR /home/obs-studio
