# OBS Studio VSCode Development Environment

This repository contains the Docker setup for an OBS Studio development environment using VSCode. It is designed to provide a consistent and controlled development setting using Docker and Docker Compose.

## Overview

The `docker-compose.yml` file defines the environment necessary to build and develop OBS Studio. It includes options to customize the build using Docker build arguments.
The Dockerfile uses the devcontainer image to use with the VSCode Docker and DevContainer Extensions

## Getting Started

### Prerequisites

- Docker
- VSCode (Optional but recommended)

Ensure Docker and Docker Compose are installed on your system. For installation instructions, refer to the [official Docker documentation](https://docs.docker.com/get-docker/).
More info about the devcontainer, refer to the [Devcontainer documentation](https://containers.dev).


### Building the Docker Environment

1. **Clone the repository**:
```bash
   git clone https://github.com/mptagliari/obs-dockerdev.git
```
```sh
2. cd obs-dockerdev
```
3. Build and run the Docker environment:
    docker-compose up -d
   Or if you are using the VSCode, simply use the docker extension to deploy the container

### Configuration Options
The Docker environment can be customized with several build arguments in the docker-compose.yml file:

**ENABLE_BUILD**: Set to "ON" to enable the OBS build process when the container starts. Default is "OFF".

**CMAKE_DEFAULTS**: When set to "ON", default build options are used for CMake. These are:`DCEF_ROOT_DIR="/home/cef_binary_5060_linux_x86_64"`, `DENABLE_PIPEWIRE=OFF` , `DENABLE_AJA=0`, `DENABLE_WEBRTC=0`, `DQT_VERSION=6`

**CMAKE_OPTIONS**: Allows custom CMake options to be specified, overriding the defaults if set.

Available CMake configuration variables can be found in the obs-studio repository at the [CMake build system documentation](https://github.com/obsproject/obs-studio/wiki/building-obs-studio#cmake) section. 

###IMPORTANT

The default CEF download directory on the container is set to `/home/cef_binary_5060_linux_x86_64`.

Note: If you want to set the CMake options and build OBS Studio when the container is built, you'll need to either include `-DCEF_ROOT_DIR` pointing to that directory or set `-DENABLE_BROWSER` to `OFF`.
