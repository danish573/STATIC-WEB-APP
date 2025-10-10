#!/bin/bash
set -e

COMMAND=$1
SOURCE_DIR="."
BUILD_DIR="build"
S3_BUCKET="static-wl-website-s3-bucket"
AWS_REGION="ap-south-1"

if [ "$COMMAND" = "minify" ]; then
    echo "🧹 Cleaning old build directory..."
    rm -rf "$BUILD_DIR"
    mkdir -p "$BUILD_DIR"

    echo "✨ Copying and minifying HTML, CSS, and JS..."
    # Copy all files except build/ itself and hidden files
    rsync -av --exclude="$BUILD_DIR" --exclude=".git" "$SOURCE_DIR"/ "$BUILD_DIR"/

    find "$BUILD_DIR" -type f -name "*.html" -exec minify {} -o {} \;
    find "$BUILD_DIR" -type f -name "*.css" -exec minify {} -o {} \;
    find "$BUILD_DIR" -type f -name "*.js" -exec minify {} -o {} \;

    echo "✅ Minification complete!"

elif [ "$COMMAND" = "deploy" ]; then
    echo "🚀 Deploying files to S3..."
    aws s3 sync "$BUILD_DIR"/ "s3://$S3_BUCKET/" --region "$AWS_REGION" --delete

    echo "✅ Deployment complete!"
    echo "🌐 Your site should be live at: http://$S3_BUCKET.s3-website.$AWS_REGION.amazonaws.com"
else
    echo "❌ Unknown command. Use 'minify' or 'deploy'"
    exit 1
fi
