import 'package:flutter/material.dart';
import 'package:task_app/src/models/task_model.dart';
import 'package:task_app/src/providers/user_provider.dart';

final userProvider = UserProvider();

class lengthValidator {
  static String? validate(String? value) {
    return value == null || value.isEmpty ? "This field can't be empty" : null;
  }
}

void showAlert(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Accept'))
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


// void sessionExpired(BuildContext context) {
//   userProvider.logout();
//   Navigator.popAndPushNamed(context, 'login');
// }
