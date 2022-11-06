import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Auth with ChangeNotifier {
  static const _url =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyD5BowDVXwGxecnB2A1WVAi1r5gKP4e2sw';

  Future<void> signup(String email, String password) async {
    final response = await post(Uri.parse(_url),
        body: jsonEncode(
            {'email': email, 'password': password, 'returnSecureToken': true}));
    print(response.body);
  }
}
