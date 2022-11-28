import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

import '../../../../../main.dart';
import '../../domain/model/userpreferences.dart';
import '../../domain/usecase/__preferences_usecases.dart';

class SettingsScreen extends StatefulWidget {
  final String title;

  const SettingsScreen({super.key, required this.title});

  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  late int orderMode;

  void _clickChangeOrderingMode(int value) async{
    Settings.setValue("order_mode", value);
    setState(() {
      orderMode = Settings.getValue("order_mode", defaultValue: 1)!;
    });
  }


  @override
  void initState() {
    setState(() {
      orderMode = Settings.getValue("order_mode", defaultValue: 1)!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title),),
      body: Column(
        children: [
          SettingsGroup(
            title: "Grades",
            children: [
              DropDownSettingsTile(
                title: "Grade Ordering",
                settingKey: "grade_ordering",
                selected: orderMode,
                values: const <int, String>{
                  1: "Low Value Good, High Value Bad",
                  2: "Low Value Bad, High Value Good"
                },
                onChange: _clickChangeOrderingMode,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
