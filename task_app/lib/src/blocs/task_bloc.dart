import 'dart:async';

import 'package:task_app/src/models/task_model.dart';
import 'package:task_app/src/providers/task_provider.dart';
import 'package:rxdart/rxdart.dart';

class TaskBloc {
  final _taskStreamController = BehaviorSubject<List<TaskModel>>();
  final _cargandoController = BehaviorSubject<bool>();

  final _taskProvider = TaskProvider();

  Stream<List<TaskModel>> get blocStream => _taskStreamController.stream;

  Stream<bool> get cargando => _cargandoController.stream;
  void dispose() {
    _taskStreamController.close();
  }

  void loadTasks() async {
    final tasks = await _taskProvider.getTasks();
    _taskStreamController.sink.add(tasks);
  }

  void addTask(TaskModel task) async {
    _cargandoController.sink.add(true);
    await _taskProvider.addTask(task);
    loadTasks();
    _cargandoController.sink.add(false);
  }

  void editTask(TaskModel task) async {
    _cargandoController.sink.add(true);
    await _taskProvider.editTask(task);
    _cargandoController.sink.add(false);
  }

  void deleteTask(TaskModel task) async {
    _cargandoController.sink.add(true);
    await _taskProvider.deleteTask(task);
    _cargandoController.sink.add(false);
  }

  void completeTask(TaskModel task) async {
    _cargandoController.sink.add(true);
    await _taskProvider.completeTask(task);
    loadTasks();
    _cargandoController.sink.add(false);
  }
}
