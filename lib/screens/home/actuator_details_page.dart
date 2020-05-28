import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'components/actuator.dart';

class ActuatorDetailsPage extends StatefulWidget {
  Actuator actuator;
  Switch stateSwitch;
  ActuatorDetailsPage(this.actuator, this.stateSwitch);

  @override
  _ActuatorDetailsPage createState() =>
      _ActuatorDetailsPage(actuator, stateSwitch);
}

class _ActuatorDetailsPage extends State<ActuatorDetailsPage> {
  Actuator actuator;
  Switch stateSwitch;
  _ActuatorDetailsPage(this.actuator, this.stateSwitch);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // Add 6 lines from here...
        appBar: AppBar(
          title: Text(actuator.name),
        ),
        body: Column(children: [
          Flexible(
            child: ListView(children: [
              Row(children: <Widget>[
                Text("State: "),
                stateSwitch,
              ]),
              Column(children: [
                Row(children: <Widget>[
                  Text("Automatic mode: "),
                  Switch(
                    value: actuator.automaticModeIsSwitched,
                    onChanged: (value) {
                      setState(() {
                        actuator.toggleAutomaticMode(value);
                      });
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                ]),

              ])
            ]),
          ),
        ]));
  }
}
