#!/bin/bash

# Define the directory where the build should occur
BUILD_DIR="/home/obs-studio"

# Check if the build directory exists
if [ ! -d "$BUILD_DIR" ]; then
    echo "Error: Build directory $BUILD_DIR does not exist."
    exit 1
else
    # Change to the build directory
    cd "$BUILD_DIR"
fi
# Checking the build condition based on environment variables
case "$ENABLE_BUILD" in
    "ON")
        echo "Build was requested; proceed with CMake configuration and build."
        case "$CMAKE_DEFAULTS" in
            "ON")
             # Default CMake options for OBS Studio
             # This section is triggered if CMAKE_DEFAULTS is set to ON, 
             #indicating that default settings should be used.
    
                echo "Building with default CMake options and CEF directory at $CMAKE_CEF_DIR"
                cmake -S . -B docker-build -G Ninja $CMAKE_CEF_DIR $CMAKE_OPTIONS_DEFAULT
                ;;
            *)
            # This section handles the case where custom CMake options are provided.
            # It checks for the presence of ENABLE_BROWSER and the absence of CEF_ROOT_DIR
            # in the provided CMAKE_OPTIONS.
  
                echo "Checking custom CMake options."
                if [ ! -z "${CMAKE_OPTIONS}" ]; then
                    if echo "${CMAKE_OPTIONS}" | grep -q "\-DENABLE_BROWSER=ON" && ! echo "${CMAKE_OPTIONS}" | grep -q "\-DCEF_ROOT_DIR"; then
                    # User didn't provide CEF_ROOT_DIR, but ENABLE_BROWSER is ON, so we add the default CEF 
                    #directory and continue to build with the provided options. 
                    #This ensures that required dependencies are correctly configured.             
                        echo "ENABLE_BROWSER is ON but CEF_ROOT_DIR is not set. Adding default CEF directory."
                        cmake -S . -B docker-build -G Ninja $CMAKE_CEF_DIR $CMAKE_OPTIONS
                    else
                    # Here, either ENABLE_BROWSER is OFF or CEF_ROOT_DIR is already provided.
                    # Proceed to build with the custom options supplied by the user.          
                        echo "Building with provided options, which may include CEF_ROOT_DIR."
                        cmake -S . -B docker-build -G Ninja $CMAKE_OPTIONS
                    fi
                else
                # No custom CMAKE_OPTIONS provided; fall back to a default configuration.
                # This case should ideally handle scenarios where neither default nor 
                #custom options are specified.    
                    echo "No custom CMAKE_OPTIONS provided, using defaults."
                    cmake -S . -B docker-build -G Ninja $CMAKE_CEF_DIR $CMAKE_OPTIONS_DEFAULT
                fi
                ;;
        esac
        ;;
    *)
    # Finnaly, if ENABLE_BUILD is set to OFF, the script will print a message indicating that 
    #the build is disabled.
        echo "Build is disabled."
        ;;
esac
