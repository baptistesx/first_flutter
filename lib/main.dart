import 'package:cult_connect/screens/add_first_module_page.dart';
import 'package:cult_connect/screens/configuration/configuration_page.dart';
import 'package:cult_connect/screens/determine_first_page.dart';
import 'package:cult_connect/screens/evolution/evolution_page.dart';
// import 'package:cult_connect/screens/home/sensor_data_page.dart';
import 'package:cult_connect/screens/sd/sd_page.dart';
import 'package:cult_connect/theme/style.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  String jwt;
  Map<String, dynamic> payload;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: appTheme(),
      initialRoute: '/',
      routes: {
        '/': (context) => DetermineFirstPage(),
        '/config': (context) => ConfigurationPage(),
        '/evol': (context) => EvolutionPage(),
        '/sd': (context) => SdPage(),
        // '/sensorData': (context) => SensorDetailsPage(),
      },
    );
  }
}
