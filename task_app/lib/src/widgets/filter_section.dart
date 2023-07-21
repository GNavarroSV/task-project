import 'package:flutter/material.dart';
import 'package:task_app/src/blocs/task_bloc.dart';
import 'package:task_app/src/models/user_model.dart';
import 'package:task_app/src/providers/user_provider.dart';

class TaskFilterSection extends StatefulWidget {
  final TaskBloc taskBloc;

  TaskFilterSection(this.taskBloc);

  @override
  State<TaskFilterSection> createState() => _TaskFilterSectionState();
}

class _TaskFilterSectionState extends State<TaskFilterSection> {
  TextEditingController _nameFilterController = TextEditingController();
  bool _showCompleted = true;
  String? _selectedUser;
  final userProvider = UserProvider();

  @override
  Widget build(BuildContext context) {
    // The filter section UI contains a Column with several filter options.
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: [
          // TextField for entering the task name filter.
          TextField(
            controller: _nameFilterController,
            decoration: InputDecoration(
              labelText: 'Filter by name',
              border: OutlineInputBorder(),
            ),
          ),
          // Checkbox for showing completed tasks.
          CheckboxListTile(
            title: Text('Show Completed Tasks'),
            value: _showCompleted,
            onChanged: (newValue) {
              setState(() {
                _showCompleted = newValue!;
              });
            },
          ),
          // DropdownButton for filtering tasks by assigned user.
          Row(children: [
            SizedBox(width: 8.0),
            Expanded(
              child: FutureBuilder(
                future: userProvider.getUsers(),
                builder: (context, AsyncSnapshot<List<UserModel>> snapshot) {
                  if (snapshot.hasData) {
                    return DropdownButton<String>(
                      value: _selectedUser,
                      hint: Text('Filter by assigned user'),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedUser = newValue;
                        });
                      },
                      items: snapshot.data!
                          .map((user) => DropdownMenuItem<String>(
                                value: user.id.toString(),
                                child: Text(user.username),
                              ))
                          .toList(),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ]),
          // Button to apply the selected filters.
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Apply the filters to the taskBloc by calling the applyFilters function.
                  widget.taskBloc.applyFilters(
                    name: _nameFilterController.text,
                    showCompleted: _showCompleted,
                    user: _selectedUser,
                  );
                },
                child: Text('Apply'),
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.red)),
                onPressed: () {
                  setState(() {
                    _selectedUser = null;
                    _nameFilterController.text = '';
                    _showCompleted = true;
                  });

                  widget.taskBloc.cleanFilters();
                },
                child: Text('Clean'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
