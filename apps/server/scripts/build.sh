#!/bin/bash

echo "Building Docker image for Sovereign Chess Server..."

# Get values for the build args
source ../../.env

# We need to run this command from the root of the monorepo,
# so it can copy the pubspec files from the workspace root.
cd ../..
docker build \
  --progress=plain \
  --tag sovereignchess-server:latest \
  --file packages/server/Dockerfile \
  --secret id=supabase,src=.env \
  . # Run in current directory

# Run container
# docker run -d -p 8080:80 sovereignchess_server:latest
