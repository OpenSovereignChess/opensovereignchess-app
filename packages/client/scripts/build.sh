#!/bin/bash

flutter build web \
  --dart-define=BASE_URL=https://playsovereignchess.com \
  --dart-define=TURNSTILE_SITE_KEY=0x4AAAAAABl99hhcLfA7BkA4 \
  --dart-define=API_BASE_URL=https://be.playsovereignchess.com
