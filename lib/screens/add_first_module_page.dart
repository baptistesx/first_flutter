import 'dart:convert'; // show json, base64, ascii;
import 'package:cult_connect/components/drawer.dart';
import 'package:cult_connect/screens/home/components/add_module_dialog.dart';
import 'package:cult_connect/screens/home/components/module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AddFirstModulePage extends StatefulWidget {
  final String jwt;
  final Map<String, dynamic> payload;

  AddFirstModulePage(this.jwt, this.payload, {Key key}) : super(key: key);

factory AddFirstModulePage.test(String jwt){
  print('okoko');
  return AddFirstModulePage(
      jwt,
      json.decode(
          ascii.decode(base64.decode(base64.normalize(jwt.split(".")[1])))));
}

  factory AddFirstModulePage.fromBase64(String jwt) => AddFirstModulePage(
      jwt,
      json.decode(
          ascii.decode(base64.decode(base64.normalize(jwt.split(".")[1])))));
  @override
  _AddFirstModulePageState createState() =>
      _AddFirstModulePageState(jwt, payload);
}

class _AddFirstModulePageState extends State<AddFirstModulePage> {
  String jwt;
  final Map<String, dynamic> payload;
  _AddFirstModulePageState(this.jwt, this.payload, {Key key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: 
        // Column(children: [
      Container(
        color: Colors.red,
      ),
      // Expanded(
      //   child: FutureBuilder<List<Module>>(
      //     future: fetchModules(http.Client(), jwt),
      //     builder: (context, snapshot) {
      //       if (snapshot.hasError) print(snapshot.error);

      //       return snapshot.hasData
      //           ? ModulesList(modules: snapshot.data)
      //           : Center(child: CircularProgressIndicator());
      //     },
      //   ),
      // ),
    // ]
    );
  }
}
