#!/bin/bash
set -e

COMMAND= $1
SURCE_DIR= "src"
BUILD_DIR= "build"

if["$COMMAND" = "minify"]; then
    echo "Cleaning old build directory"
    rm -rf $BUILD_DIR
    mkdir -p $BUILD_DIR

    echo "Minifying HTML, CSS and JS...."
    cp -r $SOURCE_DIR/* $BUILD_DIR/
    find $BUILD_DIR -type f -name "*.html" -exec minify {} -o {} \;
    find $BUILD_DIR -type f -name "*.css" -exec minify {} -o {} \;
    find $BUILD_DIR -type f -name "*.js" -exec minify {} -o {} \;