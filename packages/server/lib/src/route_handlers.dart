import 'package:shelf/shelf.dart' show Request, Response;

Response rootHandler(Request request) =>
    Response.ok('Ok', headers: {'Content-Type': 'text/plain'});

Response echoHandler(Request request) => Response.ok(
  'Request for "${request.url}"',
  headers: {'Content-Type': 'text/plain'},
);
