import 'package:cult_connect/screens/home/components/module.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../home_page.dart';
import 'sensor.dart';
import 'package:cult_connect/services/constants.dart' as Constants;

const SERVER_IP = Constants.SERVER_IP;

Future<String> updateSensor(String id, String newName) async {
  final response = await http.post(SERVER_IP + '/api/user/updateSensor',
      headers: {"Authorization": Constants.jwt}, body: {"id": id, "newName": newName});
  print(response.body);
  if (response.statusCode == 200) return response.body;

  return null;
}

void displayDialog(
        BuildContext context, String title, String text, int nbDialogs) =>
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(text),
                RaisedButton(
                    onPressed: () {
                      for (int i = 0; i < nbDialogs; i++) {
                        Navigator.pop(context);
                      }
                    },
                    child: Text('OK')),
              ]),
            ));

void displaySensorSettingsDialog(BuildContext context, Sensor sensor) {
  final TextEditingController _newNameController = TextEditingController();
  final _updateSensorFormKey = GlobalKey<FormState>();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
        title: Text(sensor.name + " settings"),
        content: Form(
          key: _updateSensorFormKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(sensor.name),
                  ],
                ),
                TextFormField(
                  controller: _newNameController,
                  decoration: const InputDecoration(
                    // icon: Icon(Icons.person),
                    hintText: 'New name',
                    // labelText: 'Email *',
                  ),
                  validator: (String value) {
                    if (value.length < 3) return 'Please, enter a longer name';
                    if (value == sensor.name)
                      return 'The name is the same as previoulsy';
                  },
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                          onPressed: () async {
                            if (_updateSensorFormKey.currentState.validate()) {
                              var newName = _newNameController.text;
                              var response;
                              response = await updateSensor(sensor.id, newName);
                              if (response == "ok") {
                                sensor.name = newName;
                              }

                              displayDialog(context, "Result", response, 2);
                            }
                          },
                          child: Text('Save')),
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
                ),
              ],
            ),
          ),
        )),
  );
}
