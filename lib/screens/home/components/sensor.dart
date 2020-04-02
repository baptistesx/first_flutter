import 'package:flutter/material.dart';
import 'dart:convert'; // show json, base64, ascii;
import 'package:flutter/foundation.dart';

class Sensor {
  final String name;
  final String type;
  final String unit;

  Sensor({this.name, this.type, this.unit});

  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
      name: json['name'],
      type: json['type'],
      unit: json['unit'],
    );
  }
}