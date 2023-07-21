import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:task_app/src/blocs/provider.dart';
import 'package:task_app/src/blocs/task_bloc.dart';
import 'package:task_app/src/models/task_model.dart';
import 'package:task_app/src/preferences/preferences.dart';
import 'package:task_app/src/providers/user_provider.dart';
import 'package:task_app/src/utils/utils.dart' as utils;
import 'package:task_app/src/widgets/filter_section.dart';

class TaskPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskBloc = Provider.taskBloc(context);
    taskBloc.loadTasks();
    final _prefs = UserPreferences();
    final userProvider = UserProvider();
    final DateTime actualDate = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text('TaskFlow App'),
        actions: [
          IconButton(
              onPressed: () {
                userProvider.logout();
                Navigator.pushReplacementNamed(context, 'login');
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: SafeArea(
        child: Column(children: [
          _createWelcomeCard(context, _prefs, actualDate),
          TaskFilterSection(taskBloc),
          Expanded(child: _createTaskList(taskBloc)),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pushNamed(context, 'add_task');
        },
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
    );
  }

  Widget _createWelcomeCard(
      BuildContext context, UserPreferences prefs, DateTime actualDate) {
    final _screenSize = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color.fromARGB(255, 239, 221, 221).withOpacity(0.5),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3),
        )
      ], color: Colors.green, borderRadius: BorderRadius.circular(12.0)),
      width: double.infinity,
      height: _screenSize.height * 0.18,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              height: 100.0,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0),
                  color: Colors.white),
              child: Icon(
                Icons.person,
                color: Colors.green,
              )),
          SizedBox(
            width: 20.0,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Welcome back @${prefs.username}, is nice to see you again!',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
                Text(
                  '${DateFormat.yMMMMd().format(actualDate)}',
                  style: TextStyle(color: Colors.white, fontSize: 15.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _createTaskList(TaskBloc taskBloc) {
    return StreamBuilder(
      stream: taskBloc.blocStream,
      builder: (context, AsyncSnapshot<List<TaskModel>> snapshot) {
        if (snapshot.hasData) {
          final tasks = snapshot.data;
          return ListView.builder(
              itemCount: tasks!.length,
              itemBuilder: (context, index) =>
                  _taskListItems(context, tasks[index], taskBloc));

          //return _taskListItems(tasks, taskBloc);
        } else {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
            ],
          );
        }
      },
    );
  }

  Widget _taskListItems(
      BuildContext context, TaskModel task, TaskBloc taskBloc) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        padding: EdgeInsets.all(12.0),
        color: Colors.red,
        child: Column(
          children: [
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              'Task deleted',
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
      onDismissed: (direction) {
        taskBloc.deleteTask(task);
      },
      child: ListTile(
        title: Text(task.stTitle as String),
        subtitle: Text(task.stDescription as String),
        trailing: utils.getIcon(task),
        onTap: () {
          Navigator.pushNamed(context, 'add_task', arguments: task);
        },
        onLongPress: () {
          _confirmCompleteDialog(context, taskBloc, task);
        },
      ),
    );
  }

  void _confirmCompleteDialog(
      BuildContext context, TaskBloc taskBloc, TaskModel task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Complete Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'Are you sure that you want to complete the task "${task.stTitle}"?'),
            ],
          ),
          actions: [
            MaterialButton(
              child: Text(
                'Confirm',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                taskBloc.completeTask(task);
                Navigator.pop(context);
              },
            ),
            MaterialButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      },
    );
  }
}
