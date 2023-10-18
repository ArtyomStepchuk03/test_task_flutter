import 'dart:convert';

import 'package:test_task_flutter/conversion.dart';

class ConversionHandler {
  static Map<String, dynamic> toMap(Conversion conversion) => {
    'startCurrency': conversion.startCurrency,
    'endCurrency': conversion.endCurrency,
    'startValue': conversion.startValue,
    'endValue': conversion.endValue,
    'dateAndTime': conversion.dateAndTime,
  };

  static String encode(List<Conversion> list) => json.encode(
    list.map<Map<String, dynamic>>(
            (item) => ConversionHandler.toMap(item)
    ).toList(),
  );

  ///foo
  static List<Conversion> decode(String string) =>
      (json.decode(string) as List<dynamic>)
          .map<Conversion>((item) => Conversion.fromJson(item))
          .toList();
}