import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// const SERVER_IP = 'http://10.0.2.2:8081';
// const SERVER_IP = 'http://192.168.1.26:8081';
const SERVER_IP = 'http://192.168.0.24:8081';
Future<int> attemptSignUp(String email, String pwd) async {
  var response = await http
      .post(SERVER_IP + '/signup', body: {"email": email, "pwd": pwd});
  return response.statusCode;
}

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _signupFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _pwdConfirmController = TextEditingController();

  void displayDialog(
          BuildContext context, String title, String text, bool res) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(text),
            RaisedButton(
                onPressed: () {
                  if (res) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  } else
                    Navigator.pop(context);
                },
                child: Text("OK"))
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _signupFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              icon: Icon(Icons.person),
              hintText: 'Your email',
              labelText: 'Email *',
            ),
            validator: (String value) {
              if (value.contains("..") ||
                  !value.contains('@') ||
                  !value.contains('.') ||
                  value.contains(".@")) return 'Bad email format';
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: TextFormField(
              controller: _pwdController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Password',
                labelText: 'Password *',
              ),
              validator: (String value) {
                return value.length < 8
                    ? 'Password must contain at least 8 characters'
                    : null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: TextFormField(
              controller: _pwdConfirmController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Password confirmation',
                labelText: 'Password confirmation *',
              ),
              validator: (String value) {
                return _pwdController.text != _pwdConfirmController.text
                    ? 'Different from the password'
                    : null;
              },
            ),
          ),
          Row(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: () async {
                  print(_pwdController.text);
                  print(_pwdConfirmController.text);
                  if (_signupFormKey.currentState.validate()) {
                    var email = _emailController.text;
                    var pwd = _pwdController.text;
                    var res = await attemptSignUp(email, pwd);
                    if (res == 201) {
                      displayDialog(context, "Success",
                          "The user was created. Log in now.", true);
                    } else if (res == 409) {
                      displayDialog(
                          context,
                          "That username is already registered",
                          "Please try to sign up using another username or log in if you already have an account.",
                          false);
                    } else {
                      displayDialog(context, "Error",
                          "An unknown error occurred.", false);
                    }
                  }
                },
                child: Text('Valider'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Annuler'),
              ),
            ),
          ])
        ],
      ),
    );
  }
}
