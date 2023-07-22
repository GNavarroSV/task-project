import 'package:flutter/material.dart';
import 'package:task_app/src/blocs/provider.dart';
import 'package:task_app/src/blocs/task_bloc.dart';
import 'package:task_app/src/models/task_model.dart';
import 'package:task_app/src/models/user_model.dart';
import 'package:task_app/src/providers/task_provider.dart';
import 'package:task_app/src/providers/user_provider.dart';
import 'package:task_app/src/utils/utils.dart' as utils;

class TaskDetailsPage extends StatefulWidget {
  const TaskDetailsPage({super.key});

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetailsPage> {
  TaskModel task = TaskModel();
  final UserProvider userProvider = UserProvider();
  final TaskProvider taskProvider = TaskProvider();
  final formKey = GlobalKey<FormState>();
  TextEditingController _DateController = TextEditingController();
  late TaskBloc taskBloc;
  String _title = '';
  String _description = '';
  String _date = '';
  String? _defaultDropdown;
  int? _selectedOption;
  bool _guardando = false;

  bool userOptionsLoaded = false;

  List<DropdownMenuItem<String>> userOptions = [];

  @override
  void initState() {
    super.initState();
    // Fetch user options.
    fetchUserOptions();
  }

  void fetchUserOptions() async {
    List<DropdownMenuItem<String>> options = await getOptionsDropdown();
    setState(() {
      userOptions = options;
      userOptionsLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    taskBloc = Provider.taskBloc(context);
    final dynamic taskData = ModalRoute.of(context)?.settings.arguments;

    //Set task data if arguments is not empty
    //by doing this, we can check if we are
    //adding a task or editing it
    if (taskData is TaskModel) {
      task = taskData;
      _DateController.text = task.fcDueDate.toString();
      _defaultDropdown = task.fkAsignedUser.toString();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Task Page'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        child: Container(
          child: Form(
              key: formKey,
              child: Column(
                children: [
                  SizedBox(height: 20.0),
                  _createTitle(),
                  Divider(
                    height: 20.0,
                  ),
                  _createDescription(),
                  Divider(
                    height: 20.0,
                  ),
                  _createDueDate(),
                  Divider(
                    height: 20.0,
                  ),
                  _createAsignation(),
                  Divider(
                    height: 20.0,
                  ),
                  _createSubmitButton(),
                ],
              )),
        ),
      ),
    );
  }

  Widget _createTitle() {
    return TextFormField(
      initialValue: task.stTitle,
      autovalidateMode: AutovalidateMode.always,
      enabled: !task.bnCompleted,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        icon: Icon(Icons.text_fields_outlined),
        hintText: 'Title',
        helperText: 'Task Title',
      ),
      validator: utils.lengthValidator.validate,
      onChanged: (value) => task.stTitle = value,
    );
  }

  Widget _createDescription() {
    return TextFormField(
      initialValue: task.stDescription,
      autovalidateMode: AutovalidateMode.always,
      enabled: !task.bnCompleted,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        icon: Icon(Icons.text_fields_outlined),
        hintText: 'Description',
        helperText: 'Task Description',
      ),
      validator: utils.lengthValidator.validate,
      onChanged: (value) => task.stDescription = value,
    );
  }

  Widget _createDueDate() {
    return TextFormField(
      enableInteractiveSelection: false,
      enabled: !task.bnCompleted,
      controller: _DateController,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        hintText: 'Due date',
        labelText: 'Date',
        helperText: (task.bnExpired)
            ? 'Task is expired, select a new due date'
            : 'Due date',
        icon: const Icon(Icons.calendar_month_outlined),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        _selectDate(context);
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Select a due date';
        } else {
          return null;
        }
      },
    );
  }

  _selectDate(BuildContext context) async {
    final actualDate = DateTime.now();
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023, actualDate.month, actualDate.day),
        lastDate: DateTime(2026),
        locale: const Locale('es', 'ES'));
    if (picked != null) {
      setState(() {
        _date = picked.toString();
        _DateController.text = _date;
        task.fcDueDate = picked;
      });
    }
  }

  Widget _createAsignation() {
    if (task.bnCompleted) {
      return _createAsignationCompleted();
    } else {
      if (!userOptionsLoaded) {
        // Loading user options, show loading indicator or placeholder.
        return const Center(child: CircularProgressIndicator());
      } else {
        return Row(
          children: [
            const Icon(Icons.person),
            const SizedBox(width: 15.0),
            Expanded(
              child: DropdownButtonFormField(
                value: _defaultDropdown,
                items: userOptions,
                onChanged: (value) {
                  setState(() {
                    _defaultDropdown = value!;
                    task.fkAsignedUser = int.parse(_defaultDropdown!);
                  });
                },
                validator: (value) => value == null ? "Select a user" : null,
              ),
            ),
          ],
        );
      }
    }
  }

  Future<List<DropdownMenuItem<String>>> getOptionsDropdown() async {
    List<UserModel> users = await userProvider.getUsers();
    List<DropdownMenuItem<String>> userOptions = [];

    for (var user in users) {
      userOptions.add(
        DropdownMenuItem(
          child: Text(user.username),
          value: user.id.toString(),
        ),
      );
    }

    return userOptions;
  }

  Widget _createSubmitButton() {
    return ElevatedButton.icon(
        onPressed: (_guardando || task.bnCompleted) ? null : _submit,
        icon: Icon(Icons.save),
        label:
            task.bnCompleted ? Text('Task has been completed') : Text('Save'));
  }

  void _submit() {
    if (!formKey.currentState!.validate()) return;
    formKey.currentState?.save();
    if (task.skTask == null) {
      taskBloc.addTask(task);
    } else {
      taskBloc.editTask(task);
    }
    Navigator.pop(context);
  }

  Widget _createAsignationCompleted() {
    //final UserModel user = userProvider.getUser(task.fkAsignedUser);
    return FutureBuilder(
      future: userProvider.getUser(task.fkAsignedUser),
      builder: (context, AsyncSnapshot<UserModel> snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data;
          return TextFormField(
            initialValue: user!.username,
            //task.fkAsignedUser.toString(),
            autovalidateMode: AutovalidateMode.always,
            enabled: !task.bnCompleted,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              icon: Icon(Icons.text_fields_outlined),
              hintText: 'Asignated user ',
              helperText: 'Asignated user',
            ),
          );
        } else {
          return Row();
        }
      },
    );
  }
}
