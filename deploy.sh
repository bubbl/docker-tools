#!/usr/bin/env bash

set -e

base="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [[ $# -ne 3 ]]; then
    echo "You must set a version number and image name as well as push flag"
    echo "./deploy.sh <version> <img_name> <(y|n)>"
    exit 1
fi

version=$1
name=$2
dpush=$3

dockerfile_version=$(grep -i ${name}_VERSION= ${base}/Dockerfile | cut -d= -f2)

if [[ $version != $dockerfile_version ]]; then
    echo "Version mismatch in 'Dockerfile'"
    echo "found ${dockerfile_version}, expected ${version}."
    echo "Make sure the versions are correct."
    exit 1
fi

echo "Building docker images for ${name}:${version}..."
docker build -f "${base}/Dockerfile" -t bbania/${name}:${version} .

if [[ ${dpush} == "y" ]]; then
    echo "Uploading docker images for ${name} ${version}..."
    docker push bbania/${name}:${version}
elif [[ ${dpush} == "n" ]]; then
    echo "Will not upload docker images for ${name} ${version}"
fi
