import 'dart:convert';

import 'package:task_app/src/models/task_model.dart';
import 'package:http/http.dart' as http;
import 'package:task_app/src/preferences/preferences.dart';

class TaskProvider {
  //final String _url = "http://192.168.1.19:8000/api";
  //final String _url = "http://172.27.105.51:8000/api";
  final String _url = "https://navarrooo.pythonanywhere.com/api";
  final _prefs = UserPreferences();

  Future<List<TaskModel>> getTasks() async {
    final completeUrl = _url + '/task_list';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_prefs.accessToken}',
    };
    final url = Uri.parse(completeUrl);
    final resp = await http.get(url, headers: headers);
    final decodedData = json.decode(resp.body);
    //print(decodedData['results']);
    final tasks = Tasks.fromJsonList(decodedData);
    return tasks.items;
  }

  Future<String> addTask(TaskModel task) async {
    final completeUrl = _url + '/add_task';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_prefs.accessToken}',
    };
    final url = Uri.parse(completeUrl);
    //Set the dynamic map to change the due date object type
    Map<String, dynamic> taskData = task.toJson();
    taskData['FC_DUE_DATE'] = taskData['FC_DUE_DATE'].toString();
    //print(taskData['FK_ASIGNED_USER']);
    //When adding headers, body must be a direct parameter
    final body = jsonEncode(taskData);
    final resp = await http.post(url, headers: headers, body: body);
    if (resp.statusCode == 200) {
      return ('Task added successfully');
    } else {
      throw Exception('Failed to add task');
    }
  }

  Future<String> editTask(TaskModel task) async {
    final completeUrl = _url + '/task_details/' + task.skTask.toString();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_prefs.accessToken}',
    };
    final url = Uri.parse(completeUrl);

    //Set the dynamic map to change the due date object type
    Map<String, dynamic> taskData = task.toJson();
    taskData['FC_DUE_DATE'] = taskData['FC_DUE_DATE'].toString();
    // Add _method parameter to emulate PUT request
    //taskData['method'] = 'PUT';
    //When adding headers, body must be a direct parameter
    final body = jsonEncode(taskData);
    final resp = await http.put(url, headers: headers, body: body);
    if (resp.statusCode == 200) {
      return ('Task edited successfully');
    } else {
      print(resp.body);
      throw Exception('Failed to edit task');
    }
  }

  Future<String> deleteTask(TaskModel task) async {
    final completeUrl = _url + '/task_details/' + task.skTask.toString();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_prefs.accessToken}',
    };
    final url = Uri.parse(completeUrl);
    final resp = await http.delete(url, headers: headers);
    if (resp.statusCode == 200) {
      return ('Task deleted successfully');
    } else {
      throw Exception('Failed to delete task');
    }
  }

  Future<String> completeTask(TaskModel task) async {
    final completeUrl =
        _url + '/task_details/completed/' + task.skTask.toString();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${_prefs.accessToken}',
    };
    final url = Uri.parse(completeUrl);
    final resp = await http.put(url, headers: headers);
    if (resp.statusCode == 200) {
      print('Task completed successfully');
      return ('Task completed successfully');
    } else {
      throw Exception('Failed to complete task');
    }
  }
}
