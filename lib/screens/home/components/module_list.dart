import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'actuator.dart';
import 'data.dart';
import 'module.dart';
import 'moduleSettingsDialog.dart';
import 'sensor.dart';
import 'package:intl/intl.dart';

class ModulesList extends StatefulWidget {
  final List<Module> modules;

  ModulesList({Key key, this.modules}) : super(key: key);

  @override
  _ModulesListState createState() => _ModulesListState();
}

class _ModulesListState extends State<ModulesList> {
  @override
  Widget build(BuildContext context) {
    if (widget.modules.length == 0) {
      print("pas de module");
      return Center(
          child: Text(
        "Add your first module !",
        style: TextStyle(fontSize: 25),
      ));
    } else {
      return new ListView.builder(
          itemCount: widget.modules.length,
          itemBuilder: (context, index) {
            return new ExpansionTile(
              title: Row(
                children: <Widget>[
                  new Text(widget.modules[index].name +
                      " - " +
                      widget.modules[index].place),
                  IconButton(
                    onPressed: () {
                      print("clicked!");
                      displayModuleSettingsDialog(
                          context, widget.modules[index]);
                    },
                    icon: Icon(Icons.settings),
                    color: Colors.grey,
                  ),
                ],
              ),
              children: <Widget>[
                new Column(
                  children:
                      _buildExpandableContent(widget.modules[index], context),
                )
              ],
            );
          });
    }
  }

  _buildExpandableContent(Module module, BuildContext context) {
    List<Widget> columnContent = [];

    for (Sensor sensor in module.sensors) {
      columnContent.add(
        new ListTile(
            title: new Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    sensor.name + " (" + sensor.dataType + ")",
                    style:
                        new TextStyle(fontSize: 18.0, color: Colors.lightBlue),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 15,
                  ),
                ],
              ),
              Text(DateFormat('MMMM d, kk:mm')
                      .format(sensor.data.values[0].date)
                      .toString() +
                  ": " +
                  sensor.data.values[0].value.toString() +
                  sensor.unit)
            ]),
            onTap: () {
              sensor.pushSensorDetails(context);
            }),
      );
    }

    // for (Actuator actuator in module.actuators) {
    //   // var callback;
    //   // if(sensor.sensorData[sensorDataIndex]) = (bool s) => print(s);
    //   // callback= null;
    //   Switch stateSwitch = new Switch(
    //     value: actuator.stateIsSwitched,
    //     onChanged: //callback,
    //         (value) {
    //       setState(() {
    //         null;
    //         // actuator.toggleState(value);
    //       });
    //     },
    //     activeTrackColor: Colors.lightGreenAccent,
    //     activeColor: Colors.green,
    //   );
    //   columnContent.add(
    //     new ListTile(
    //         title: new Column(children: [
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               Text(
    //                 actuator.name,
    //                 style: new TextStyle(
    //                     fontSize: 18.0, color: Colors.orangeAccent),
    //               ),
    //               stateSwitch,
    //               Icon(
    //                 Icons.arrow_forward_ios,
    //                 color: Colors.grey,
    //                 size: 15,
    //               ),
    //             ],
    //           ),
    //         ]),
    //         onTap: () {
    //           actuator.pushActuatorDetails(context, stateSwitch);
    //         }),
    //   );
    // }
    return columnContent;
  }

  //         var callback = function(bool value) {
  // }

}
