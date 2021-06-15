#!/usr/bin/env bash
set -eux

echo "This needs docker build X"

docker buildx build --push \
    --platform linux/amd64,linux/arm64 \
    -t kartoza/kind-node:v1.19.11-custom \
    docs/testing-environment-setup/configs