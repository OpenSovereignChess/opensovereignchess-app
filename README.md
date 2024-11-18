# Sovereign Chess

Flutter app for playing Sovereign Chess.

## Development

To run site locally:

```
flutter run -d chrome
```

### Adding piece assets

We precompile and optimize the SVGs.  This also allows us to create constant values for the piece images.  To generate the piece SVG vector, run:

```
./bin/generate_piece_svgs.sh
```

## Deployment

We use Firebase Hosting for the web version of the app.  To deploy:

```
flutter build web
firebase deploy
```
