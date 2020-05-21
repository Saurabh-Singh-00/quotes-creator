import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class API {
  Map<String, String> getAuthHeader(String authKey) {
    return {
      HttpHeaders.authorizationHeader: "$authKey",
    };
  }

  String paramsToString(List<String> params) => params.join("/") + "/";

  Future<dynamic> get(
      {@required String url, List params, @required String authKey}) async {
    http.Response response;
    try {
      response = await http.get(url + paramsToString(params ?? []),
          headers: getAuthHeader(authKey));
    } on SocketException {
      throw SocketException("Please Check your Internet!");
    } catch (e) {
      throw Exception("$e");
    }
    return json.decode(response.body);
  }
}
