import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:test_task_flutter/pages/cubit/main_screen_date_cubit.dart';
import 'main_screen_state.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';

class MainScreenCubit extends Cubit<MainScreenState> {
  BuildContext context;
  XmlDocument xmlData = XmlDocument();

  MainScreenCubit(this.context) : super(const MainScreenState()) {
    () async {
      await _getXmlData();
    };
  }

  factory MainScreenCubit.create(BuildContext context) {
    return MainScreenDateCubit(context);
    // switch(state) {
    //   case MainScreenDateState:
    //     return MainScreenCubit(context);
    // }
  }

  Future<void> _getXmlData() async {
    Response httpResponse = await http.get(Uri.http('www.cbr-xml-daily.ru', 'daily_utf8.xml'))
        .catchError((e) {
          showMessageDialog("Отсутствует соединение с сервером!");
        });
    await _openHttpResponse(httpResponse);
  }

  Future<void> _openHttpResponse(http.Response response) async {
    if (xmlData.toString() == utf8.decode(response.bodyBytes)) {
      showMessageDialog('Курс валют актуальный, обновление не требуется.');
    } else {
      xmlData = XmlDocument.parse(utf8.decode(response.bodyBytes));
      print("xmlData");
      print(xmlData);
    }
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
}

// class MainScreenCubit extends Cubit<MainScreenState> {
//   late Future<List<ListItem>> _xmlItems;
//   late BuildContext context;
//
//   MainScreenCubit(this.context) : super(MainScreenInitial()) {
//     _xmlItems = getItemsFromXml(context);
//   }
//
//   // Future<void> pullRefresh() async {
//   //   _getXmlData();
//   // }
//
//   String get date => _date;
//
//   Future<List<ListItem>> get xmlItems => _xmlItems;
//
//   void showMessageDialog(String message) {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text(message),
//             actions: <Widget>[
//               TextButton(
//                 child: const Text('Ок'),
//                 onPressed: () => Navigator.of(context).pop(),
//               ),
//             ],
//           );
//         });
//   }
//
//   Future<List<ListItem>> getItemsFromXml(BuildContext context) async {
//     return xmlData.findAllElements("Valute").map((e) {
//       return ListItem(
//           e.findElements("CharCode").first.innerText,
//           e.findElements("Name").first.innerText,
//           e.findElements("VunitRate").first.innerText,
//           e.findElements("Value").first.innerText);
//     }).toList();
//   }
// }

// class MainScreenListCubit extends MainScreenCubit {
//   MainScreenListCubit(super.context) {
//     _getXmlData();
//   }
//
//   void _getXmlData() {
//     print("_getXmlData");
//     http.get(Uri.http('www.cbr-xml-daily.ru', 'daily_utf8.xml')).then((res) {
//       print(state);
//       print("_getXmlDataHttp");
//       if (xmlData.toString() == utf8.decode(res.bodyBytes)) {
//         print("_getXmlDataHttpIF");
//         showMessageDialog('Курс валют актуальный, обновление не требуется.');
//         return;
//       } else {
//         print("_getXmlDataHttpELSE");
//         xmlData = XmlDocument.parse(utf8.decode(res.bodyBytes));
//
//         print(date);
//       }
//     }).catchError((e) {
//       showMessageDialog("Отсутствует соединение с сервером!");
//     });
//   }
// }