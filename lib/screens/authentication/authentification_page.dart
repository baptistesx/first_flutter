import 'package:cult_connect/screens/authentication/components/connection_form.dart';
import 'package:cult_connect/screens/authentication/components/register_form.dart';
import 'package:flutter/material.dart';

class IdentificationPage extends StatefulWidget {
  @override
  _IdentificationPageState createState() => _IdentificationPageState();
}

class _IdentificationPageState extends State<IdentificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('Welcome', style: TextStyle(fontSize: 30)),
        Text('Sign in', style: TextStyle(fontSize: 15)),
        ConnectionForm(),
        RaisedButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Sign up'),
                    content: RegisterForm(),
                  );
                });
          },
          child: Text('Sign up'),
        ),
      ])),
    );
  }
}