import 'package:cult_connect/screens/home/components/actuator.dart';
import 'package:cult_connect/screens/home/components/bloc_module.dart';
import 'package:cult_connect/screens/home/components/data.dart';
import 'package:cult_connect/screens/home/components/sensor.dart';

import 'package:flutter/material.dart';
import 'dart:convert'; // show json, base64, ascii;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

// const SERVER_IP = 'http://10.0.2.2:8081';
// const SERVER_IP = 'http://192.168.1.26:8081';
const SERVER_IP = 'http://192.168.0.24:8081';
Object getModules(http.Client client, jwt) async {
  final response = await client
      .get(SERVER_IP + '/api/user/getModules', headers: {"Authorization": jwt});
  print(response.body);
  return (response.body);
}

Future<List<Module>> fetchModules(http.Client client, jwt) async {
  final response = await client
      .get(SERVER_IP + '/api/user/getModules', headers: {"Authorization": jwt});
  print(response.body);
  // Use the compute function to run parseModules in a separate isolate.
  return compute(parseModules, response.body);
}

// A function that converts a response body into a List<Module>.
List<Module> parseModules(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<Module>((json) => Module.fromJson(json)).toList();
}

class Module {
  final String id;
  String name;
  final String place;
  final List<Sensor> sensors;
  final List<Actuator> actuators;

  Module(
      {this.id,
      this.name,
      this.place,
      this.sensors,
      this.actuators}); //, this.capteurs});

  factory Module.fromJson(Map<String, dynamic> json) {
    print("id module : ${json['_id'] }");
    return Module(
      id: json['_id'] as String,
      name: json['name'] as String,
      place: json['place'] as String,
      sensors: (json['sensors'] as List)
          .map((sensor) => Sensor.fromJson(sensor))
          .toList(),
      actuators: (json['actuators'] as List)
          .map((actuator) => Actuator.fromJson(actuator))
          .toList(),
    );
  }

  @override
  String toString() {
    return this.sensors.toString();
  }

  ListView listMeasures() {
    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        Container(
          height: 50,
          color: Colors.amber[600],
          child: const Center(child: Text('Entry A')),
        ),
        Container(
          height: 50,
          color: Colors.amber[500],
          child: const Center(child: Text('Entry B')),
        ),
        Container(
          height: 50,
          color: Colors.amber[100],
          child: const Center(child: Text('Entry C')),
        ),
      ],
    );
  }
}
