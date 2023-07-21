import 'dart:async';
import 'dart:math';

class Validators {
  final validateUsername = StreamTransformer<String, String>.fromHandlers(
    handleData: (username, sink) {
      if (username.isEmpty) {
        sink.addError('Please enter the username');
      } else {
        sink.add(username);
      }
    },
  );

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: ((password, sink) {
    if (password.isNotEmpty) {
      sink.add(password);
    } else {
      sink.addError('Please enter the password');
    }
  }));
}
