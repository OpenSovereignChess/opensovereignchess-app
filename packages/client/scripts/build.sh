#!/bin/bash

source .env

# For riverpod and freezed
dart run build_runner build

flutter build web \
  --dart-define=BASE_URL=https://playsovereignchess.com \
  --dart-define=TURNSTILE_SITE_KEY=0x4AAAAAABl99hhcLfA7BkA4 \
  --dart-define=API_BASE_URL=https://be.playsovereignchess.com \
  --dart-define=SUPABASE_URL=$SUPABASE_URL \
  --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
