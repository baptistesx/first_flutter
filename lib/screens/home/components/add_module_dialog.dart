import 'package:cult_connect/screens/home/components/add_module_form.dart';
import 'package:flutter/material.dart';

class AddModuleDialog extends StatelessWidget {
  final String jwt;
  final Map<String, dynamic> payload;

  AddModuleDialog(this.jwt, this.payload, {Key key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('Add a module'),
        Text('IDs are written on it',
            style: TextStyle(
              fontSize: 15,
            )),
      ]),
      content: AddModuleForm(jwt, payload),
    );
  }
}
