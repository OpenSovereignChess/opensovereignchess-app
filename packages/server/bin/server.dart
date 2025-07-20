import 'dart:io';

import 'package:shelf/shelf.dart' show Pipeline, logRequests;
import 'package:shelf_router/shelf_router.dart' show Router;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:server/server.dart' show rootHandler, echoHandler;

void main() async {
  final appRouter = Router();

  appRouter.get('/', rootHandler);
  appRouter.get('/<anything|.*>', echoHandler);

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(appRouter.call);

  var server = await shelf_io.serve(handler, InternetAddress.anyIPv4, 8080);

  server.autoCompress = true;

  print('Serving at http://${server.address.host}:${server.port}');
}
