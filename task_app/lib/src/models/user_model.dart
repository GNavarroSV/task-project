// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

//User userFromJson(String str) => User.fromJson(json.decode(str));

//String userToJson(User data) => json.encode(data.toJson());

class Users {
  List<UserModel> items = [];
  Users();

  Users.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    for (final item in jsonList) {
      final user = UserModel.fromJson(item);
      items.add(user);
    }
  }
}

class UserModel {
  int id;
  String username;
  String email;
  int? taskCount;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    this.taskCount,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        taskCount: json["task_count"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "task_count": taskCount,
      };
}
