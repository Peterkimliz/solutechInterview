import 'dart:convert';

import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import '../utils/functions.dart';

class DbBase {
  static const postRequest = "POST";
  static const getRequest = "GET";
  static const deleteRequest = "DELETE";
  static const patchRequest = "PATCH";

  static databaseRequest(String url, String method,
      {Map<String, dynamic>? body, Map<String, String>? headers}) async {
    try {
      headers ??= {
        "apikey": Constants.apiKey,
        "Content-Type": "application/json",
        "Prefer": "return=representation", //
      };

      http.Request request = http.Request(method, Uri.parse(url));

      if (body != null) {
        request.body = jsonEncode(body);
        debugPrintMessage("Body is ${request.body}");
      }
      request.headers.addAll(headers);
      debugPrintMessage(method);
      debugPrintMessage(url);
      http.StreamedResponse response = await request.send();

      String data = await response.stream.bytesToString();

      return {"data": jsonDecode(data), "status": response.statusCode};
    } catch (e) {
      debugPrintMessage("The error that has occurred is $e");
    }
  }
}
