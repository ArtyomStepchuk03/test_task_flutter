import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_task_flutter/pages/cubit/main_screen_cubit.dart';
import 'package:test_task_flutter/pages/cubit/main_screen_state.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;

class MainScreenDateCubit extends MainScreenCubit {
  late String _date;
  MainScreenDateCubit(super.context) {
    print("xmlDataMainScreenDateCubit");
    print(xmlData);
    createDateOfUpdate(xmlData);
    // emit(MainScreenDateState(_date));
  }

  void createDateOfUpdate(XmlDocument xml) async {
    print("_setDateOfUpdate");
    _date = 'Дата обновления: ${xml.getElement('ValCurs')!.getAttribute('Date')}';
    emit(MainScreenDateState(_date));
  }

  // void _getXmlData() async {
  //   print("_getXmlData");
  //   var httpResult = await http.get(Uri.http('www.cbr-xml-daily.ru', 'daily_utf8.xml'))
  //       .catchError((e) {
  //     showMessageDialog("Отсутствует соединение с сервером!");
  //   });
  //
  //   if (xmlData.toString() == utf8.decode(httpResult.bodyBytes)) {
  //     showMessageDialog('Курс валют актуальный, обновление не требуется.');
  //   } else {
  //     xmlData = XmlDocument.parse(utf8.decode(httpResult.bodyBytes));
  //     print("xmlData");
  //     print(xmlData);
  //   }

    // httpResult.then((result) {
    //   if (xmlData.toString() == utf8.decode(result.bodyBytes)) {
    //     showMessageDialog('Курс валют актуальный, обновление не требуется.');
    //     return;
    //   } else {
    //     xmlData = XmlDocument.parse(utf8.decode(result.bodyBytes));
    //     print("xmlData");
    //     print(xmlData);
    //   }
    // }).catchError((e) {
    //   showMessageDialog("Отсутствует соединение с сервером!");
    // });
  }

  // void showMessageDialog(String message) {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text(message),
  //           actions: <Widget>[
  //             TextButton(
  //               child: const Text('Ок'),
  //               onPressed: () => Navigator.of(context).pop(),
  //             ),
  //           ],
  //         );
  //       });
  // }
// }