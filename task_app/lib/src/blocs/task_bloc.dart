import 'dart:async';

import 'package:task_app/src/models/task_model.dart';
import 'package:task_app/src/providers/task_provider.dart';
import 'package:rxdart/rxdart.dart';

class TaskBloc {
  final _taskStreamController = BehaviorSubject<List<TaskModel>>();
  final _cargandoController = BehaviorSubject<bool>();

  final _taskProvider = TaskProvider();

  List<TaskModel> _allTasks = [];

  Stream<List<TaskModel>> get blocStream => _taskStreamController.stream;

  Stream<bool> get cargando => _cargandoController.stream;
  void dispose() {
    _taskStreamController.close();
  }

  void loadTasks() async {
    _cargandoController.sink.add(true);
    final tasks = await _taskProvider.getTasks();
    _allTasks = tasks; // Update _allTasks with the fetched tasks.
    applyFilters();
    _taskStreamController.sink.add(tasks);
    _cargandoController.sink.add(false);
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
    loadTasks();
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

  void applyFilters({String? name, bool showCompleted = true, String? user}) {
    // List of filtered tasks
    List<TaskModel> filteredTasks = _allTasks;

    if (name != null && name.isNotEmpty) {
      filteredTasks =
          filteredTasks.where((task) => task.stTitle!.contains(name)).toList();
    }

    if (!showCompleted) {
      filteredTasks = filteredTasks.where((task) => !task.bnCompleted).toList();
    }

    if (user != null && user.isNotEmpty) {
      filteredTasks = filteredTasks
          .where((task) => task.fkAsignedUser == int.parse(user))
          .toList();
    }
    // Update the stream with the filtered tasks
    _taskStreamController.sink.add(filteredTasks);
  }

  void cleanFilters() async {
    _cargandoController.sink.add(true);
    final tasks = await _taskProvider.getTasks();
    _taskStreamController.sink.add(tasks);
    _cargandoController.sink.add(false);
  }
}
