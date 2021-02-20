#!/usr/bin/env bash
# This is a wrapper script to call chart-testing in a container
set -eux

# Make sure environment are set
[ -d "${ROOT_DIR}" ]

docker run --rm -it -v "${ROOT_DIR}":/charts --workdir=/charts --entrypoint=ct \
  quay.io/helmpack/chart-testing "$@"

# The docker based chart-testing tend to write files as root.
# We don't want that
USER_GROUP="$(id -u):$(id -g)"
docker run --rm -it -v "${ROOT_DIR}":/charts --workdir=/charts --entrypoint=/bin/sh \
  quay.io/helmpack/chart-testing -c "chown -R ${USER_GROUP} ."
