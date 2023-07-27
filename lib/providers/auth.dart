import 'dart:convert';
import 'dart:io';
import '../models/http_exception.dart';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  late String _token;
  DateTime? _expiryDate;
  late int _userId;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  int get userID {
    return _userId;
  }

  Future<void> _authenticate(
      String username, String password, String urlSegment) async {
    final url = 'http://192.168.0.122:3000/$urlSegment';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'username': username,
            'password': password,
          },
        ),
      );
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData["error"] != null) {
        throw HttpException(responseData["error"]);
      }
      _token = responseData["token"];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: responseData["expiresIn"],
        ),
      );
      _userId = responseData["user_id"];
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> signup(String username, String password) async {
    return _authenticate(username, password, 'signup');
  }

  Future<void> login(String username, String password) async {
    return _authenticate(username, password, 'login');
  }
}
