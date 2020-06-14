import 'package:cult_connect/screens/home/components/module.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// import '../home_page.dart';
import 'package:cult_connect/services/constants.dart' as Constants;

Future<String> updateModule(String id, String newName, String newPlace) async {
  final response = await http.post(SERVER_IP + '/api/user/updateModule',
      headers: {"Authorization": Constants.jwt},
      body: {"id": id, "newName": newName, "newPlace": newPlace});
  print(response.body);
  if (response.statusCode == 200) return response.body;

  return null;
}

Future<String> removeModule(String id) async {
  final response = await http.post(SERVER_IP + '/api/user/removeModule',
      headers: {"Authorization": Constants.jwt}, body: {"id": id});
  print(response.body);
  if (response.statusCode == 200) return response.body;

  return response.body;
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

void displayRemoveConfirmationDialog(BuildContext context, Module module) =>
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Remove confirmation"),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                Text("Do you really want to remove this module?"),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                          color: Colors.green,
                          onPressed: () async {
                            var res = await removeModule(module.id);
                            print("res= " + res.toString());
                            if (res == "ok") {
                              displayDialog(
                                  context, "Infos", "Module well removed!", 3);
                            }
                          },
                          child: Text(
                            'Yes!',
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                          color: Colors.red,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ],
                )
              ]),
            ));

void displayModuleSettingsDialog(BuildContext context, Module module) {
  final TextEditingController _newNameController = TextEditingController();
  final TextEditingController _newPlaceController = TextEditingController();
  final _updateModuleFormKey = GlobalKey<FormState>();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
        title: Text(module.name + " settings"),
        content: Form(
          key: _updateModuleFormKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(module.name),
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
                    if (value == module.name)
                      return 'The name is the same as previoulsy';
                  },
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(module.place),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _newPlaceController,
                  decoration: const InputDecoration(
                    // icon: Icon(Icons.person),
                    hintText: 'New place',
                    // labelText: 'Email *',
                  ),
                  validator: (String value) {
                    if (value.length < 3) return 'Please, enter a longer place';
                    if (value == module.place)
                      return 'The name is the same as previoulsy';
                  },
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                          onPressed: () async {
                            if (_updateModuleFormKey.currentState.validate()) {
                              var newName = _newNameController.text;
                              var newPlace = _newPlaceController.text;
                              var response;
                              response = await updateModule(
                                  module.id, newName, newPlace);
                              if (response == "ok") {
                                module.name = newName;
                                module.place = newPlace;
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
                RaisedButton(
                    color: Colors.red,
                    onPressed: () {
                      displayRemoveConfirmationDialog(context, module);
                    },
                    child: Text(
                      'Remove this module',
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            ),
          ),
        )),
  );
}
