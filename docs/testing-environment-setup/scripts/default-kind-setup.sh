#!/usr/bin/env bash
set -ux

kind delete cluster
kind create cluster --config=docs/testing-environment-setup/configs/kind.config.yaml