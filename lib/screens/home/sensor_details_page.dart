import 'dart:convert'; // show json, base64, ascii;
import 'package:cult_connect/components/drawer.dart';
import 'package:cult_connect/screens/home/components/add_module_dialog.dart';
import 'package:cult_connect/screens/home/components/module.dart';
import 'package:cult_connect/screens/home/components/sensor_config_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'components/data.dart';
import 'components/moduleSettingsDialog.dart';
import 'components/sensor.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

import 'components/sensorSettingsDialog.dart';

class SensorDetailsPage extends StatefulWidget {
  Sensor sensor;
  int sensorDataIndex;
  SensorDetailsPage(this.sensor, this.sensorDataIndex, {Key key})
      : super(key: key);

  @override
  _SensorDetailsPage createState() =>
      _SensorDetailsPage(sensor, sensorDataIndex);
}

class _SensorDetailsPage extends State<SensorDetailsPage> {
  Sensor sensor;
  int sensorDataIndex;
  _SensorDetailsPage(this.sensor, this.sensorDataIndex);

  void displayDialogUpdate(BuildContext context, String title) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text(title),
            content: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    // controller: _emailController,
                    decoration: const InputDecoration(
                      // icon: Icon(Icons.person),
                      hintText: 'sensor1',
                      // labelText: 'Email *',
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                            onPressed: () {
                              print("validated!");
                            },
                            child: Text('Enter')),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RaisedButton(
                            onPressed: () {
                              print("cancel!");
                            },
                            child: Text('Cancel')),
                      ),
                    ],
                  )
                ],
              ),
            )),
      );

  void displayDialog(BuildContext context, String title, String text) =>
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  @override
  Widget build(BuildContext context) {
    List<Value> data = new List();

    final Iterable<ListTile> tiles =
        sensor.sensorData[sensorDataIndex].data.values.map(
      (Value val) {
        data.add(val);
        return ListTile(
          title: Text(DateFormat('MMMM d, kk:mm').format(val.date).toString() +
              " : " +
              val.value.toString() +
              " " +
              sensor.sensorData[sensorDataIndex].unit),
        );
      },
    );
    final List<Widget> divided = ListTile.divideTiles(
      context: context,
      tiles: tiles,
    ).toList();

    var series = [
      new charts.Series(
        id: 'Clicks',
        domainFn: (Value clickData, _) => clickData.date,
        measureFn: (Value clickData, _) => clickData.value,
        // colorFn: (Value clickData, _) => clickData.color,
        data: data,
      ),
    ];
    var chart = new charts.TimeSeriesChart(
      series,
      animate: true,
      behaviors: [
        new charts.ChartTitle(
            sensor.sensorData[sensorDataIndex].dataType +
                " (" +
                sensor.sensorData[sensorDataIndex].unit +
                ")",
            // subTitle: 'Top sub-title text',
            behaviorPosition: charts.BehaviorPosition.top,
            titleOutsideJustification: charts.OutsideJustification.start,
            // Set a larger inner padding than the default (10) to avoid
            // rendering the text too close to the top measure axis tick label.
            // The top tick label may extend upwards into the top margin region
            // if it is located at the top of the draw area.
            innerPadding: 18),
        // new charts.ChartTitle('Bottom title text',
        //     behaviorPosition: charts.BehaviorPosition.bottom,
        //     titleOutsideJustification:
        //         charts.OutsideJustification.middleDrawArea),
      ],
    );
    var chartWidget = new Padding(
      padding: new EdgeInsets.all(32.0),
      child: new SizedBox(
        height: 200.0,
        child: chart,
      ),
    );
    return Scaffold(
        // Add 6 lines from here...
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              Text(sensor.name +
                  " (" +
                  sensor.sensorData[sensorDataIndex].dataType +
                  ")"),
              IconButton(
                onPressed: () {
                  print("clicked!");
                  displaySensorSettingsDialog(context, sensor);
                },
                icon: Icon(Icons.settings),
                color: Colors.black,
              )
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Text("Automatic mode: "),
                  Switch(
                    value: sensor.sensorData[sensorDataIndex].automaticMode,
                    onChanged: (value) {
                      setState(() {
                        sensor.sensorData[sensorDataIndex]
                            .updateSensorDataAutomaticMode(
                                sensor.id, sensorDataIndex, value);
                      });
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                ],
              ),
            ),
            Visibility(
              visible: sensor.sensorData[sensorDataIndex].automaticMode,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SensorConfigForm(sensor, sensorDataIndex),
              ),
            ),
            chartWidget
          ]),
        ));
  }
}
