# Official Dart image: https://hub.docker.com/_/dart
# Specify the Dart SDK base image version using dart:<version> (ex: dart:2.12)
FROM dart:stable AS build

# Resolve app dependencies.
WORKDIR /app
#COPY pubspec.* ./
COPY ../.. .
RUN ls
RUN rm -rf packages/client
RUN ls packages
RUN sed -i '/packages\/client/d' pubspec.yaml
RUN dart pub get
RUN mkdir bin

# Copy app source code and AOT compile it.
#COPY . .
# Ensure packages are still up-to-date if anything has changed
#RUN dart pub get --offline
RUN dart compile exe packages/server/bin/server.dart -o bin/server

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
