import 'package:cult_connect/components/constants.dart';
import 'package:cult_connect/screens/home/components/module.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'sensor.dart';

Future<String> updateName(String id, String newName, bool isSensor) async {
  print(isSensor);
  final response = await http.post(SERVER_IP + '/api/user/updateModuleSensorName',
      headers: {"Authorization": jwt},
      body: {"id": id, "newName": newName, "isSensor": isSensor.toString()});
  print(response.body);
  if (response.statusCode == 200) return response.body;

  return null;
}

void displayDialog(BuildContext context, String title, String text) =>
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text(title),
            content: Center(
              child: Column(children: [
                Text(text),
                RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text('OK')),
              ]),
            )));
void displayUpdateNameDialog(
    BuildContext context, String title, Module module, Sensor sensor) {
  bool isSensor;
  if (sensor == null)
    isSensor = false;
  else
    isSensor = true;
  final TextEditingController _newNameController = TextEditingController();
  final _updateNameFormKey = GlobalKey<FormState>();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
        title: Text(title),
        content: Form(
          key: _updateNameFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _newNameController,
                decoration: const InputDecoration(
                  // icon: Icon(Icons.person),
                  hintText: 'New name',
                  // labelText: 'Email *',
                ),
                validator: (String value) {
                  if (value.length < 3) return 'Please, enter a longer name';
                  if (isSensor) {
                    if (value == sensor.name)
                      return 'The name is the same as previoulsy';
                  }
                  else if (value == module.name) return null;
                },
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                        onPressed: () async {
                          if (_updateNameFormKey.currentState.validate()) {
                            var newName = _newNameController.text;
                            var response;
                            if (isSensor) {
                              response = await updateName(
                                  sensor.id, newName, isSensor);
                              if (response == "ok") {
                                sensor.name = newName;
                              }
                            } else {
                              response = await updateName(
                                  module.id, newName, isSensor);
                              if (response == "ok") {
                                module.name = newName;
                              }
                            }
                            displayDialog(context, "Result", response);
                          }
                        },
                        child: Text('Enter')),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel')),
                  ),
                ],
              )
            ],
          ),
        )),
  );
}
