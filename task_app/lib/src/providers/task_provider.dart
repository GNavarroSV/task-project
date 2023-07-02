import 'dart:convert';

import 'package:task_app/src/models/task_model.dart';
import 'package:http/http.dart' as http;

class TaskProvider {
  final String _url = "http://192.168.1.19:8000/api";

  Future<List<TaskModel>> getTasks() async {
    final completeUrl = _url + '/task_list';
    final url = Uri.parse(completeUrl);
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    //print(decodedData['results']);
    final tasks = Tasks.fromJsonList(decodedData);
    return tasks.items;
  }

  // Future<String> addTask() async {
  //   final competeUrl = _url + '/add_task';

  //   if (response.statusCode == 201) {
  //     print('Task added successfully');
  //   } else {
  //     throw Exception('Failed to add task');
  //   }
  // }
}
