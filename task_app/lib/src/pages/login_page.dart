import 'package:flutter/material.dart';
import 'package:task_app/src/blocs/login_bloc.dart';
import 'package:task_app/src/blocs/provider.dart';
import 'package:task_app/src/providers/user_provider.dart';
import 'package:task_app/src/utils/utils.dart' as utils;

class LoginPage extends StatefulWidget {
  bool _loading = false;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final userProvider = UserProvider();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _createBackground(),
          _createForm(),
        ],
      ),
    );
  }

  Widget _createBackground() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
      ),
    );
  }

  Widget _createForm() {
    final loginBloc = Provider.loginBloc(context);
    final size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 35.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8.0)),
        height: size.height * 0.55,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _createTitle(),
              _createUsername(loginBloc),
              _createPassword(loginBloc),
              _createButton(loginBloc),
            ],
          ),
        ),
      ),
    );
  }

  Widget _createTitle() {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      padding: EdgeInsets.all(15.0),
      child: Text(
        'TaskFlow App',
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 26.0, color: Colors.green),
      ),
    );
  }

  Widget _createUsername(LoginBloc loginBloc) {
    return StreamBuilder(
      stream: loginBloc.usernameStream,
      builder: (context, snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            decoration: InputDecoration(
                icon: Icon(
                  Icons.person,
                  color: Colors.green,
                ),
                labelText: 'Username',
                errorText:
                    snapshot.hasError ? snapshot.error.toString() : null),
            onChanged: (value) => loginBloc.changeUsername(value),
          ),
        );
      },
    );
  }

  Widget _createPassword(LoginBloc loginBloc) {
    return StreamBuilder(
      stream: loginBloc.passwordStream,
      builder: (context, snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
                icon: Icon(
                  Icons.lock,
                  color: Colors.green,
                ),
                labelText: 'Password',
                errorText:
                    snapshot.hasError ? snapshot.error.toString() : null),
            onChanged: (value) => loginBloc.changePassword(value),
          ),
        );
      },
    );
  }

  Widget _createButton(LoginBloc loginBloc) {
    return StreamBuilder(
      stream: loginBloc.formValidStream,
      builder: (context, snapshot) {
        return ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0))),
            onPressed: (snapshot.hasData && !widget._loading)
                ? () => _login(loginBloc, context)
                : null,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
              child: Text('Login'),
            ));
      },
    );
  }

  _login(LoginBloc bloc, context) async {
    setState(() {
      widget._loading = true;
    });
    Map<String, dynamic> info =
        await userProvider.login(bloc.email, bloc.password);
    if (info['authenticated']) {
      Navigator.pushReplacementNamed(context, 'task');
      bloc.changePassword('');
      bloc.changeUsername('');
    } else {
      setState(() {
        widget._loading = false;
      });
      utils.showAlert(context, 'Authentication Failed',
          'Username or password are incorrect');
    }
  }
}
