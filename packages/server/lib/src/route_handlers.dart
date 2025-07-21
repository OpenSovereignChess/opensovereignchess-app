import 'package:shelf/shelf.dart' show Request, Response;

Response rootHandler(Request request) =>
    Response.ok('Ok', headers: {'Content-Type': 'text/plain'});

Response echoHandler(Request request) => Response.ok(
  'Request for "${request.url}"',
  headers: {'Content-Type': 'text/plain'},
);

Response createGameHandler(Request request) {
  // Here you would typically handle the creation of a game.
  // For now, we just return a placeholder response.
  return Response.ok(
    'Game created successfully',
    headers: {'Content-Type': 'text/plain'},
  );
}

Response joinGameHandler(Request request, String gameId) {
  // Here you would typically handle joining a game with the given gameId.
  // For now, we just return a placeholder response.
  return Response.ok(
    'Joined game with ID: $gameId',
    headers: {'Content-Type': 'text/plain'},
  );
}

Response makeMoveHandler(Request request, String gameId) {
  // Here you would typically handle making a move in the game with the given gameId.
  // For now, we just return a placeholder response.
  return Response.ok(
    'Move made in game with ID: $gameId',
    headers: {'Content-Type': 'text/plain'},
  );
}
