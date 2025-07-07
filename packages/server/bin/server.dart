import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

void main() async {
  var handler = const Pipeline()
      .addMiddleware(logRequests())
      .addHandler(_echoRequest);

  var server = await shelf_io.serve(handler, InternetAddress.anyIPv4, 8080);

  server.autoCompress = true;

  print('Serving at http://${server.address.host}:${server.port}');
}

Response _echoRequest(Request request) => Response.ok(
  'Request for "${request.url}"',
  headers: {'Content-Type': 'text/plain'},
);
