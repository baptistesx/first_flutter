import 'package:cult_connect/screens/home/components/actuator.dart';
import 'package:cult_connect/screens/home/components/data.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // show json, base64, ascii;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../sensor_details_page.dart';
import 'package:cult_connect/services/constants.dart' as Constants;

const SERVER_IP = Constants.SERVER_IP;

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

  Future<String> updateSensorDataAutomaticMode(sensorId, newValue) async {
    var response = await http.post(
        SERVER_IP + '/api/user/updateSensorAutomaticMode',
        body: {"sensorId": sensorId, "newValue": newValue.toString()},
        headers: {"Authorization": Constants.jwt});
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

  listSensorActuators() {
    bool isSwitched = false;
    List<Widget> columnContent = [];
    for (Actuator actuator in this.actuators) {
      // var callback;
      // if(sensor.sensorData[sensorDataIndex]) = (bool s) => print(s);
      // callback= null;
      Switch stateSwitch = new Switch(
        value: actuator.state,
        onChanged: (value) {
          // setState(() {
          //   isSwitched = value;
          //   print(isSwitched);
          // });
        },
        // onChanged: (value) async {
        //   var res = await actuator.updateActuatorStateById(actuator.id, value);
        //   print(res);
        //   setState(() {
        //     print("before : ${actuator.state}");
        //     actuator.state = value;
        //     print("after : ${actuator.state}");
        //   });
        //   // actuator.state = res as bool;
        // },
        activeTrackColor: Colors.lightGreenAccent,
        activeColor: Colors.green,
      );
      columnContent.add(
        new ListTile(
            title: new Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    actuator.name,
                    style: new TextStyle(
                        fontSize: 18.0, color: Colors.orangeAccent),
                  ),
                  stateSwitch,
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 15,
                  ),
                ],
              ),
            ]),
            onTap: () {
              print("ok");
              // actuator.pushActuatorDetails(context, stateSwitch);
            }),
      );
    }
    return columnContent;
  }
}
