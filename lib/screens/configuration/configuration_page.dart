import 'package:cult_connect/screens/configuration/components/config_sliders_widgets.dart';
import 'package:cult_connect/screens/configuration/components/ip_widgets.dart';
import 'package:flutter/material.dart';

class ConfigurationPage extends StatefulWidget {
  @override
  _ConfigurationPageState createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  final _formKey = GlobalKey<FormState>();
  RangeValues _tempOK = RangeValues(0.1, 0.7);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Configuration'),
        ),
        body: Column(
          children: [
            Row(children: [
              Icon(
                Icons.power_settings_new,
                color: Colors.grey,
              ),
              Text('Module non connecté')
            ]),
            Row(children: [
              IconButton(
                icon: Icon(Icons.power_settings_new, color: Colors.green),
                onPressed: () {},
              ),
              Text('Mode automatique')
            ]),
            RaisedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Column(children: [
                          Text('IP externe'),
                          Text(
                            'Configurer l\'adresse IP et le port externe permettant d\'atteindre le module',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 16.0),
                          )
                        ]),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              children: [
                                Text('Remarque:',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline)),
                                Text('Le port externe est nécéssaire. ')
                              ],
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Row(children: [
                                    Ip1ExtWidget(),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('.',
                                          style: TextStyle(fontSize: 30)),
                                    ),
                                    Ip2ExtWidget(),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('.',
                                          style: TextStyle(fontSize: 30)),
                                    ),
                                    Ip3ExtWidget(),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('.',
                                          style: TextStyle(fontSize: 30)),
                                    ),
                                    Ip4ExtWidget(),
                                  ]),
                                  TextFormField(
                                    decoration: InputDecoration(
                                        labelText: 'Port externe'),
                                  ),
                                  Row(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RaisedButton(
                                        child: Text("Valider"),
                                        color: Colors.green,
                                        onPressed: () {
                                          if (_formKey.currentState
                                              .validate()) {
                                            _formKey.currentState.save();
                                          }
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RaisedButton(
                                        child: Text("Annuler"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ])
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              },
              child: Text('IP externe', style: TextStyle(fontSize: 20)),
            ),
            RaisedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Column(children: [
                          Text('IP interne'),
                          Text(
                            'Configurer l\'adresse IP et le port interne permettant d\'atteindre le module',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 16.0),
                          )
                        ]),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              children: [
                                Text('Remarque:',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline)),
                                Text('Le port interne est nécéssaire. ')
                              ],
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Row(children: [
                                    Ip1IntWidget(),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('.',
                                          style: TextStyle(fontSize: 30)),
                                    ),
                                    Ip2IntWidget(),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('.',
                                          style: TextStyle(fontSize: 30)),
                                    ),
                                    Ip3IntWidget(),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('.',
                                          style: TextStyle(fontSize: 30)),
                                    ),
                                    Ip4IntWidget(),
                                  ]),
                                  TextFormField(
                                    decoration: InputDecoration(
                                        labelText: 'Port interne'),
                                  ),
                                  Row(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RaisedButton(
                                        child: Text("Valider"),
                                        color: Colors.green,
                                        onPressed: () {
                                          if (_formKey.currentState
                                              .validate()) {
                                            _formKey.currentState.save();
                                          }
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: RaisedButton(
                                        child: Text("Annuler"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ])
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              },
              child: Text('IP interne', style: TextStyle(fontSize: 20)),
            ),
            RaisedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Column(children: [
                          Text('Seuils de température'),
                          Text(
                            'Pour le mode de gestion automatique',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 16.0),
                          )
                        ]),
                        content: Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0, bottom: 11.0),
                                    child: Column(
                                      children: <Widget>[
                                        Text('Remarque:',
                                            style: TextStyle(
                                                decoration:
                                                    TextDecoration.underline)),
                                        Text(
                                            'les actionneurs seront actifs seulement lorsque la température ne sera pas "acceptable".'),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0, bottom: 11.0),
                                    child: Column(
                                      children: <Widget>[
                                        Text('Attention:',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            'la température nominale doit être comprise entre les bornes de température acceptable. '),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Column(
                                      children: [
                                        Text('Température nominale (°C)'),
                                        Row(children: [
                                          Icon(Icons.wb_sunny),
                                          TemperatureNominaleSlider()
                                        ]),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text('Température acceptable (°C)'),
                                        Row(children: [
                                          Icon(Icons.wb_sunny),
                                          TemperatureOKSlider()
                                        ]),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text('Min (°C, alerte)'),
                                        Row(children: [
                                          Icon(Icons.wb_sunny),
                                          TemperatureMinSlider()
                                        ]),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text('Max (°C, alerte)'),
                                        Row(children: [
                                          Icon(Icons.wb_sunny),
                                          TemperatureMaxSlider()
                                        ]),
                                      ],
                                    ),
                                    Row(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RaisedButton(
                                          child: Text("Valider"),
                                          color: Colors.green,
                                          onPressed: () {
                                            if (_formKey.currentState
                                                .validate()) {
                                              _formKey.currentState.save();
                                            }
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RaisedButton(
                                          child: Text("Annuler"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    ])
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
              child:
                  Text('Seuils de température', style: TextStyle(fontSize: 20)),
            ),
            RaisedButton(
              onPressed: () {},
              child: Text('Seuils d\'humidité', style: TextStyle(fontSize: 20)),
            ),
            RaisedButton(
              onPressed: () {},
              child: Text('Actionneurs', style: TextStyle(fontSize: 20)),
            ),
            // SimpleDialog(
            //   title: const Text('Select assignment'),
            //   children: <Widget>[
            //     SimpleDialogOption(
            //       onPressed: () {
            //         Navigator.pop(context);
            //       },
            //       child: const Text('Treasury department'),
            //     ),
            //     SimpleDialogOption(
            //       onPressed: () {
            //         Navigator.pop(context);
            //       },
            //       child: const Text('State department'),
            //     ),
            //   ],
            // )
          ],
        ),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Center(
                  child: Text('Menu'),
                ),
                decoration: BoxDecoration(
                  color: Colors.yellow,
                ),
              ),
              ListTile(
                title: Text('Accueil'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pushNamed(context, '/home');
                },
              ),
              ListTile(
                title: Text('Configuration'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Evolution'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  // Navigator.pop(context);
                  Navigator.pushNamed(context, '/evol');
                },
              ),
              ListTile(
                title: Text('Carte SD'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  // Navigator.pop(context);
                  Navigator.pushNamed(context, '/sd');
                },
              ),
            ],
          ),
        ));
  }
}
