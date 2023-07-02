import 'package:flutter/material.dart';
import 'package:task_app/src/models/task_model.dart';

class TaskDetailsPage extends StatefulWidget {
  const TaskDetailsPage({super.key});

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetailsPage> {
  TaskModel task = TaskModel();
  TextEditingController _DateController = TextEditingController();
  String _title = '';
  String _description = '';
  String _date = '';

  @override
  Widget build(BuildContext context) {
    final TaskModel taskData =
        ModalRoute.of(context)?.settings.arguments as TaskModel;

    //Set task data if arguments is not empty
    //by doing this, we can check if we are
    //adding a task or editing it
    if (taskData != null) {
      task = taskData;
      _DateController.text = task.fcDueDate.toString();
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Page'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        child: Container(
          child: Form(
              child: Column(
            children: [
              _createTitle(),
              Divider(
                height: 30.0,
              ),
              _createDescription(),
              Divider(
                height: 30.0,
              ),
              _createDueDate(),
              Divider(
                height: 30.0,
              ),
              _createAsignation(),
            ],
          )),
        ),
      ),
    );
  }

  Widget _createTitle() {
    return TextFormField(
      initialValue: task.stTitle,
    );
  }

  Widget _createDescription() {
    return TextFormField(
      initialValue: task.stDescription,
    );
  }

  Widget _createDueDate() {
    return TextFormField(
      enableInteractiveSelection: false,
      controller: _DateController,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        hintText: 'Due date',
        labelText: 'Task Due Date',
        helperText: 'Date',
        icon: Icon(Icons.calendar_month_outlined),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        _selectDate(context);
      },
    );
  }

  Widget _createAsignation() {
    return Row(
      children: [
        Icon(Icons.select_all),
        SizedBox(width: 30.0),
        Expanded(
          child: DropdownButton(
            value: 'Hello',
            items: [],
            onChanged: (value) {
              setState(() {
                //'string' = value!;
              });
            },
          ),
        )
      ],
    );
  }

  _selectDate(BuildContext context) async {
    final actualDate = DateTime.now();
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023, actualDate.month, actualDate.day),
        lastDate: DateTime(2026),
        locale: Locale('es', 'ES'));
    if (picked != null) {
      setState(() {
        _date = picked.toString();
        _DateController.text = _date;
      });
    }
  }
}
