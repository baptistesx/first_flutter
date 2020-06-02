import 'dart:async';
import 'package:cult_connect/components/constants.dart';
import 'package:cult_connect/screens/add_first_module_page.dart';
import 'package:cult_connect/screens/configuration/components/config_sliders_widgets.dart';
import 'package:cult_connect/screens/home/components/sensor.dart';
import 'package:cult_connect/screens/home/home_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'data.dart';

// const SERVER_IP = 'http://10.0.2.2:8081';
// const SERVER_IP = 'http://192.168.1.26:8081';
// const SERVER_IP = 'http://192.168.0.24:8081';
const SERVER_IP = 'http://192.168.0.24:8081';

final storage = FlutterSecureStorage();

class SensorConfigForm extends StatefulWidget {
  Sensor sensor;
  int sensorDataIndex;
  SensorConfigForm(this.sensor, this.sensorDataIndex);

  @override
  _SensorConfigForm createState() => _SensorConfigForm(sensor, sensorDataIndex);
}

class _SensorConfigForm extends State<SensorConfigForm> {
  final _connectionFormKey = GlobalKey<FormState>();
  Future<String> futureConnectionIdentifiers;
  Sensor sensor;
  int sensorDataIndex;

  _SensorConfigForm(this.sensor, this.sensorDataIndex);

