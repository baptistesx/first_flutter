import 'dart:convert';

import 'package:cult_connect/screens/authentication/authentification_page.dart';
import 'package:cult_connect/screens/authentication/components/connection_form.dart';
import 'package:cult_connect/screens/home/home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetermineFirstPage extends StatelessWidget {
  var jwt;

  Future<String> get jwtOrEmpty async {
    //TODO: To decomment to keep always connected once connected
    var jwt = await storage.read(key: "jwt");
    // if (jwt == null)
    return "";
    // return jwt;
  }

  @override
  Widget build(BuildContext context) {
    // Page redirection choice following the jwt (JSON Web Token) value
    return FutureBuilder(
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
        });
  }
}
