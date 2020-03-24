import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show json, base64, ascii;
import 'package:cult_connect/bloc_module.dart';
import 'package:cult_connect/connection_form.dart';
import 'package:cult_connect/register_form.dart';
import 'package:flutter/material.dart';
import 'config_sliders_widgets.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:http/http.dart' as http;

// const SERVER_IP = 'http://10.0.2.2:8080';
const SERVER_IP = 'http://192.168.1.22:8080';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    // if (jwt == null)
    return "";
    // return jwt;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      // home: HomePage(title: 'Cult\'Connect'),
      initialRoute: '/',
      routes: {
        // '/': (context) => IdentificationPage(),
        // '/home': (context) => HomePage(),
        '/config': (context) => ConfigurationPage(),
        '/evol': (context) => EvolutionPage(),
        '/sd': (context) => SdPage()
      },
      home: FutureBuilder(
          future: jwtOrEmpty,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            if (snapshot.data != "") {
              var str = snapshot.data;
              var jwt = str.split(".");

              if (jwt.length != 3) {
                return IdentificationPage();
              } else {
                var payload = json.decode(
                    ascii.decode(base64.decode(base64.normalize(jwt[1]))));
                if (DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000)
                    .isAfter(DateTime.now())) {
                  return HomePage(str, payload);
                } else {
                  return IdentificationPage();
                }
              }
            } else {
              return IdentificationPage();
            }
          }),
    );
  }
}

class IdentificationPage extends StatefulWidget {
  @override
  _IdentificationPageState createState() => _IdentificationPageState();
}

class _IdentificationPageState extends State<IdentificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('Bienvenue', style: TextStyle(fontSize: 30)),
        Text('Connectez-vous', style: TextStyle(fontSize: 15)),
        ConnectionForm(),
        RaisedButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Inscription'),
                    content: RegisterForm(),
                  );
                });
          },
          child: Text('Inscription'),
        ),
      ])),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage(this.jwt, this.payload);

  factory HomePage.fromBase64(String jwt) => HomePage(
      jwt,
      json.decode(
          ascii.decode(base64.decode(base64.normalize(jwt.split(".")[1])))));

  final String jwt;
  final Map<String, dynamic> payload;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Accueil'),
        ),
        body: Center(
          child: Column(children: [
            FutureBuilder(
                future: http.read(SERVER_IP + '/api/user/modules',
                    headers: {"Authorization": jwt}),
                builder: (context, snapshot) => snapshot.hasData
                    ? Column(
                        children: <Widget>[
                          Text("${payload['username']}, here's the data:"),
                          Text(snapshot.data,
                              style: Theme.of(context).textTheme.display1)
                        ],
                      )
                    : snapshot.hasError
                        ? Text("An error occurred")
                        : CircularProgressIndicator()),
            RaisedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Column(children: [
                          Text('Ajout d\'un module'),
                          Text('Les id se trouvent sur le boitier')
                        ]),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Surnom du module'),
                            ),
                            TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Id publique'),
                            ),
                            TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Id privée'),
                            ),
                            RaisedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Valider'),
                            ),
                          ],
                        ),
                      );
                    });
              },
              child: Text('Ajouter un module'),
            ),
            Text('Liste des modules:'),
            BlocModule(name: "MonCapteur1", lastValue: 30, unit: "°C"),
            BlocModule(name: "MonCapteur2", lastValue: 0, unit: "°C"),
          ]),
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
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Configuration'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  // Navigator.pop(context);
                  Navigator.pushNamed(context, '/config');
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

class Ip1ExtWidget extends StatefulWidget {
  Ip1ExtWidget({Key key}) : super(key: key);

  @override
  _Ip1ExtWidgetState createState() => _Ip1ExtWidgetState();
}

class _Ip1ExtWidgetState extends State<Ip1ExtWidget> {
  int ip1 = 192;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: ip1,
      icon: Icon(Icons.arrow_downward),
      iconSize: 16,
      elevation: 16,
      style: TextStyle(fontSize: 18, color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      items: new List<DropdownMenuItem<int>>.generate(
        255,
        (int index) => new DropdownMenuItem<int>(
          value: index,
          child: new Text(index.toString()),
        ),
      ),
      onChanged: (int value) {
        setState(() {
          ip1 = value;
        });
      },
    );
  }
}

class Ip2ExtWidget extends StatefulWidget {
  Ip2ExtWidget({Key key}) : super(key: key);

  @override
  _Ip2ExtWidgetState createState() => _Ip2ExtWidgetState();
}

class _Ip2ExtWidgetState extends State<Ip2ExtWidget> {
  int ip2 = 168;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: ip2,
      icon: Icon(Icons.arrow_downward),
      iconSize: 16,
      elevation: 16,
      style: TextStyle(fontSize: 18, color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      items: new List<DropdownMenuItem<int>>.generate(
        255,
        (int index) => new DropdownMenuItem<int>(
          value: index,
          child: new Text(index.toString()),
        ),
      ),
      onChanged: (int value) {
        setState(() {
          ip2 = value;
        });
      },
    );
  }
}

