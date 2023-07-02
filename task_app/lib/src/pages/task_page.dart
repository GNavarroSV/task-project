import 'package:flutter/material.dart';
import 'package:task_app/src/models/task_model.dart';
import 'package:task_app/src/providers/task_provider.dart';

class TaskPage extends StatelessWidget {
  final _taskProvider = TaskProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
      ),
      body: SafeArea(
        child: Column(children: [
          _createWelcomeCard(context),
          Expanded(child: _createTaskList()),
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
          color: Color.fromRGBO(62, 66, 107, 0.7),
          borderRadius: BorderRadius.circular(12.0)),
      width: double.infinity,
      height: _screenSize.height * 0.3,
      child: Center(child: Text('TESTING')),
    );
  }

  Widget _createTaskList() {
    return FutureBuilder(
      future: _taskProvider.getTasks(),
      builder: (context, AsyncSnapshot<List<TaskModel>> snapshot) {
        if (snapshot.hasData) {
          return _TaskListItems(snapshot.data);
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

  Widget _TaskListItems(List<TaskModel>? tasks) {
    return ListView.builder(
      itemCount: tasks!.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(tasks[index].stTitle as String),
          subtitle: Text(tasks[index].stDescription as String),
          onTap: () {
            Navigator.pushNamed(context, 'add_task', arguments: tasks[index]);
          },
        );
      },
    );
  }
}
