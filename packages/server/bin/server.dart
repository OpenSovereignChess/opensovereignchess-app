import 'dart:io';

import 'package:shelf/shelf.dart' show Pipeline, logRequests;
import 'package:shelf_router/shelf_router.dart' show Router;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_cors_headers/shelf_cors_headers.dart' show corsHeaders;
import 'package:server/server.dart'
    show
        rootHandler,
        echoHandler,
        createGameHandler,
        joinGameHandler,
        makeMoveHandler;

void main() async {
  final appRouter = Router();

  appRouter.get('/', rootHandler);
  appRouter.get('/<anything|.*>', echoHandler);
  appRouter.post('/games', createGameHandler);
  appRouter.post('/games/<gameId>/players', joinGameHandler);
  appRouter.post('/games/<gameId>/moves', makeMoveHandler);

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(
        corsHeaders(
          headers: {
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
            'Access-Control-Allow-Headers': 'Authorization, Content-Type',
          },
        ),
      )
      .addHandler(appRouter.call);

  var server = await shelf_io.serve(handler, InternetAddress.anyIPv4, 8080);

  server.autoCompress = true;

  print('Serving at http://${server.address.host}:${server.port}');
}
