import 'dart:convert'; // show json, base64, ascii;
import 'package:cult_connect/components/drawer.dart';
import 'package:cult_connect/screens/home/components/add_module_dialog.dart';
import 'package:cult_connect/screens/home/components/module.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class SensorDataPage extends StatefulWidget {
  SensorDataPage({Key key}) : super(key: key);

  @override
  _SensorDataPage createState() => _SensorDataPage();
}

class _SensorDataPage extends State<SensorDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Sensor data page'),
        ),
        body: Text("salut"));
  }
}
