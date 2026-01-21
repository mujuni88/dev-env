#!/bin/bash

set -euo pipefail

IMAGE=go60-zmk-config-docker
BRANCH="${1:-main}"

# Build with Go60 Dockerfile
docker build -t "$IMAGE" -f Dockerfile.go60 .
docker run --rm -v "$PWD:/config" -e UID="$(id -u)" -e GID="$(id -g)" -e BRANCH="$BRANCH" "$IMAGE"
