import 'package:flutter/material.dart';
import 'package:task_app/src/blocs/login_bloc.dart';
import 'package:task_app/src/blocs/task_bloc.dart';

class Provider extends InheritedWidget {
  final _taskBloc = TaskBloc();
  final _loginBloc = LoginBloc();

  static Provider? _instancia;

  factory Provider({Key? key, Widget? child}) {
    if (_instancia == null) {
      _instancia = Provider._internal(
        key: key,
        child: child!,
      );
    }
    return _instancia!;
  }

  Provider._internal({Key? key, required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static TaskBloc taskBloc(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<Provider>() as Provider)
        ._taskBloc;
  }

  static LoginBloc loginBloc(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<Provider>() as Provider)
        ._loginBloc;
  }
}
