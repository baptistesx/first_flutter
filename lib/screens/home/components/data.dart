import 'package:flutter/material.dart';
import 'dart:convert'; // show json, base64, ascii;
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:cult_connect/services/constants.dart' as Constants;

const SERVER_IP = Constants.SERVER_IP;

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
        date: todayDate, //DateFormat('MMMM d, kk:mm').format(todayDate),
        value: json['value']);
  }
}
