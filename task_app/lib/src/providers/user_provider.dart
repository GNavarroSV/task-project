import 'package:task_app/src/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProvider {
  //final String _url = "http://192.168.1.19:8000/api";
  final String _url = "http://172.27.105.51:8000/api";

  Future<List<UserModel>> getUsers() async {
    final completeUrl = _url + '/user_list';
    final url = Uri.parse(completeUrl);
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final users = Users.fromJsonList(decodedData);
    return users.items;
  }

  Future<UserModel> getUser(int? userId) async {
    final completeUrl = _url + '/user_list/' + userId.toString();
    final url = Uri.parse(completeUrl);
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final user = UserModel.fromJson(decodedData);
    return user;
  }
}
