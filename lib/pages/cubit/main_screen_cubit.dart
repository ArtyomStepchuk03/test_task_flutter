import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task_flutter/list_item.dart';
import 'main_screen_state.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class MainScreenCubit extends Cubit<List<ListItem>> {
  String _date = "";
  XmlDocument xmlData = XmlDocument();
  late Future<List<ListItem>> _xmlItems;
  late BuildContext context;

  MainScreenCubit(this.context) : super([]) {
    _getXmlData();
    emit([]);
    _xmlItems = getItemsFromXml(context);

    emit([]);
  }

  // Future<void> pullRefresh() async {
  //   _getXmlData();
  // }

  void _setDateOfUpdate(XmlDocument xml) {
    _date = 'Дата обновления: ${xml.getElement('ValCurs')!.getAttribute('Date')}';
  }

  String get date => _date;


  Future<List<ListItem>> get xmlItems => _xmlItems;

  void _getXmlData() {
    print("_getXmlData");
    http.get(Uri.http('www.cbr-xml-daily.ru', 'daily_utf8.xml')).then((res) {
      print(state);
      print("_getXmlDataHttp");
      if (xmlData.toString() == utf8.decode(res.bodyBytes)) {
        print("_getXmlDataHttpIF");
        showMessageDialog('Курс валют актуальный, обновление не требуется.');
        return;
      } else {
        print("_getXmlDataHttpELSE");
        xmlData = XmlDocument.parse(utf8.decode(res.bodyBytes));
        _setDateOfUpdate(xmlData);

        print(date);
      }
    }).catchError((e) {
      showMessageDialog("Отсутствует соединение с сервером!");
    });
  }

  void showMessageDialog(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(message),
            actions: <Widget>[
              TextButton(
                child: const Text('Ок'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        });
  }

  Future<List<ListItem>> getItemsFromXml(BuildContext context) async {
    return xmlData.findAllElements("Valute").map((e) {
      return ListItem(
          e.findElements("CharCode").first.innerText,
          e.findElements("Name").first.innerText,
          e.findElements("VunitRate").first.innerText,
          e.findElements("Value").first.innerText);
    }).toList();
  }
}