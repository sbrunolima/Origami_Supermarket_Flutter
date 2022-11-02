import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../data/http_exceptions.dart';
import 'dart:async';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;
  late SharedPreferences prefs;

  bool get isAuth {
    return token != '';
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token.toString();
    }
    return '';
  }

  String get userId {
    return _userId.toString();
  }

  Future<void> _autenticator(
      String email, String password, String urlSegment) async {
    final url = Uri.parse('');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );

      prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate!.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
    _autoLogout();
    notifyListeners();
  }

  Future<void> signup(String email, String password) async {
    return _autenticator(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _autenticator(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userData')) {
      final extractedUserData =
          json.decode(prefs.getString('userData').toString())
              as Map<String, Object>;
      final expiryDate =
          DateTime.parse(extractedUserData['expiryDate'].toString());

      if (expiryDate.isBefore(DateTime.now())) {
        return false;
      }

      _token = extractedUserData['token'].toString();
      _userId = extractedUserData['userId'].toString();
      _expiryDate = expiryDate;
      notifyListeners();
      _autoLogout();
      return true;
    } else {
      return false;
    }
  }

  Future<void> logout() async {
    _token = '';
    _userId = '';
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }

    prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }

    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
