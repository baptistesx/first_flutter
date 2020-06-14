import 'dart:async';
import 'package:cult_connect/screens/home/home_page.dart';
import 'dart:convert' show json, base64, ascii;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cult_connect/services/constants.dart' as Constants;

const SERVER_IP = Constants.SERVER_IP;

Future<String> addModule(name, place, publicID, privateID, jwt) async {
  print("launch request");
  final response = await http.post(SERVER_IP + '/api/user/addModule', headers: {
    "Authorization": jwt
  }, body: {
    "name": name,
    "place": place,
    "publicID": publicID,
    "privateID": privateID
  });
  print("privateID=$privateID");
  var res = response.body;
  print("resultat obtenue:$res");
  // Use the compute function to run parseModules in a separate isolate.
  return res;
}

class AddModuleForm extends StatefulWidget {
  final String jwt;
  final Map<String, dynamic> payload;
  AddModuleForm(this.jwt, this.payload, {Key key}) : super(key: key);
  factory AddModuleForm.fromBase64(String jwt) => AddModuleForm(
      jwt,
      json.decode(
          ascii.decode(base64.decode(base64.normalize(jwt.split(".")[1])))));

  @override
  _AddModuleFormState createState() => _AddModuleFormState(jwt, payload);
}

class _AddModuleFormState extends State<AddModuleForm> {
  final String jwt;
  final Map<String, dynamic> payload;
  final _addModuleFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _publicIDController = TextEditingController();
  final TextEditingController _privateIDController = TextEditingController();
  _AddModuleFormState(this.jwt, this.payload, {Key key});

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
        builder: (context) => AlertDialog(
            title: Text(title),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(text),
              RaisedButton(
                  onPressed: () {
                    if (text == "The module has been added with success!") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage.fromBase64(jwt)));
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Text("OK"))
            ])),
      );

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _addModuleFormKey,
        child: Container(
            alignment: Alignment.center,
            child: SingleChildScrollView(
              // new line
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: 'Nickname',
                    labelText: 'Nickname *',
                  ),
                  onSaved: (String value) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                  },
                  validator: (String value) {
                    return value.length == 0
                        ? 'Please, enter a module name'
                        : null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: TextFormField(
                    controller: _placeController,
                    decoration: const InputDecoration(
                      hintText: 'Place',
                      labelText: 'Place *',
                    ),
                    onSaved: (String value) {
                      // This optional block of code can be used to run
                      // code when the user saves the form.
                    },
                    validator: (String value) {
                      return value.length == 0 ? 'Please, enter a place' : null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: TextFormField(
                    controller: _publicIDController,
                    decoration: const InputDecoration(
                      hintText: 'Public ID',
                      labelText: 'Public ID *',
                    ),
                    onSaved: (String value) {
                      // This optional block of code can be used to run
                      // code when the user saves the form.
                    },
                    validator: (String value) {
                      return value.length == 0
                          ? 'Please, enter public ID'
                          : null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: TextFormField(
                    controller: _privateIDController,
                    decoration: const InputDecoration(
                      hintText: 'Private ID',
                      labelText: 'Private ID *',
                    ),
                    onSaved: (String value) {
                      // This optional block of code can be used to run
                      // code when the user saves the form.
                    },
                    validator: (String value) {
                      return value.length == 0
                          ? 'Please, enter private ID'
                          : null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: RaisedButton(
                      onPressed: () async {
                        print("add button clicked");
                        var name = _nameController.text;
                        var place = _placeController.text;
                        var publicID = _publicIDController.text;
                        var privateID = _privateIDController.text;
                        addModule(name, place, publicID, privateID, jwt)
                            .then((res) {
                          displayDialog(context, "Result", res);
                          print(res);
                        });
                      },
                      child: Text('Add')),
                ),
              ]),
            )));
  }
}
