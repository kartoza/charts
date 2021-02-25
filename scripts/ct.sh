#!/usr/bin/env bash
# This is a wrapper script to call chart-testing in a container
set -eux

# Make sure environment are set
[ -d "${PROJECT_ROOT}" ]

docker run --rm -it -v "${PROJECT_ROOT}":"${PROJECT_ROOT}" --workdir="${PWD}" --entrypoint=ct \
  -e KUBECONFIG="${KUBECONFIG}" \
  quay.io/helmpack/chart-testing --config "${PROJECT_ROOT}/ct.yaml" "$@"

# The docker based chart-testing tend to write files as root.
# We don't want that
USER_GROUP="$(id -u):$(id -g)"
docker run --rm -it -v "${PROJECT_ROOT}":"${PROJECT_ROOT}" --workdir="${PWD}" --entrypoint=/bin/sh \
  -e KUBECONFIG="${KUBECONFIG}" \
  quay.io/helmpack/chart-testing -c "chown -R ${USER_GROUP} ."
