import 'package:flutter/material.dart';

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