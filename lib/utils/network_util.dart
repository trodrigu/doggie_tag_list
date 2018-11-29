import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Client {
  final JsonDecoder _decoder = new JsonDecoder();
  final http.Client _inner = new http.Client();

  Future<dynamic> get(String url) {
    return _inner.get(url).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }

  Future<dynamic> post(String url, {Map<String, String> body, headers}) {
    return _inner
        .post(url, body: body, headers: headers)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }
}