  void displayDialog(BuildContext context, String title, String text) =>
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(text),
              ],
            )),
      );

  Future<String> updateSensorDataConfig(
      Sensor sensor, int sensorDataIndex) async {
    SensorData sensorDataI = sensor.sensorData[sensorDataIndex];
    final response = await http
        .post(SERVER_IP + '/api/user/updateSensorDataConfig', headers: {
      "Authorization": jwt
    }, body: {
      "sensorId": sensor.id,
      "sensorDataIndex": sensorDataIndex.toString(),
      "newNominalValue": sensorDataI.temp_nominalValue.toString(),
      "newAcceptableMin": sensorDataI.temp_acceptableMin.toString(),
      "newAcceptableMax": sensorDataI.temp_acceptableMax.toString(),
      "newCriticalMin": sensorDataI.temp_criticalMin.toString(),
      "newCritiacalMax": sensorDataI.temp_criticalMax.toString(),
    });
    print(response.body);
    if (response.statusCode == 200) return response.body;

    return null;
  }

  void resetSlidersValues() {
    print("reset sliders!");
    sensor.sensorData[sensorDataIndex].temp_nominalValue =
        sensor.sensorData[sensorDataIndex].nominalValue;

    sensor.sensorData[sensorDataIndex].temp_acceptableMin =
        sensor.sensorData[sensorDataIndex].acceptableMin;

    sensor.sensorData[sensorDataIndex].temp_acceptableMax =
        sensor.sensorData[sensorDataIndex].acceptableMax;

    sensor.sensorData[sensorDataIndex].temp_criticalMin =
        sensor.sensorData[sensorDataIndex].criticalMin;

    sensor.sensorData[sensorDataIndex].temp_criticalMax =
        sensor.sensorData[sensorDataIndex].criticalMax;
  }

  @override
  Widget build(BuildContext context) {
    print("bbb:" + sensor.sensorData[sensorDataIndex].criticalMin.toString());
    var sensorDataI = sensor.sensorData[sensorDataIndex];
    var limitMin = sensorDataI.limitMin;
    var limitMax = sensorDataI.limitMax;
    // var acceptableMin = sensorDataI.acceptableMin;
    // var acceptableMax = sensorDataI.acceptableMax;
    // var okRangeValues = RangeValues(sensorDataI.acceptableMin, sensorDataI.acceptableMax);

    return Form(
      key: _connectionFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 11.0),
                child: Column(
                  children: <Widget>[
                    Text('Remarque:',
                        style: TextStyle(decoration: TextDecoration.underline)),
                    Text(
                        'les actionneurs seront actifs seulement lorsque la température ne sera pas "acceptable".'),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 11.0),
                child: Column(
                  children: <Widget>[
                    Text('Attention:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                        'la température nominale doit être comprise entre les bornes de température acceptable. '),
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Column(
                children: [
                  Text('Température nominale (°C)'),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.wb_sunny),
                    Slider(
                      label:
                          "${sensorDataI.temp_nominalValue.toStringAsFixed(1)}",
                      min: limitMin,
                      max: limitMax,
                      divisions: ((limitMax - limitMin) * 2).round(),
                      value: sensorDataI.temp_nominalValue,
                      activeColor: Color(0xff512ea8),
                      inactiveColor: Color(0xffac9bcc),
                      onChanged: (newValue) {
                        print("cccc:${sensorDataI.temp_nominalValue}");
                        setState(() {
                          sensorDataI.temp_nominalValue = newValue;
                        });
                      },
                    ),
                    // TemperatureNominaleSlider(
                    //     sensor.sensorData[sensorDataIndex].nominalValue)
                  ]),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Température acceptable (°C)'),
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.wb_sunny),
                    RangeSlider(
                      labels: RangeLabels(
                          '${sensorDataI.temp_acceptableMin.toStringAsFixed(1)}',
                          '${sensorDataI.temp_acceptableMax.toStringAsFixed(1)}'),
                      values: RangeValues(sensorDataI.temp_acceptableMin,
                          sensorDataI.temp_acceptableMax),
                      min: limitMin,
                      max: limitMax,
                      divisions: ((limitMax - limitMin) * 2).round(),
                      activeColor: Color(0xff512ea8),
                      inactiveColor: Color(0xffac9bcc),
                      onChanged: (newValues) {
                        setState(() {
                          sensorDataI.temp_acceptableMin = newValues.start;
                          sensorDataI.temp_acceptableMax = newValues.end;
                        });
                      },
                    ),
                    // TemperatureOKSlider(
                    //     sensor.sensorData[sensorDataIndex].acceptableMin,
                    //     sensor.sensorData[sensorDataIndex].acceptableMax)
                  ]),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Min (°C, alerte)'),
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.wb_sunny),
                    Slider(
                      label:
                          "${sensorDataI.temp_criticalMin.toStringAsFixed(1)}",
                      min: limitMin,
                      max: limitMax,
                      divisions: ((limitMax - limitMin) * 2).round(),
                      value: sensorDataI.temp_criticalMin,
                      activeColor: Color(0xff512ea8),
                      inactiveColor: Color(0xffac9bcc),
                      onChanged: (newValue) {
                        setState(() {
                          sensorDataI.temp_criticalMin = newValue;
                        });
                      },
                    ),
                    // TemperatureMinSlider(
                    //     sensor.sensorData[sensorDataIndex].criticalMin)
                  ]),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Max (°C, alerte)'),
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.wb_sunny),
                    Slider(
                      label:
                          "${sensorDataI.temp_criticalMax.toStringAsFixed(1)}",
                      min: limitMin,
                      max: limitMax,
                      divisions: ((limitMax - limitMin) * 2).round(),
                      value: sensorDataI.temp_criticalMax,
                      activeColor: Color(0xff512ea8),
                      inactiveColor: Color(0xffac9bcc),
                      onChanged: (newValue) {
                        setState(() {
                          sensorDataI.temp_criticalMax = newValue;
                        });
                      },
                    ),
                    // TemperatureMaxSlider(
                    //     sensor.sensorData[sensorDataIndex].criticalMax)
                  ]),
                ],
              ),
              // Row(children: [
              //   Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child:
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      child: Text("Save"),
                      color: Colors.green,
                      onPressed: () async {
                        print("sensor id: +${sensor.id}");
                        print("nominale: ${sensorDataI.nominalValue}");
                        print("acceptableMin: ${sensorDataI.acceptableMin}");
                        print("acceptableMax: ${sensorDataI.acceptableMax}");
                        print("criticalMin: ${sensorDataI.criticalMin}");
                        print("criticalMax: ${sensorDataI.criticalMax}");
                        print("");
                        print("sensor id: +${sensor.id}");
                        print("nominale: ${sensorDataI.temp_nominalValue}");
                        print(
                            "acceptableMin: ${sensorDataI.temp_acceptableMin}");
                        print(
                            "acceptableMax: ${sensorDataI.temp_acceptableMax}");
                        print("criticalMin: ${sensorDataI.temp_criticalMin}");
                        print("criticalMax: ${sensorDataI.temp_criticalMax}");

                        if (sensorDataI.temp_nominalValue <=
                                sensorDataI.temp_acceptableMin ||
                            sensorDataI.temp_nominalValue >=
                                sensorDataI.temp_acceptableMax) {
                          displayDialog(context, "ERROR",
                              "The nominal value must inside the acceptable range!");
                        } else if (sensorDataI.temp_acceptableMin <=
                                sensorDataI.temp_criticalMin ||
                            sensorDataI.temp_acceptableMin >=
                                sensorDataI.temp_criticalMax) {
                          displayDialog(context, "ERROR",
                              "The acceptable minimal value must be set between the minimal critical value and the maximum one");
                        } else if (sensorDataI.temp_acceptableMax <=
                                sensorDataI.temp_criticalMin ||
                            sensorDataI.temp_acceptableMax >=
                                sensorDataI.temp_criticalMax) {
                          displayDialog(context, "ERROR",
                              "The acceptable maximal value must be set between the minimal critical value and the maximum one");
                        } else {
                          var res = await updateSensorDataConfig(
                              sensor, sensorDataIndex);
                          displayDialog(context, "RESULT", res);
                        }

                        // if (_formKey.currentState.validate()) {
                        //   _formKey.currentState.save();
                        // }
                      },
                    ),
                  ),
                  RaisedButton(
                    child: Text("Reset"),
                    color: Colors.blue,
                    onPressed: () {
                      resetSlidersValues();
                      // print("sensor id: +${sensor.id}");
                      // print("nominale: ${temp_nominalValue}");
                      // print("acceptableMin: ${temp_acceptableMin}");
                      // print("acceptableMax: ${temp_acceptableMax}");
                      // print("criticalMin: ${temp_criticalMin}");
                      // print("criticalMax: ${temp_criticalMax}");

                      // if (_formKey.currentState.validate()) {
                      //   _formKey.currentState.save();
                      // }
                    },
                  ),
                ],
              ),
              //   ),
              //   Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: RaisedButton(
              //       child: Text("Annuler"),
              //       onPressed: () {
              //         Navigator.pop(context);
              //       },
              //     ),
              //   ),
              // ])
            ],
          ),
        ],
      ),
    );
  }
}
