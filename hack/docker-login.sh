#!/usr/bin/env bash

# set
# SOURCE: https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry

export REGISTRY=ghcr.io
export REGISTRY_OWNER=bossjones

if [ -z "${CR_PAT:-}" ]; then
  echo "ERROR: CR_PAT environment variable not set"
  exit 1
fi

echo "Logging in to GitHub Container Registry..."
echo "Please enter your GitHub Personal Access Token when prompted"
echo "${CR_PAT}" | docker login -u "${REGISTRY_OWNER}" "${REGISTRY}" --password-stdin
