import 'package:cult_connect/components/constants.dart';
import 'package:cult_connect/screens/home/components/data.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // show json, base64, ascii;
import 'package:flutter/foundation.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

const SERVER_IP = 'http://192.168.0.24:8081';

class Actuator {
  final String id;
  final String name;
  final bool state;
  final double value;
  final DateTime startTime;
  final DateTime stopTime;
  final bool automaticMode;
  bool isSwitched;

  Actuator(
      {this.id,
      this.name,
      this.state,
      this.value,
      this.startTime,
      this.stopTime,
      this.automaticMode,
      this.isSwitched});

  factory Actuator.fromJson(Map<String, dynamic> json) {
    print(json['startTime']);
    print(json['stopTime']);
    DateTime startTime = DateTime.parse(json['startTime']);
    DateTime stopTime = DateTime.parse(json['stopTime']);
    return Actuator(
      id: json['_id'],
      name: json['name'],
      state: json['state'],
      value: json['value'],
      startTime: startTime,
      stopTime: stopTime,
      automaticMode: json['automaticMode'],
      isSwitched: json['state'],
    );
  }

  Future<String> toggleOnServer(value) async {
    var response = await http.post(SERVER_IP + '/api/user/setActuator',
        body: {"actuatorId": id, "value": value.toString()},
        headers: {"Authorization": jwt});
    return response.body;
  }

  void pushActuatorDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
              // Add 6 lines from here...
              appBar: AppBar(
                title: Text(name),
              ),
              body: Column(children: [
                Flexible(
                  child: ListView(children: [

                  ]),
                ),
              ]));
        },
      ),
    );
  }
}
