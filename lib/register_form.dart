import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show json, base64, ascii;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// const SERVER_IP = 'http://10.0.2.2:8080';
const SERVER_IP = 'http://192.168.1.22:8080';

Future<int> attemptSignUp(String email, String pwd) async {
  print("launch request");
  print(email+ " et "+ pwd);
  var response = await http
      .post(SERVER_IP + '/signup', body: {"email": email, "pwd": pwd});
  print(response.body);
  return response.statusCode;
}

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();

  void displayDialog(BuildContext context, String title, String text) =>
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  @override
  Widget build(BuildContext context) {
    return Form(
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
            onSaved: (String value) {
              // This optional block of code can be used to run
              // code when the user saves the form.
            },
            validator: (String value) {
              return !value.contains('@')
                  ? 'Format de l\'email incorrect'
                  : null;
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: TextFormField(
              controller: _pwdController,
              obscureText: true,
              decoration: const InputDecoration(
                // icon: Icon(Icons.person),
                hintText: 'Password',
                labelText: 'Password *',
              ),
              onSaved: (String value) {
                // This optional block of code can be used to run
                // code when the user saves the form.
              },
              validator: (String value) {
                return value.length < 8
                    ? 'Le mot de passe doit contenir au moins 8 caractères'
                    : null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: TextFormField(
              // controller: pwdController,
              obscureText: true,
              decoration: const InputDecoration(
                // icon: Icon(Icons.person),
                hintText: 'Password confirmation',
                labelText: 'Password confirmation *',
              ),
              onSaved: (String value) {
                // This optional block of code can be used to run
                // code when the user saves the form.
              },
              validator: (String value) {
                return value.length < 8
                    ? 'Le mot de passe doit contenir au moins 8 caractères'
                    : null;
              },
            ),
          ),
          Row(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: () async {
                  var email = _emailController.text;
                  var pwd = _pwdController.text;

                  var res = await attemptSignUp(email, pwd);
                  if (res == 201)
                    displayDialog(context, "Success",
                        "The user was created. Log in now.");
                  else if (res == 409)
                    displayDialog(
                        context,
                        "That username is already registered",
                        "Please try to sign up using another username or log in if you already have an account.");
                  else {
                    displayDialog(
                        context, "Error", "An unknown error occurred.");
                  }

                  Navigator.pop(context);
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
