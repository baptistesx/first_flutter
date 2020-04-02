import 'package:cult_connect/screens/home/components/add_module_form.dart';
import 'package:cult_connect/screens/home/components/module.dart';
import 'dart:convert'; // show json, base64, ascii;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class HomePage extends StatefulWidget {
  final String jwt;
  final Map<String, dynamic> payload;

  HomePage(this.jwt, this.payload, {Key key}) : super(key: key);
  factory HomePage.fromBase64(String jwt) => HomePage(
      jwt,
      json.decode(
          ascii.decode(base64.decode(base64.normalize(jwt.split(".")[1])))));
  @override
  _HomePageState createState() => _HomePageState(jwt, payload);
}

class _HomePageState extends State<HomePage> {
  String jwt;
  final Map<String, dynamic> payload;
  _HomePageState(this.jwt, this.payload, {Key key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Accueil'),
        ),
        body: Column(children: [
          RaisedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Column(mainAxisSize: MainAxisSize.min, children: [
                        Text('Ajout d\'un module'),
                        Text('Les id se trouvent sur le boitier',
                            style: TextStyle(
                              fontSize: 15,
                            )),
                      ]),
                      content: AddModuleForm(jwt, payload),
                    );
                  });
            },
            child: Text('Ajouter un module'),
          ),
          Expanded(
            child: FutureBuilder<List<Module>>(
              future: fetchModules(http.Client(), jwt),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);

                return snapshot.hasData
                    ? ModulesList(modules: snapshot.data)
                    : Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ]),

        //   Text('Liste des modules:'),
        //   // FutureBuilder<List<Module>>(
        //   //   future: fetchModule(http.Client(), jwt),
        //   //   builder: (context, snapshot) {
        //   //     if (snapshot.hasError) print(snapshot.error);

        //   //     return snapshot.hasData
        //   //         ? ModulesList(modules: snapshot.data)
        //   //         : Center(child: CircularProgressIndicator());
        //   //   },
        //   //   // BlocModule(name: "MonCapteur1", lastValue: 30, unit: "°C"),
        //   //   // BlocModule(name: "MonCapteur2", lastValue: 0, unit: "°C"),
        //   // )
        // ]),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Center(
                  child: Text('Menu'),
                ),
                decoration: BoxDecoration(
                  color: Colors.yellow,
                ),
              ),
              ListTile(
                title: Text('Accueil'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Configuration'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  // Navigator.pop(context);
                  Navigator.pushNamed(context, '/config');
                },
              ),
              ListTile(
                title: Text('Evolution'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  // Navigator.pop(context);
                  Navigator.pushNamed(context, '/evol');
                },
              ),
              ListTile(
                title: Text('Carte SD'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  // Navigator.pop(context);
                  Navigator.pushNamed(context, '/sd');
                },
              ),
            ],
          ),
        ));
  }
}