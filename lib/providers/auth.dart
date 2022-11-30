import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mening_dokonim/servises/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _autoLogoutTimer;

  static const apiKey = 'AIzaSyAZdka6GNMlNDNvpdDZ7cUR8xmkAAd6eMM';

  Future<void> _authenticate(
      String email, String password, String urlSigment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSigment?key=$apiKey');

    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );

      final data = jsonDecode(response.body);

      if (data['error'] != null) {
        throw HttpException(data['error']['message']);
      }
      _token = data['idToken'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(data['expiresIn']),
        ),
      );
      _userId = data['localId'];
      _autoLogout();
      notifyListeners();

      final pref = await SharedPreferences.getInstance();
      final userDate = jsonEncode({
        'userId': _userId,
        'token': _token,
        'expiryDate': _expiryDate!.toIso8601String(),
      });
      pref.setString('userDate', userDate);
    } catch (e) {
      rethrow;
    }
  }

  bool get isAuth {
    return token != null;
  }

  String? get userId {
    return _userId;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  void logout() async {
    _expiryDate = null;
    _token = null;
    _userId = null;
    if (_autoLogoutTimer != null) {
      _autoLogoutTimer!.cancel();
      _autoLogoutTimer = null;
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }

  Future<bool> autoLogin() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (!prefs.containsKey('userData')) {
        return false;
      }
      final userData =
          jsonDecode(prefs.getString('userData')!) as Map<String, dynamic>;

      final expiryDate = DateTime.parse(userData['expiryDate']);

      // expiryDate = 10:00 - Hozir vaqt 10:30
      if (expiryDate.isBefore(DateTime.now())) {
        // token muddati tugagan.
        return false;
      }

      // token muddati hali tugamagan
      _token = userData['token'];
      _userId = userData['userId'];
      _expiryDate = expiryDate;
      notifyListeners();
      _autoLogout();

      return true;
    } catch (e) {
      return false;
    }
  }

  void _autoLogout() {
    if (_autoLogoutTimer != null) {
      _autoLogoutTimer!.cancel();
    }
    final timeToExpire = _expiryDate!.difference(DateTime.now()).inSeconds;
    _autoLogoutTimer = Timer(Duration(seconds: timeToExpire), logout);
  }
}
