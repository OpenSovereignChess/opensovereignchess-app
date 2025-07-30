# syntax=docker/dockerfile:1
#
# Official Dart image: https://hub.docker.com/_/dart
# Specify the Dart SDK base image version using dart:<version> (ex: dart:2.12)
FROM dart:stable AS build

# Resolve app dependencies.
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

# Copy app source code and AOT compile it.
COPY . .
# Ensure packages are still up-to-date if anything has changed
RUN dart pub get --offline
RUN --mount=type=secret,id=supabase \
    . /run/secrets/supabase && \
    dart compile exe bin/server.dart -o bin/server \
      --define=SUPABASE_URL=$SUPABASE_URL \
      --define=SUPABASE_SERVICE_KEY=$SUPABASE_SERVICE_KEY \
      --define=SUPABASE_JWT_SECRET=$SUPABASE_JWT_SECRET

# Build minimal serving image from AOT-compiled `/server` and required system
# libraries and configuration files stored in `/runtime/` from the build stage.
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/

# Include files in the /public directory to enable static asset handling
#COPY --from=build /app/public/ /public

# Start server.
EXPOSE 8080
CMD ["/app/bin/server"]
