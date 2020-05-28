import 'dart:async';
import 'package:cult_connect/screens/add_first_module_page.dart';
import 'package:cult_connect/screens/configuration/components/config_sliders_widgets.dart';
import 'package:cult_connect/screens/home/home_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// const SERVER_IP = 'http://10.0.2.2:8081';
// const SERVER_IP = 'http://192.168.1.26:8081';
// const SERVER_IP = 'http://192.168.0.24:8081';

final storage = FlutterSecureStorage();

// Future<String> fetchConnectionIdentifiers(String email, String pwd) async {
//   final response =
//       await http.post(SERVER_IP + '/login', body: {"email": email, "pwd": pwd});
//   print(response.body);
//   if (response.statusCode == 200) return response.body;

//   return null;
// }

class SensorConfigForm extends StatefulWidget {
  @override
  _SensorConfigForm createState() => _SensorConfigForm();
}

class _SensorConfigForm extends State<SensorConfigForm> {
  final String email = "";
  final String pwd = "";
  final _connectionFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  bool _showLoader = false;
  Future<String> futureConnectionIdentifiers;

  void _showLoaderFunction() {
    setState(() {
      _showLoader = true;
    });
  }

  void displayDialog(BuildContext context, String title, String text) =>
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Column(mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(text),
              ],
            )),
      );

  @override
  Widget build(BuildContext context) {
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
                    TemperatureNominaleSlider()
                  ]),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Température acceptable (°C)'),
                  Row(mainAxisSize: MainAxisSize.min,children: [Icon(Icons.wb_sunny), TemperatureOKSlider()]),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Min (°C, alerte)'),
                  Row(mainAxisSize: MainAxisSize.min,children: [Icon(Icons.wb_sunny), TemperatureMinSlider()]),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Max (°C, alerte)'),
                  Row(mainAxisSize: MainAxisSize.min,children: [Icon(Icons.wb_sunny), TemperatureMaxSlider()]),
                ],
              ),
              // Row(children: [
              //   Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child:
              RaisedButton(
                child: Text("Save"),
                color: Colors.green,
                onPressed: () {
                  // if (_formKey.currentState.validate()) {
                  //   _formKey.currentState.save();
                  // }
                },
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
