#!/bin/bash

# Tag image for Cloud Run
docker tag sovereignchess-server:latest us-east4-docker.pkg.dev/sovereign-chess-server/sovereignchess-server-repo/server-image:latest

# Push image to Artifact Registry
docker push us-east4-docker.pkg.dev/sovereign-chess-server/sovereignchess-server-repo/server-image:latest

# Deploy to Cloud Run
gcloud run deploy sovereignchess-server --region us-east4 --image us-east4-docker.pkg.dev/sovereign-chess-server/sovereignchess-server-repo/server-image
