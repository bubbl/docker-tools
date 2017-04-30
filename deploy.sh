#!/usr/bin/env bash

set -e

base="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ $# -ne 2 ]]; then
    echo "You must set a version number and image name"
    echo "./deploy.sh <version> <img_name>"
    exit 1
fi

version=$1
name=$2

dockerfile_version=$(grep VERSION= ${base}/Dockerfile | cut -d= -f2)

if [[ $version != $dockerfile_version ]]; then
    echo "Version mismatch in 'Dockerfile'"
    echo "found ${dockerfile_version}, expected ${version}."
    echo "Make sure the versions are correct."
    exit 1
fi

echo "Building docker images for ${name}:${version}..."
docker build -f "${base}/Dockerfile" -t bbania/${name}:${version} .

echo "Uploading docker images for ${name} ${version}..."
docker push bbania/${name}:${version}
