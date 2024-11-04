#!/bin/bash

cp /static_web_pages/* . -r

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo "npm could not be found. Please check the installation again."
    exit 1
fi

# Install dependencies
npm install

exec "$@"