import 'dart:async';
import 'package:cult_connect/screens/add_first_module_page.dart';
import 'package:cult_connect/screens/home/home_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// const SERVER_IP = 'http://10.0.2.2:8081';
const SERVER_IP = 'http://192.168.1.26:8081';
final storage = FlutterSecureStorage();

Future<String> fetchConnectionIdentifiers(String email, String pwd) async {
  final response =
      await http.post(SERVER_IP + '/login', body: {"email": email, "pwd": pwd});
  print(response.body);
  if (response.statusCode == 200) return response.body;

  return null;
}

class ConnectionForm extends StatefulWidget {
  @override
  _ConnectionFormState createState() => _ConnectionFormState();
}

class _ConnectionFormState extends State<ConnectionForm> {
  final String email = "";
  final String pwd = "";
  final _connectionFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  bool _showLoader = false;
  Future<String> futureConnectionIdentifiers;

  void _showLoaderFunction() {
    setState(() {
      _showLoader = true;
    });
  }

  void displayDialog(BuildContext context, String title, String text) =>
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _connectionFormKey,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 45.0, right: 45.0, bottom: 10.0, top: 20.0),
          child: Column(children: [
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
              padding: const EdgeInsets.all(20.0),
              child: RaisedButton(
                  onPressed: () async {
                    if (_connectionFormKey.currentState.validate()) {
                      print("connexion button clicked");
                      var email = _emailController.text;
                      var pwd = _pwdController.text;
                      var jwt = await fetchConnectionIdentifiers(email, pwd);
                      print(jwt);
                      if (jwt != null) {
                        storage.write(key: "jwt", value: jwt);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                // AddFirstModulePage.test(jwt)));
                                    HomePage.fromBase64(jwt)));
                      } else {
                        displayDialog(context, "An Error Occurred",
                            "No account was found matching that username and password");
                      }
                    }
                  },
                  child: Text('Enter')),
            ),
          ]),
        ));
  }
}
