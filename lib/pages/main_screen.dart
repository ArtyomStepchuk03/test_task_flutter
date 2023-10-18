import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:test_task_flutter/conversion.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_task_flutter/pages/cubit/main_screen_cubit.dart';
import 'package:test_task_flutter/pages/cubit/main_screen_state.dart';
import 'package:test_task_flutter/utils/conversion/conversion_handler.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;
import 'package:test_task_flutter/list_item.dart';

List<Conversion> conversionsHistory = [];
String dateOfUpdate = '';
var value = 0;
// XmlDocument xmlData = XmlDocument();

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainScreen();
  }
}

class _MainScreen extends State<MainScreen> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => MainScreenCubit(context),
    child: MaterialApp(
        home: RefreshIndicator(
          onRefresh: _pullRefresh,
          child: Scaffold(
              appBar: AppBar(title: const Text('Главная'),
                  actions: [
                    PopupMenuButton(
                        icon: const Icon(Icons.menu),
                        itemBuilder: (context) {
                          return [
                            const PopupMenuItem<int>(
                                value: 1,
                                child: Text("История операций")),
                            const PopupMenuItem<int>(
                              value: 0,
                              child: Text("О приложении"),
                            ),
                          ];
                        },
                        onSelected: (value) => _selectMenuItem(value))
                  ]),
              body: Column(
                children: [
                  Padding(padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                      child: Row(
                          children: [
                            BlocBuilder<MainScreenCubit, MainScreenState>(
                                builder: (context, state) {
                                  return Text(MainScreenCubit(context).date,
                                      style: const TextStyle(fontSize: 20)
                                  );
                                }
                            )
                          ]
                      )
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: MainScreenCubit(context).xmlItems,
                      builder: (context, data) {
                        if (data.hasData) {
                          List<ListItem>? list = data.data;

                          return ListView.builder(
                            itemCount: list?.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          String convertedValue = "";
                                          return AlertDialog(
                                            content: StatefulBuilder(
                                              builder: (BuildContext context, StateSetter setState) {
                                                return SizedBox(
                                                  width: 100,
                                                  height: 230,
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        list?[index].charCode,
                                                        style: const TextStyle(
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.bold),
                                                      ),
                                                      TextField(
                                                        maxLength: 30,
                                                        decoration: const InputDecoration(
                                                            border: UnderlineInputBorder(),
                                                            hintText: 'Введите сумму для конвертации'),
                                                        inputFormatters: [
                                                          TextInputFormatter.withFunction((oldValue, newValue) {
                                                            value = int.parse(newValue
                                                                .text.replaceAll(RegExp(r'[^0-9]'), ''));
                                                            return TextEditingValue(text: value.toString());
                                                          })
                                                        ],
                                                        keyboardType: TextInputType.number,
                                                      ),
                                                      const Padding(
                                                        padding: EdgeInsets.only(top: 10),
                                                        child: Text('RUB',
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                      Padding(
                                                          padding: const EdgeInsets.only(top: 10),
                                                          child: Text(convertedValue,
                                                            style: const TextStyle(fontSize: 25),
                                                          )
                                                      ),
                                                      Padding(
                                                          padding: const EdgeInsets.only(top: 10),
                                                          child: TextButton(
                                                            child: const Text('Конвертировать',
                                                                style: TextStyle(fontSize: 20)
                                                            ),
                                                            onPressed: () {
                                                              try {
                                                                setState(() => convertedValue = convert(value, double.parse(
                                                                    list![index].vunitRate
                                                                        .toString()
                                                                        .replaceAll(',', '.'))));
                                                                _addToHistory(list![index], convertedValue);
                                                              } catch (e) {
                                                                showMessageDialog('Ошибка конвертации!');
                                                              }
                                                            },
                                                          )),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        });
                                  },
                                  title: Text("${list?[index].name} (${list?[index].charCode}):",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: Text(list?[index].vunitRate,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ));
                            },
                          );
                        } else {
                          return const Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  )
                ],
              )),
        )));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // _loadData();
    // getXmlData();
  }

  void _addToHistory(ListItem item, value) {
    conversionsHistory.insert(0,
        Conversion(
            item.charCode.toString(),
            "RUB",
            item.value.toString().replaceAll(',', '.'),
            value,
            DateFormat("dd.MM.yyyy HH:mm").format(DateTime.now())));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _saveData();
  }

  void _setDateOfUpdate(XmlDocument xml) {
    setState(() => dateOfUpdate =
    'Дата обновления: ${xml.getElement('ValCurs')!.getAttribute('Date')}');
  }

  // void getXmlData() {
  //   http.get(Uri.http('www.cbr-xml-daily.ru', 'daily_utf8.xml')).then((res) {
  //     if (xmlData.toString() == utf8.decode(res.bodyBytes)) {
  //       showMessageDialog('Курс валют актуальный, обновление не требуется.');
  //       return;
  //     }
  //     setState(() {
  //       xmlData = XmlDocument.parse(utf8.decode(res.bodyBytes));
  //       _setDateOfUpdate(xmlData);
  //     });
  //   }).catchError((e) {
  //     showMessageDialog("Отсутствует соединение с сервером!");
  //   });
  // }

  Future<void> _pullRefresh() async {
    // setState(() => getXmlData());
  }
  //
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

  // Future<List<ListItem>> _getItemsFromXml(BuildContext context) async {
  //   return xmlData.findAllElements("Valute").map((e) {
  //     return ListItem(
  //         e.findElements("CharCode").first.innerText,
  //         e.findElements("Name").first.innerText,
  //         e.findElements("VunitRate").first.innerText,
  //         e.findElements("Value").first.innerText);
  //   }).toList();
  // }

  void _selectMenuItem(int value) {
    switch (value) {
      case 0:
        Navigator.pushNamed(context, '/about-app');
        break;
      case 1:
        Navigator.pushNamed(context, '/history');
        break;
    }
  }

  Future<void> _loadData() async {
    SharedPreferences.getInstance().then((prefs) =>
    conversionsHistory = ConversionHandler.decode(prefs.getString('conversions') ?? ""));
  }

  Future<void> _saveData() async {
    SharedPreferences.getInstance().then((prefs) =>
        prefs.setString('conversions', ConversionHandler.encode(conversionsHistory)));
  }
}

@visibleForTesting
String convert(int value, double vunitRate) {
  try {
    if(value < 0 || vunitRate < 0) throw Exception("Values should be greater then 0");
    return (value * vunitRate).toStringAsFixed(4);
  } catch (e) {
    return "0";
  }
}