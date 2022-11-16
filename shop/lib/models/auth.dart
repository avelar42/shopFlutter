import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shop/exceptions/auth_exception.dart';

import '../data/store.dart';

class Auth with ChangeNotifier {
  static const _url =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyD5BowDVXwGxecnB2A1WVAi1r5gKP4e2sw';
  String? _token;
  String? _email;
  String? _userid;
  DateTime? _expireDate;
  Timer? _logoutTimer;

  bool get isAuth {
    final isValid = _expireDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  String? get token {
    return isAuth ? _token : null;
  }

  String? get email {
    return isAuth ? _email : null;
  }

  String? get userid {
    return isAuth ? _userid : null;
  }

  Future<void> _authenticate(
      String email, String password, String urlFragment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlFragment?key=AIzaSyD5BowDVXwGxecnB2A1WVAi1r5gKP4e2sw';
    final response = await post(Uri.parse(url),
        body: jsonEncode(
            {'email': email, 'password': password, 'returnSecureToken': true}));

    final body = jsonDecode(response.body);
    if (body['error'] != null) {
      throw AuthException(body['error']['message']);
    } else {
      _token = body['idToken'];
      _email = body['email'];
      _userid = body['localId'];
      _expireDate =
          DateTime.now().add(Duration(seconds: int.parse(body['expiresIn'])));

      Store.saveMap('userData', {
        'token': _token,
        'email': _email,
        'userId': userid,
        'expireDate': _expireDate!.toIso8601String()
      });
      _autoLogout();
      notifyListeners();
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> tryAutoLogin() async {
    if (isAuth) {
      return;
    }

    final userData = await Store.getMap('userData');
    if (userData.isEmpty) {
      return;
    }

    final expireDate = DateTime.parse(userData['expireDate']);
    if (expireDate.isBefore(DateTime.now())) return;

    _token = userData['token'];
    _email = userData['email'];
    _userid = userData['userId'];
    _expireDate = expireDate;

    _autoLogout();
    notifyListeners();
  }

  void logout() {
    _token = null;
    _email = null;
    _userid = null;
    _expireDate = null;
    _clearLogoutTimer();
    notifyListeners();
  }

  void _clearLogoutTimer() {
    _logoutTimer?.cancel();
    _logoutTimer = null;
  }

  void _autoLogout() {
    _clearLogoutTimer();
    final timeToLogout = _expireDate?.difference(DateTime.now()).inSeconds;
    print(timeToLogout);
    _logoutTimer = Timer(Duration(seconds: timeToLogout ?? 0), logout);
  }
}
