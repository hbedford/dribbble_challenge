import 'dart:convert';

import 'package:http/http.dart';
import 'package:meta/meta.dart';

enum HttpError { serverError, badRequest, unauthorized, forbidden, notFound }

abstract class HttpClient {
  Future request(
      {@required String url,
      @required String method,
      Map body,
      Map<String, String> headers});
}

class HttpAdapter implements HttpClient {
  final Client client;
  HttpAdapter(this.client);
  Future request(
      {@required String url,
      @required String method,
      Map body,
      Map<String, String> headers}) async {
    /* final headers = {
      'content-type': 'aplication/json',
      'accept': 'application/json'
    }; */
    final defaultHeaders = headers?.cast<String, String>() ?? {}
      ..addAll(
          {'content-type': 'application/json', 'accept': 'application/json'});
    final jsonBody = body != null ? jsonEncode(body) : null;
    var response = Response('', 500);

    Future<Response> futureResponse;
    try {
      if (method == 'post') {
        futureResponse = client.post(Uri.parse(url),
            headers: defaultHeaders, body: jsonBody);
      } else if (method == 'get') {
        futureResponse = client.get(Uri.parse(url), headers: defaultHeaders);
      }
      /* else if (method == 'put') {
        futureResponse =
            client.put(Uri.parse(url), headers: headers, body: jsonBody);
      } */
      if (futureResponse != null) {
        response = await futureResponse.timeout(Duration(seconds: 10));
      }
    } catch (error) {
      print(error);
      throw HttpError.serverError;
    }
    return _handleResponse(response);
  }

  _handleResponse(Response response) {
    print(response.body + ' teste');
    switch (response.statusCode) {
      case 200:
        return response.body is List
            ? response.body
            : response.body.isEmpty
                ? null
                : jsonDecode(response.body);
      case 204:
        return null;
      case 400:
        throw HttpError.badRequest;
      case 401:
        throw HttpError.unauthorized;
      case 403:
        throw HttpError.forbidden;
      case 404:
        throw HttpError.notFound;
      default:
        throw HttpError.serverError;
    }
  }
}
