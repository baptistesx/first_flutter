import 'package:cult_connect/components/constants.dart';
import 'package:cult_connect/screens/home/actuator_details_page.dart';
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
  bool state;
  final double value;
  final DateTime startTime;
  final DateTime stopTime;
  bool automaticMode;
  bool stateIsSwitched;
  bool automaticModeIsSwitched;
  Switch stateSwitch;

  Actuator(
      {this.id,
      this.name,
      this.state,
      this.value,
      this.startTime,
      this.stopTime,
      this.automaticMode,
      this.stateIsSwitched,
      this.automaticModeIsSwitched});

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
      stateIsSwitched: json['state'],
      automaticModeIsSwitched: json['automaticMode'],
    );
  }

  Future<String> toggleState(value) async {
    var response = await http.post(SERVER_IP + '/api/user/setActuatorState',
        body: {"actuatorId": id, "value": value.toString()},
        headers: {"Authorization": jwt});
    state = value;
    stateIsSwitched = value;
    return response.body;
  }

  Future<String> toggleAutomaticMode(value) async {
    var response = await http.post(
        SERVER_IP + '/api/user/setActuatorAutomaticMode',
        body: {"actuatorId": id, "value": value.toString()},
        headers: {"Authorization": jwt});
    automaticMode = value;
    automaticModeIsSwitched = value;
    return response.body;
  }

  void pushActuatorDetails(BuildContext context, Switch stateSwitch) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return new ActuatorDetailsPage(this, stateSwitch);
        },
      ),
    );
  }
}
