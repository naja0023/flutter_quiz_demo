import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:http/http.dart' as http;

enum HttpMethod { get, post }

class HttpService {
  static Future<Response> request(
      {required HttpMethod method,
      required String url,
      Map<String, String>? header,
      Object? body,
      String? log}) async {
    try {
      Map<String, String> _header;
      late Response _response;
      if (header == null) {
        _header = {'Content-Type': 'application/json; charset=UTF-8'};
      } else {
        _header = header;
      }
      if (method == HttpMethod.get) {
        _response = await http.get(Uri.parse(url), headers: _header);
      } else {
        _response = await http.post(Uri.parse(url),
            headers: _header, body: jsonEncode(body));
      }
      return _response;
    } catch (e) {
      rethrow;
    }
  }
}
