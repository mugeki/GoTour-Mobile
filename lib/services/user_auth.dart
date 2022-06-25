import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gotour_mobile/services/response_meta.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserAuth {
  final Meta meta;
  final dynamic accessToken;

  const UserAuth({
    required this.meta,
    required this.accessToken,
  });

  factory UserAuth.fromJson(Map<String, dynamic> json) {
    return UserAuth(
      meta: Meta.fromJson(json['meta']),
      accessToken: json['data'] == null ? '' : json['data']['access_token'],
    );
  }
}

Future postUserLogin(String email, password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final apiUrl = "${dotenv.env['BE_API_URL']}/login";
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'email': email,
      'password': password,
    }),
  );

  dynamic decodedResponse;
  if (response.body.isEmpty) {
    return response.statusCode;
  }
  decodedResponse = UserAuth.fromJson(jsonDecode(response.body));
  await prefs.setString('access_token', decodedResponse.accessToken);
  return decodedResponse;
}

Future postUserRegister(name, email, password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final apiUrl = "${dotenv.env['BE_API_URL']}/register";
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
    }),
  );

  dynamic decodedResponse;
  if (response.body.isEmpty) {
    return response.statusCode;
  }
  decodedResponse = UserAuth.fromJson(jsonDecode(response.body));
  await prefs.setString('access_token', decodedResponse.accessToken);
  return decodedResponse;
}

Future logoutUser() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('access_token');
  final apiUrl = "${dotenv.env['BE_API_URL']}/logout";
  final response = await http.post(Uri.parse(apiUrl), headers: {
    'Content-Type': 'application/json; charset=UTF-8',
    HttpHeaders.authorizationHeader: "Bearer $accessToken",
  });

  if (response.statusCode == 200) {
    await prefs.remove('access_token');
    return response.statusCode;
  }
  return response.statusCode;
}
