import 'package:cult_connect/screens/home/components/bloc_module.dart';
import 'package:cult_connect/screens/home/components/sensor.dart';

import 'package:flutter/material.dart';
import 'dart:convert'; // show json, base64, ascii;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

const SERVER_IP = 'http://10.0.2.2:8081';

Future<List<Module>> fetchModules(http.Client client, jwt) async {
  final response = await client.get(SERVER_IP + '/api/user/modules', headers: {
    "Authorization": jwt
  }); //https://jsonplaceholder.typicode.com/modules');
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
  final String name;
  final String place;
  final List<Sensor> sensors;

  Module({this.name, this.place, this.sensors}); //, this.capteurs});

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
        name: json['name'] as String,
        place: json['place'] as String,
        sensors: (json['sensors'] as List)
            .map((sensor) => Sensor.fromJson(sensor))
            .toList());
  }

  @override
  String toString() {
    return this.sensors.toString();
  }
}

class ModulesList extends StatelessWidget {
  final List<Module> modules;

  ModulesList({Key key, this.modules}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (modules.length == 0) {
      print("pas de module");
      return Center(child: Text("Ajoutez votre premier module !"));
    } else {
      return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemCount: modules.length,
        itemBuilder: (context, index) {
          return BlocModule(
              module: modules[index]); //Image.network(modules[index].name);
        },
      );
    }
  }
}
