import 'dart:async';
import 'package:cult_connect/main.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show json, base64, ascii;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// const SERVER_IP = 'http://10.0.2.2:8080';
const SERVER_IP = 'http://192.168.1.22:8080';

final storage = FlutterSecureStorage();

Future<String> fetchConnectionIdentifiers(String email, String pwd) async {
  print("launch request");
  final response =
      await http.post(SERVER_IP + '/login', body: {"email": email, "pwd": pwd});
  print(response.body);
  if (response.statusCode == 200) return response.body;
  return null;
}

// Future<ConnectionIdentifiers> fetchConnectionIdentifiers(
//     String email, String pwd) async {
//   final response =
//       await http.get(SERVER_IP + '/?email=' + email + '&pwd=' + pwd);

//   if (response.statusCode == 200)
//     return ConnectionIdentifiers.fromJson(json.decode(response.body));
//   else
//     throw Exception('Failed to load ConnectionIdentifiers');
// }

// class ConnectionIdentifiers {
//   final String email;
//   final String pwd;

//   ConnectionIdentifiers({this.email, this.pwd});

//   factory ConnectionIdentifiers.fromJson(Map<String, dynamic> json) {
//     return ConnectionIdentifiers(
//       email: json['email'],
//       pwd: json['pwd'],
//     );
//   }
// }

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
              padding: const EdgeInsets.all(20.0),
              child: RaisedButton(
                  onPressed: () async {
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
                              builder: (context) => HomePage.fromBase64(jwt)));
                    } else {
                      displayDialog(context, "An Error Occurred",
                          "No account was found matching that username and password");
                    }
                  },
                  // onPressed: () {
                  //   if (_connectionFormKey.currentState.validate()) {
                  //     this.futureConnectionIdentifiers =
                  //         fetchConnectionIdentifiers(
                  //             _emailController.text, _pwdController.text);
                  //     _showLoaderFunction();
                  //   }
                  //   // Navigator.pushNamed(context, '/home');
                  // },
                  child: Text('Connexion')),
            ),
            // _showLoader
            //     ? Center(
            //         child: FutureBuilder<String>(
            //           future: futureConnectionIdentifiers,
            //           builder: (context, snapshot) {
            //             if (snapshot.hasData) {
            //               return Text('email:' +
            //                       // snapshot.data.email +
            //                       ' et pwd: '
            //                   // + snapshot.data.pwd
            //                   );
            //             } else if (snapshot.hasError) {
            //               return Text("${snapshot.error}");
            //             }
            //             // By default, show a loading spinner.
            //             return CircularProgressIndicator();
            //           },
            //         ),
            //       )
            //     : new Container(),
          ]),
        ));
  }
}
