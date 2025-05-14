#!/usr/bin/env bash

echo "Logging in to GitHub Container Registry..."
echo "Please enter your GitHub Personal Access Token when prompted"
docker login $(REGISTRY) -u $(REGISTRY_OWNER) -p $(gh auth token)
