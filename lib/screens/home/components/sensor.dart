import 'package:cult_connect/screens/home/components/data.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // show json, base64, ascii;
import 'package:flutter/foundation.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';

class Sensor {
  final String name;
  final List<SensorData> sensorData;

  Sensor({this.name, this.sensorData});

  factory Sensor.fromJson(Map<String, dynamic> json) {
    List<SensorData> list = (json['sensorData'] as List)
        .map((sensorData) => SensorData.fromJson(sensorData))
        .toList();

    return Sensor(
        name: json['name'],
        sensorData: (json['sensorData'] as List)
            .map((sensorData) => SensorData.fromJson(sensorData))
            .toList());
  }

  void pushSensorDetails(BuildContext context, int sensorDataIndex) {
    print("index sensorData : " + sensorDataIndex.toString());

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          List<Value> data = new List();

          final Iterable<ListTile> tiles =
              sensorData[sensorDataIndex].data.values.map(
            (Value val) {
              data.add(val);
              return ListTile(
                title: Text(
                    DateFormat('MMMM d, kk:mm').format(val.date).toString() +
                        " : " +
                        val.value.toString() +
                        " " +
                        sensorData[sensorDataIndex].unit),
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
                  sensorData[sensorDataIndex].dataType +
                      " (" +
                      sensorData[sensorDataIndex].unit +
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
                title: Text(name),
              ),
              body: Column(children: [
                Flexible(
                  child: ListView(
                    children: divided,
                  ),
                ),
                chartWidget
              ]));
        },
      ),
    );
  }
}
