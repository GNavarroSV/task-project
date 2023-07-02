// To parse this JSON data, do
//
//     final task = taskFromJson(jsonString);

import 'dart:convert';

class Tasks {
  List<TaskModel> items = [];
  Tasks();

  Tasks.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    for (final item in jsonList) {
      final task = TaskModel.fromJson(item);
      items.add(task);
    }
  }
}

//Task taskFromJson(String str) => Task.fromJson(json.decode(str));
//String taskToJson(Task data) => json.encode(data.toJson());

class TaskModel {
  int? skTask;
  int? fkAsignedUser;
  String? stTitle;
  String? stDescription;
  DateTime? fcDueDate;
  bool bnCompleted;

  TaskModel({
    this.skTask,
    this.fkAsignedUser,
    this.stTitle = '',
    this.stDescription = '',
    this.fcDueDate,
    this.bnCompleted = false,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
        skTask: json["SK_TASK"],
        fkAsignedUser: json["FK_ASIGNED_USER"],
        stTitle: json["ST_TITLE"],
        stDescription: json["ST_DESCRIPTION"],
        fcDueDate: DateTime.parse(json["FC_DUE_DATE"]),
        bnCompleted: json["BN_COMPLETED"],
      );

  Map<String, dynamic> toJson() => {
        "SK_TASK": skTask,
        "FK_ASIGNED_USER": fkAsignedUser,
        "ST_TITLE": stTitle,
        "ST_DESCRIPTION": stDescription,
        "FC_DUE_DATE":
            "${fcDueDate!.year.toString().padLeft(4, '0')}-${fcDueDate!.month.toString().padLeft(2, '0')}-${fcDueDate!.day.toString().padLeft(2, '0')}",
        "BN_COMPLETED": bnCompleted,
      };
}
