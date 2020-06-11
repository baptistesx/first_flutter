import 'package:cult_connect/components/constants.dart';
import 'package:cult_connect/screens/home/components/actuator.dart';
import 'package:cult_connect/screens/home/components/data.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // show json, base64, ascii;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../sensor_details_page.dart';

// const SERVER_IP = 'http://192.168.0.24:8081';
const SERVER_IP = 'http://192.168.1.118:8081';

class Sensor {
  final String id;
  String name;
  final String dataType;
  final String unit;
  double acceptableMin;
  double acceptableMax;
  double criticalMin;
  double criticalMax;
  double nominalValue;
  double temp_acceptableMin;
  double temp_acceptableMax;
  double temp_criticalMin;
  double temp_criticalMax;
  double temp_nominalValue;
  final double limitMin;
  final double limitMax;
  bool automaticMode;
  final Data data;
  final List<Actuator> actuators;

  Sensor(
      {this.id,
      this.name,
      this.dataType,
      this.unit,
      this.acceptableMin,
      this.acceptableMax,
      this.criticalMin,
      this.criticalMax,
      this.nominalValue,
      this.limitMin,
      this.limitMax,
      this.data,
      this.automaticMode,
      this.actuators,
      this.temp_acceptableMin,
      this.temp_acceptableMax,
      this.temp_criticalMin,
      this.temp_criticalMax,
      this.temp_nominalValue});

  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
        id: json['_id'],
        name: json['name'],
        dataType: json['dataType'],
        unit: json['unit'],
        acceptableMin: json['acceptableMin'].toDouble(),
        acceptableMax: json['acceptableMax'].toDouble(),
        criticalMin: json['criticalMin'].toDouble(),
        criticalMax: json['criticalMax'].toDouble(),
        nominalValue: json['nominalValue'].toDouble(),
        temp_acceptableMin: json['acceptableMin'].toDouble(),
        temp_acceptableMax: json['acceptableMax'].toDouble(),
        temp_criticalMin: json['criticalMin'].toDouble(),
        temp_criticalMax: json['criticalMax'].toDouble(),
        temp_nominalValue: json['nominalValue'].toDouble(),
        limitMin: json['limitMin'].toDouble(),
        limitMax: json['limitMax'].toDouble(),
        data: Data.fromJson(json['data']),
        automaticMode: json['automaticMode'],
        actuators: (json['actuators'] as List)
          .map((actuator) => Actuator.fromJson(actuator))
          .toList());
  }

  Future<String> updateSensorDataAutomaticMode(
      sensorId, index, newValue) async {
    var response = await http
        .post(SERVER_IP + '/api/user/updateSensorAutomaticMode', body: {
      "sensorId": sensorId,
      "sensorDataIndex": index.toString(),
      "newValue": newValue.toString()
    }, headers: {
      "Authorization": jwt
    });
    automaticMode = newValue;
    // automaticModeIsSwitched = value;
    return response.body;
  }

  void pushSensorDetails(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return new SensorDetailsPage(this);
        },
      ),
    );
  }
}
