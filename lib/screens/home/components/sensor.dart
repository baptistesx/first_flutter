import 'package:cult_connect/screens/home/components/data.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // show json, base64, ascii;
import 'package:flutter/foundation.dart';

import '../sensor_details_page.dart';

class Sensor {
  final String id;
  String name;
  final List<SensorData> sensorData;

  Sensor({this.id, this.name, this.sensorData});

  factory Sensor.fromJson(Map<String, dynamic> json) {
    List<SensorData> list = (json['sensorData'] as List)
        .map((sensorData) => SensorData.fromJson(sensorData))
        .toList();

    return Sensor(
        id: json['_id'],
        name: json['name'],
        sensorData: (json['sensorData'] as List)
            .map((sensorData) => SensorData.fromJson(sensorData))
            .toList());
  }

  void pushSensorDetails(BuildContext context, int sensorDataIndex) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return new SensorDetailsPage(this, sensorDataIndex);
        },
      ),
    );
  }
}
