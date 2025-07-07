#!/bin/bash

# We need to run this command from the root of the monorepo,
# so it can copy the pubspec files from the workspace root.
cd ../..
docker build --progress=plain -t sovereignchess_server:latest --file packages/server/Dockerfile .

# Run container
# docker run -d -p 8080:80 sovereignchess_server:latest
