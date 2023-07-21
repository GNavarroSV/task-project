import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:task_app/src/blocs/validators.dart';

class LoginBloc with Validators {
  final _usernameController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  //Recuperar datos
  Stream<String> get usernameStream =>
      _usernameController.stream.transform(validateUsername);

  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validatePassword);

  Stream<bool> get formValidStream =>
      Rx.combineLatest2(usernameStream, passwordStream, (u, p) => true);

  // Insertar valores al stream
  Function(String) get changeUsername => _usernameController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  //Obtener ultimo valor de streams
  String get email => _usernameController.value;
  String get password => _passwordController.value;

  dispose() {
    _usernameController.close();
    _passwordController.close();
  }
}
