import 'package:cult_connect/screens/home/components/module.dart';
import 'package:cult_connect/screens/home/components/sensor.dart';
import 'package:flutter/material.dart';

class SensorsList extends StatelessWidget {
  final List<Sensor> sensors;

  SensorsList({this.sensors, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(sensors.length);
    if (sensors.length == 0) {
      print("pas de sensors");
      return Center(child: Text("pas de sensors !"));
    } else {
      print("voici les sensors:");
      print(sensors);
      return Expanded(
          child: ListView.builder(
            shrinkWrap: true,
        // Let the ListView know how many items it needs to build.
        itemCount: sensors.length,
        // Provide a builder function. This is where the magic happens.
        // Convert each item into a widget based on the type of item it is.
        itemBuilder: (context, index) {
          final item = sensors[index];
          return Container(
            // height: 50,
            child: Column(children: [Text(item.name)]),
          );
          // return ListTile(
          //   title: Text(item.name),
          //   subtitle: Text("dernier relevé :30"),
          // );
        },
      ));
    }
  }
}

class BlocModule extends StatelessWidget {
  final Module module;

  BlocModule({@required this.module});

  String getModuleNamePlace(module) {
    // print(module);
    return module.name; //+ " (" + module.place + ")";
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        title: Column(
          children: [
            Row(
              children: [
                Text(getModuleNamePlace(module)),
              ],
            ),
          ],
        ),
        children: [
          Text('Capteurs associés:'),
          // Text(module.sensors.toString()),
          SensorsList(sensors: module.sensors)
          // ListView.builder(
          //   module.sensors.count
          // )
        ]);
    // Padding(
    //   padding: const EdgeInsets.all(8.0),
    //   child: Card(
    //       child: Column(mainAxisSize: MainAxisSize.min, children: [
    //     Row(
    //       children: [
    //         Icon(Icons.wb_sunny),
    //         Text(name),
    //       ],
    //     ),
    //     Text('Dernier relevé: 30°C')
    //   ])),
    // );
  }
  // @override
  // _BlocModule createState() => _BlocModule();
}

// class PointsLineChart extends StatelessWidget {
//   final List<charts.Series> seriesList;
//   final bool animate;

//   PointsLineChart(this.seriesList, {this.animate});

//   /// Creates a [LineChart] with sample data and no transition.
//   factory PointsLineChart.withSampleData() {
//     return new PointsLineChart(
//       _createSampleData(),
//       // Disable animations for image tests.
//       animate: false,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new charts.LineChart(seriesList,
//         animate: animate,
//         defaultRenderer: new charts.LineRendererConfig(includePoints: true));
//   }

//   /// Create one series with sample hard coded data.
//   static List<charts.Series<LinearSales, int>> _createSampleData() {
//     final data = [
//       new LinearSales(0, 5),
//       new LinearSales(1, 25),
//       new LinearSales(2, 100),
//       new LinearSales(3, 75),
//     ];

//     return [
//       new charts.Series<LinearSales, int>(
//         id: 'Sales',
//         colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
//         domainFn: (LinearSales sales, _) => sales.year,
//         measureFn: (LinearSales sales, _) => sales.sales,
//         data: data,
//       )
//     ];
//   }
// }

// /// Sample linear data type.
// class LinearSales {
//   final int year;
//   final int sales;

//   LinearSales(this.year, this.sales);
// }
