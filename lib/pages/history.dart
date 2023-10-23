import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_task_flutter/utils/conversion/conversion.dart';

import 'package:test_task_flutter/pages/main_screen.dart';
import 'package:test_task_flutter/utils/conversion/conversion_helper.dart';
import 'package:xml/xml.dart';

List<Conversion> conversions = [];

/// This screen contains list of all conversions.
class History extends StatefulWidget with WidgetsBindingObserver {
  const History({super.key});

  @override
  State<StatefulWidget> createState() {
    return _History();
  }
}

class _History extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('operations_history'.tr()),
        actions: [
          IconButton(
              onPressed: () async {
                String? path = await FilesystemPicker.open(
                  rootDirectory: await getApplicationDocumentsDirectory(),
                  context: context,
                  title: 'folder_selection'.tr(),
                  contextActions: [
                    FilesystemPickerNewFolderContextAction(),
                  ],
                  pickText: 'Save into this folder'.tr(),
                  allowedExtensions: ['.xml'],
                  fileTileSelectMode: FileTileSelectMode.wholeTile,
                );

                _write(path.toString(), _createXml(conversionsHistory).toString());
              },
              icon: const Icon(Icons.save))
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: createWidgetList(conversionsHistory),
      ),
    );
  }

  Future<String> showSelectNameDialog() {
    String res = "";
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('file_name'.tr()),
            actions: <Widget>[
              TextField(
                maxLength: 30,
                decoration: InputDecoration(
                    border: const UnderlineInputBorder(),
                    hintText: 'enter_file_name'.tr()),
                inputFormatters: [
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    res = newValue.text;
                    return TextEditingValue(text: res.toString());
                  })
                ],
              ),
              TextButton(
                child: Text('ok'.tr()),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
    return res as Future<String>;
  }
}

List<Widget> createWidgetList(List<Conversion> list) {
  List<Widget> res = [];

  for(Conversion conversion in list) {
    res.add(Center(
      child: Padding(padding: const EdgeInsets.only(top: 10),
        child: Column(
        children: [
        Text(
        '${conversion.dateAndTime}: ${conversion.startCurrency} -> ${conversion.endCurrency}',
        style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold
        ),
      ),
      Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            '${conversion.startValue} -> ${conversion.endValue}',
            style: const TextStyle(
              fontSize: 20,
            ),
          ))
      ],
    ),)
    ));
  }
  return res;
}

void _write(String path, String text) async {
  final File file = File('$path/history.xml');
  await file.writeAsString(text);
}

XmlDocument _createXml(List<Conversion> list) {
  final builder = XmlBuilder();
  builder.processing('xml', 'version="1.0"');
  for (Conversion conversion in list) {
    builder.element('Conversion', nest: () {
      builder.element("startValue", nest: conversion.startValue);
      builder.element("endValue", nest: conversion.endValue);
      builder.element("startCurrency", nest: conversion.startCurrency);
      builder.element("endCurrency", nest: conversion.endCurrency);
      builder.element("dateAndTime", nest: conversion.dateAndTime);
    });
  }
  return builder.buildDocument();
}

@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  _saveData();
}

Future<void> _saveData() async {
  var prefs = await SharedPreferences.getInstance();
  prefs.setString('conversions', ConversionHelper.encode(conversionsHistory));
}