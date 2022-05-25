import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserAuth {
  final String accessToken;

  const UserAuth({required this.accessToken});

  factory UserAuth.fromJson(Map<String, dynamic> json) {
    return UserAuth(
      accessToken: json['access_token'],
    );
  }
}

Future<UserAuth> postUserLogin(String email, password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final response = await http.post(
    Uri.parse("${dotenv.env['VAR_NAME']}/login"),
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
    }),
  );
  // print('response: ${jsonDecode(response.body)}');

  final decodedResponse = UserAuth.fromJson(jsonDecode(response.body));
  // if (response.statusCode == 200) {
  //   prefs.setString('access_token', decodedResponse.accessToken);
  // }

  return decodedResponse;
}

Future<UserAuth> postUserRegister() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final response =
      await http.post(Uri.parse("${dotenv.env['BE_API_URL']}/register"));
  if (response.statusCode == 200) {
    prefs.setString('access_token', jsonDecode(response.body).access_token);
  }

  final decodedResponse = UserAuth.fromJson(jsonDecode(response.body));
  print('response: ${response.body}');

  return decodedResponse;
}
