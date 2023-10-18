import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task_flutter/list_item.dart';
import 'main_screen_state.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class MainScreenCubit extends Cubit<MainScreenState> {
  String _date = "";
  XmlDocument xmlData = XmlDocument();
  late Future<List<ListItem>> xmlItems;
  late BuildContext context;

  MainScreenCubit(this.context) : super(MainScreenInitial()) {
    _getXmlData();
    xmlItems = _getItemsFromXml(context);

    emit(MainScreenUpdated());
  }

  // Future<void> pullRefresh() async {
  //   _getXmlData();
  // }

  void _setDateOfUpdate(XmlDocument xml) {
    _date = 'Дата обновления: ${xml.getElement('ValCurs')!.getAttribute('Date')}';
  }

  String get date => _date;

  void _getXmlData() {
    http.get(Uri.http('www.cbr-xml-daily.ru', 'daily_utf8.xml')).then((res) {
      if (xmlData.toString() == utf8.decode(res.bodyBytes)) {
        showMessageDialog('Курс валют актуальный, обновление не требуется.');
      } else {
        xmlData = XmlDocument.parse(utf8.decode(res.bodyBytes));
        _setDateOfUpdate(xmlData);
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

  Future<List<ListItem>> _getItemsFromXml(BuildContext context) async {
    return xmlData.findAllElements("Valute").map((e) {
      return ListItem(
          e.findElements("CharCode").first.innerText,
          e.findElements("Name").first.innerText,
          e.findElements("VunitRate").first.innerText,
          e.findElements("Value").first.innerText);
    }).toList();
  }
}