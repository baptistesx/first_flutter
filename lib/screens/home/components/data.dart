import 'package:flutter/material.dart';
import 'dart:convert'; // show json, base64, ascii;
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class SensorData {
  final String dataType;
  final String unit;
  final Data data;

  SensorData({this.dataType, this.unit, this.data}); //, this.values});

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
        dataType: json['dataType'],
        unit: json['unit'],
        data: Data.fromJson(json['data']));
  }
}

class Data {
  final List<Value> values;

  Data({this.values});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
        values: (json['values'] as List)
            .map((value) => Value.fromJson(value))
            .toList());
  }
}

class Value {
  final DateTime date;
  final int value;

  Value({this.date, this.value});

  factory Value.fromJson(Map<String, dynamic> json) {
    DateTime todayDate = DateTime.parse(json['date']);
    return Value(
        date: todayDate,//DateFormat('MMMM d, kk:mm').format(todayDate),
        value: json['value']);
  }
}
