#!/bin/sh
#
# Executes the build processes of cmangos-classic, based on the
# build & source directories provided by the environment variables.
#
# All source files are prebaked within the container image.
#
BUILD_THREADS=${BUILD_THREADS:-1}

mkdir -p \
    "$BUILD_DIR/etc" \
    "$BUILD_DIR/bin" \
    "$BUILD_DIR/run" \
    "$SOURCE_DIR/build"

cd "$SOURCE_DIR/build"

additional_arguments="$@"
cmake ../ \
    -D CMAKE_INSTALL_PREFIX=$BUILD_DIR \
    -D PCH=1 \
    -D DEBUG=0 \
    -D BUILD_EXTRACTORS=ON \
    $additional_arguments

make -j "$BUILD_THREADS"
make install

chmod +x \
    "$BUILD_DIR/bin/tools/ExtractResources.sh" \
    "$BUILD_DIR/bin/tools/MoveMapGen.sh"
