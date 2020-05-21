import 'package:cult_connect/screens/authentication/components/connection_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Drawer(
          child: ListView(
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
                title: Text('Homepage'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Configuration'),
                onTap: () {
                  Navigator.pushNamed(context, '/config');
                },
              ),
              ListTile(
                title: Text('Evolution'),
                onTap: () {
                  Navigator.pushNamed(context, '/evol');
                },
              ),
              ListTile(
                title: Text('SD card'),
                onTap: () {
                  Navigator.pushNamed(context, '/sd');
                },
              ),
              ListTile(
                title: Text('Log out'),
                onTap: () {
                  storage.write(key: "jwt", value: "");
                  Navigator.pushNamed(context, '/');
                },
              ),
            ],
          ),
        );
  }
}