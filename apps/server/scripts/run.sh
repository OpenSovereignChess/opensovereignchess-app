#!/bin/bash

source ../../.env

dart run \
  --define=SUPABASE_URL=$SUPABASE_URL \
  --define=SUPABASE_SERVICE_KEY=$SUPABASE_SERVICE_KEY \
  --define=SUPABASE_JWT_SECRET=$SUPABASE_JWT_SECRET \
  bin/server.dart