class Ip3ExtWidget extends StatefulWidget {
  Ip3ExtWidget({Key key}) : super(key: key);

  @override
  _Ip3ExtWidgetState createState() => _Ip3ExtWidgetState();
}

class _Ip3ExtWidgetState extends State<Ip3ExtWidget> {
  int ip3 = 1;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: ip3,
      icon: Icon(Icons.arrow_downward),
      iconSize: 16,
      elevation: 16,
      style: TextStyle(fontSize: 18, color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      items: new List<DropdownMenuItem<int>>.generate(
        255,
        (int index) => new DropdownMenuItem<int>(
          value: index,
          child: new Text(index.toString()),
        ),
      ),
      onChanged: (int value) {
        setState(() {
          ip3 = value;
        });
      },
    );
  }
}

class Ip4ExtWidget extends StatefulWidget {
  Ip4ExtWidget({Key key}) : super(key: key);

  @override
  _Ip4ExtWidgetState createState() => _Ip4ExtWidgetState();
}

class _Ip4ExtWidgetState extends State<Ip4ExtWidget> {
  int ip4 = 68;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: ip4,
      icon: Icon(Icons.arrow_downward),
      iconSize: 16,
      elevation: 16,
      style: TextStyle(fontSize: 18, color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      items: new List<DropdownMenuItem<int>>.generate(
        255,
        (int index) => new DropdownMenuItem<int>(
          value: index,
          child: new Text(index.toString()),
        ),
      ),
      onChanged: (int value) {
        setState(() {
          ip4 = value;
        });
      },
    );
  }
}

class Ip1IntWidget extends StatefulWidget {
  Ip1IntWidget({Key key}) : super(key: key);

  @override
  _Ip1IntWidgetState createState() => _Ip1IntWidgetState();
}

class _Ip1IntWidgetState extends State<Ip1IntWidget> {
  int ip1 = 192;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: ip1,
      icon: Icon(Icons.arrow_downward),
      iconSize: 16,
      elevation: 16,
      style: TextStyle(fontSize: 18, color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      items: new List<DropdownMenuItem<int>>.generate(
        255,
        (int index) => new DropdownMenuItem<int>(
          value: index,
          child: new Text(index.toString()),
        ),
      ),
      onChanged: (int value) {
        setState(() {
          ip1 = value;
        });
      },
    );
  }
}

class Ip2IntWidget extends StatefulWidget {
  Ip2IntWidget({Key key}) : super(key: key);

  @override
  _Ip2IntWidgetState createState() => _Ip2IntWidgetState();
}

class _Ip2IntWidgetState extends State<Ip2IntWidget> {
  int ip2 = 168;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: ip2,
      icon: Icon(Icons.arrow_downward),
      iconSize: 16,
      elevation: 16,
      style: TextStyle(fontSize: 18, color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      items: new List<DropdownMenuItem<int>>.generate(
        255,
        (int index) => new DropdownMenuItem<int>(
          value: index,
          child: new Text(index.toString()),
        ),
      ),
      onChanged: (int value) {
        setState(() {
          ip2 = value;
        });
      },
    );
  }
}

class Ip3IntWidget extends StatefulWidget {
  Ip3IntWidget({Key key}) : super(key: key);

  @override
  _Ip3IntWidgetState createState() => _Ip3IntWidgetState();
}

class _Ip3IntWidgetState extends State<Ip3IntWidget> {
  int ip3 = 1;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: ip3,
      icon: Icon(Icons.arrow_downward),
      iconSize: 16,
      elevation: 16,
      style: TextStyle(fontSize: 18, color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      items: new List<DropdownMenuItem<int>>.generate(
        255,
        (int index) => new DropdownMenuItem<int>(
          value: index,
          child: new Text(index.toString()),
        ),
      ),
      onChanged: (int value) {
        setState(() {
          ip3 = value;
        });
      },
    );
  }
}

class Ip4IntWidget extends StatefulWidget {
  Ip4IntWidget({Key key}) : super(key: key);

  @override
  _Ip4IntWidgetState createState() => _Ip4IntWidgetState();
}

class _Ip4IntWidgetState extends State<Ip4IntWidget> {
  int ip4 = 68;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: ip4,
      icon: Icon(Icons.arrow_downward),
      iconSize: 16,
      elevation: 16,
      style: TextStyle(fontSize: 18, color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      items: new List<DropdownMenuItem<int>>.generate(
        255,
        (int index) => new DropdownMenuItem<int>(
          value: index,
          child: new Text(index.toString()),
        ),
      ),
      onChanged: (int value) {
        setState(() {
          ip4 = value;
        });
      },
    );
  }
}

class EvolutionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Evolution'),
        ),
        body: Center(
          child: Text('Evolution'),
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
                  Navigator.pushNamed(context, '/config');
                },
              ),
              ListTile(
                title: Text('Evolution'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                  // Navigator.pushNamed(context, '/evol');
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

class SdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Carte SD'),
        ),
        body: Center(
          child: Text('Carte SD'),
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
                  // Navigator.pop(context);
                  Navigator.pushNamed(context, '/config');
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
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ));
  }
}
