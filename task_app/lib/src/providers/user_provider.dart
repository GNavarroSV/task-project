import 'package:flutter/cupertino.dart';
import 'package:task_app/src/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:task_app/src/preferences/preferences.dart';
import 'package:task_app/src/utils/utils.dart';

class UserProvider {
  final _prefs = UserPreferences();
  //final String _url = "http://192.168.1.19:8000/api";
  final String _url = "http://172.27.105.51:8000/api";

  Future<List<UserModel>> getUsers() async {
    final completeUrl = _url + '/user_list';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_prefs.accessToken}',
    };
    final url = Uri.parse(completeUrl);
    final resp = await http.get(url, headers: headers);
    final decodedData = json.decode(resp.body);
    final users = Users.fromJsonList(decodedData);
    return users.items;
  }

  Future<UserModel> getUser(int? userId) async {
    final completeUrl = _url + '/user_list/' + userId.toString();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_prefs.accessToken}',
    };
    final url = Uri.parse(completeUrl);
    final resp = await http.get(url, headers: headers);
    final decodedData = json.decode(resp.body);
    final user = UserModel.fromJson(decodedData);
    return user;
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    final completeUrl = _url + '/login';
    final headers = {'Content-Type': 'application/json'};
    final url = Uri.parse(completeUrl);

    Map<String, dynamic> userData = {
      "username": username,
      "password": password
    };

    final body = json.encode(userData);
    final resp = await http.post(url, headers: headers, body: body);

    final Map<String, dynamic> responseData = json.decode(resp.body);

    if (responseData['status'] == 'User authenticated') {
      getToken(username, password);
      _prefs.username = username;
      return {'authenticated': true};
    } else {
      return {'authenticated': false};
    }
  }

  Future<String> logout() async {
    final completeUrl = _url + '/logout';
    final url = Uri.parse(completeUrl);
    final resp = await http.post(url);
    if (resp.statusCode == 200) {
      return 'Logout done';
    } else {
      return 'Logout failed';
    }
  }

  Future<Map<String, dynamic>> getToken(
      String username, String password) async {
    final completeUrl = _url + '/token';
    final headers = {'Content-Type': 'application/json'};
    final url = Uri.parse(completeUrl);

    Map<String, dynamic> userData = {
      "username": username,
      "password": password
    };

    final body = json.encode(userData);
    final resp = await http.post(url, headers: headers, body: body);
    final encodedData = json.decode(resp.body);

    if (resp.statusCode == 200) {
      _prefs.accessToken = encodedData['access'];
      _prefs.refreshToken = encodedData['refresh'];
      print(encodedData);
      return encodedData;
    } else {
      return {'status': 'token expired'};
      //throw Exception('Failed to generate token');
    }
  }

  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    final completeUrl = _url + '/token/refresh';
    final headers = {'Content-Type': 'application/json'};
    final url = Uri.parse(completeUrl);

    Map<String, dynamic> tokenData = {"refresh": refreshToken};

    final body = json.encode(tokenData);
    final resp = await http.post(url, headers: headers, body: body);

    final decodedData = json.decode(resp.body);

    if (resp.statusCode == 200) {
      _prefs.accessToken = decodedData['access'];
      return decodedData;
    } else {
      return {'status': 'session expired'};
    }
  }
}
