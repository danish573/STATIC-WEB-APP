#!/bin/bash
set -e

COMMAND=$1
SOURCE_DIR="."
BUILD_DIR="build"

if [ "$COMMAND" = "minify" ]; then
    echo "🧹 Cleaning old build directory..."
    rm -rf "$BUILD_DIR"
    mkdir -p "$BUILD_DIR"

    echo "✨ Copying and minifying HTML, CSS, and JS..."
    # Copy all files except build/ itself
    rsync -av --exclude="$BUILD_DIR" "$SOURCE_DIR"/ "$BUILD_DIR"/

    find "$BUILD_DIR" -type f -name "*.html" -exec minify {} -o {} \;
    find "$BUILD_DIR" -type f -name "*.css" -exec minify {} -o {} \;
    find "$BUILD_DIR" -type f -name "*.js" -exec minify {} -o {} \;

    echo "✅ Minification complete!"
fi
