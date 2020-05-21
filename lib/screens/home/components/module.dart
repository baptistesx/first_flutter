import 'package:cult_connect/screens/home/components/bloc_module.dart';
import 'package:cult_connect/screens/home/components/data.dart';
import 'package:cult_connect/screens/home/components/sensor.dart';

import 'package:flutter/material.dart';
import 'dart:convert'; // show json, base64, ascii;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

// const SERVER_IP = 'http://10.0.2.2:8081';
const SERVER_IP = 'http://192.168.1.26:8081';

Object getModules(http.Client client, jwt) async {
  final response = await client
      .get(SERVER_IP + '/api/user/modules', headers: {"Authorization": jwt});
  print(response.body);
  return (response.body);
}

Future<List<Module>> fetchModules(http.Client client, jwt) async {
  final response = await client
      .get(SERVER_IP + '/api/user/modules', headers: {"Authorization": jwt});
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

class ModulesList extends StatelessWidget {
  final List<Module> modules;

  ModulesList({Key key, this.modules}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (modules.length == 0) {
      print("pas de module");
      return Center(child: Text("Add your first module !", style: TextStyle(fontSize: 25),));
    } else {
      return new ListView.builder(
          itemCount: modules.length,
          itemBuilder: (context, index) {
            return new ExpansionTile(
              title: new Text(modules[index].name),
              children: <Widget>[
                new Column(
                  children: _buildExpandableContent(modules[index], context),
                )
              ],
            );
          });
      // GridView.builder(
      //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //     crossAxisCount: 2,
      //   ),
      //   itemCount: modules.length,
      //   itemBuilder: (context, index) {
      //     return BlocModule(
      //         module: modules[index]); //Image.network(modules[index].name);
      //   },
      // );
    }
  }

  _buildExpandableContent(Module module, BuildContext context) {
    List<Widget> columnContent = [];

    for (Sensor content in module.sensors) {
      int i = 0;
      for (SensorData sensorDat in content.sensorData) {
        print("iii=" + i.toString());
        columnContent.add(
          new ListTile(
              title: new Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      content.name + " (" + sensorDat.dataType + ")",
                      style: new TextStyle(
                          fontSize: 18.0, color: Colors.lightBlue),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 15,
                    ),
                  ],
                ),
                Text(DateFormat('MMMM d, kk:mm').format(sensorDat.data.values[0].date).toString() +
                    ": " +
                    sensorDat.data.values[0].value.toString() +
                    sensorDat.unit)
              ]),
              onTap: () {
                // print("iii vaut:"+i.toString());
                content.pushSensorDetails(context, content.sensorData.indexOf(sensorDat));
              }),
        );
        i++;
      }
    }
    return columnContent;
  }
}
