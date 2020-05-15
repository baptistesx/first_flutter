import 'dart:convert'; // show json, base64, ascii;
import 'package:cult_connect/components/drawer.dart';
import 'package:cult_connect/screens/home/components/add_module_dialog.dart';
import 'package:cult_connect/screens/home/components/module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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
          title: Text('Homepage'),
        ),
        body: Column(children: [
          RaisedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AddModuleDialog(jwt, payload);
                  });
            },
            child: Text('Add a module'),
          ),
          Text("Sensors values displayed are the most recent."),
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
        drawer: MyDrawer());
  }
}
