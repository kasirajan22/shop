import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _logoutTimer;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> signup(String email, String password) async {
    try {
      final url =
          "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyB0DZlYJEdo4ta-mktiXI5TKKmvjEvsO44";
      var response = await http.post(
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
      autoLogout();
      await setUserPref();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      final url =
          "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyB0DZlYJEdo4ta-mktiXI5TKKmvjEvsO44";
      var response = await http.post(
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
      autoLogout();
      setUserPref();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> setUserPref() async {
    var prefs = await SharedPreferences.getInstance();
    String userdata = json.encode(
      {
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      },
    );
    prefs.setString('userDetail', userdata);
  }

  Future<bool> autoLogin() async {
    var prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userDetail')) {
      return false;
    }

    var decodedData =
        json.decode(prefs.getString('userDetail')) as Map<String, Object>;
    var expiryDate = DateTime.parse(decodedData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = decodedData['token'];
    _userId = decodedData['userId'];
    _expiryDate = expiryDate;
    autoLogout();
    notifyListeners();
    return true;
  }

  Future<void> logout() async{
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_logoutTimer != null) {
      _logoutTimer.cancel();
    }
    var prefs = await SharedPreferences.getInstance();
    prefs.clear();
    notifyListeners();
  }

  void autoLogout() {
    if (_logoutTimer != null) {
      _logoutTimer.cancel();
    }
    var timediff = _expiryDate.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(Duration(seconds: timediff), logout);
  }
}
