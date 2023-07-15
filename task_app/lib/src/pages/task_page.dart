import 'package:flutter/material.dart';
import 'package:task_app/src/blocs/provider.dart';
import 'package:task_app/src/blocs/task_bloc.dart';
import 'package:task_app/src/models/task_model.dart';

class TaskPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final taskBloc = Provider.taskBloc(context);
    taskBloc.loadTasks();

    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
      ),
      body: SafeArea(
        child: Column(children: [
          _createWelcomeCard(context),
          Expanded(child: _createTaskList(taskBloc)),
          Center(
            child: Icon(
              Icons.arrow_drop_down,
              color: Colors.green,
              size: 30.0,
            ),
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 30.0,
        ),
        onPressed: () {
          Navigator.pushNamed(context, 'add_task');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget _createWelcomeCard(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            )
          ],
          color: Color.fromRGBO(62, 66, 107, 0.7),
          borderRadius: BorderRadius.circular(12.0)),
      width: double.infinity,
      height: _screenSize.height * 0.3,
      child: Center(child: Text('TESTING')),
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
        trailing: getIcon(task),
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

  Icon getIcon(TaskModel task) {
    if (task.bnCompleted) {
      return Icon(
        Icons.check_box,
        color: Colors.green,
      );
    }
    if (task.bnExpired) {
      return Icon(
        Icons.watch_later,
        color: Colors.red,
      );
    } else {
      return Icon(
        Icons.autorenew_sharp,
        color: Colors.blue,
      );
    }
  }
}
