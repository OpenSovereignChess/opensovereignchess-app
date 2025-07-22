#!/bin/bash

source .env

flutter run -d chrome \
  --dart-define=BASE_URL=http://localhost \
  --dart-define=TURNSTILE_SITE_KEY=0x4AAAAAABl99hhcLfA7BkA4 \
  --dart-define=API_BASE_URL=http://localhost:8080 \
  --dart-define=SUPABASE_URL=$SUPABASE_URL \
  --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
