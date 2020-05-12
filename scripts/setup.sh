#!/bin/bash

# Always start from the main directory
PROJECT_DIR=$(pwd)
echo "Starting Setup... $PROJECT_DIR"

NUM_PARALLEL_BUILDS=12

# 1. Extract the archived third party libraries
EXTERN_DIR=$PROJECT_DIR/extern
LIBRESSL_DIR=$EXTERN_DIR/libressl
LIBRESSL_INSTALL_DIR=$EXTERN_DIR/libressl_install
CMAKE_DIR=$EXTERN_DIR/cmake

mkdir $LIBRESSL_DIR
mkdir $CMAKE_DIR
tar -xvzf $EXTERN_DIR/libressl-3.1.1.tar.gz -C $LIBRESSL_DIR --strip-components=1
tar -xvzf $EXTERN_DIR/cmake-3.17.2-Linux-x86_64.tar.gz -C $CMAKE_DIR --strip-components=1

# 2. Build libressl
LIBRESSL_BUILD_DIR=$LIBRESSL_DIR/build
CMAKE_BIN_DIR=$CMAKE_DIR/bin

mkdir $LIBRESSL_BUILD_DIR
mkdir $LIBRESSL_INSTALL_DIR
cd $LIBRESSL_BUILD_DIR
$CMAKE_BIN_DIR/cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX:PATH="$LIBRESSL_INSTALL_DIR" -DBUILD_SHARED_LIBS=ON $LIBRESSL_DIR
make -j$NUM_PARALLEL_BUILDS
make install

echo "LibreSSL built!"

# 3. Build code
BUILD_DIR=$PROJECT_DIR/build
mkdir $BUILD_DIR && cd $BUILD_DIR

$CMAKE_BIN_DIR/cmake -DCMAKE_BUILD_TYPE=Release -DLIBRESSL_ROOT_DIR="$EXTERN_DIR/libressl_install" $PROJECT_DIR
make -j$NUM_PARALLEL_BUILDS