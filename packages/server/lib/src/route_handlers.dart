import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart' show JWT, SecretKey;
import 'package:shelf/shelf.dart' show Request, Response;

import './supabase_service.dart' show SupabaseService;

final supabase = SupabaseService();

Response rootHandler(Request request) =>
    Response.ok('Ok', headers: {'Content-Type': 'text/plain'});

Response echoHandler(Request request) => Response.ok(
  'Request for "${request.url}"',
  headers: {'Content-Type': 'text/plain'},
);

Future<Response> createGameHandler(Request request) async {
  final authHeader = request.headers['Authorization'];
  if (authHeader == null || !authHeader.startsWith('Bearer ')) {
    return Response.forbidden(
      'Authorization header is missing or invalid',
      headers: {'Content-Type': 'text/plain'},
    );
  }

  final token = authHeader.substring(7); // Remove 'Bearer ' prefix

  try {
    final decodedToken = JWT.verify(token, SecretKey(supabase.jwtSecret));
    print('Payload: ${decodedToken.payload["sub"]}');
    String userId = decodedToken.payload['sub'];
    final data = await supabase.createGame(userId);
    print('New game created: $data');
  } catch (err) {
    print('Error getting user from token: $err');
    return Response.forbidden(
      'Invalid token or user not found',
      headers: {'Content-Type': 'text/plain'},
    );
  }

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
