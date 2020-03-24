import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class BlocModule extends StatelessWidget {
  // final int number;
  // BlocModule({this.number});

  BlocModule({@required this.name, this.lastValue, this.unit});

  final String name;
  final double lastValue;
  final String unit;

// final chart = new PointsLineChart(seriesList:)
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        title: Column(
          children: [
            Row(
              children: [
                Icon(Icons.wb_sunny),
                Text(name),
              ],
            ),
            Text('Dernier relevé: ' + lastValue.toString() + unit)
          ],
        ),
        children: [
          Text('relevé temporel'),
        ]);
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(
          children: [
            Icon(Icons.wb_sunny),
            Text(name),
          ],
        ),
        Text('Dernier relevé: 30°C')
      ])),
    );
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
