import 'dart:convert';

class Conversion {
  final String _startCurrency, _endCurrency, _dateAndTime, _startValue, _endValue;

  Conversion(this._startCurrency, this._endCurrency, this._startValue,
      this._endValue, this._dateAndTime);

  get endValue => _endValue;

  get startValue => _startValue;

  get endCurrency => _endCurrency;

  get startCurrency => _startCurrency;

  get dateAndTime => _dateAndTime;

  factory Conversion.fromJson(Map<String, dynamic> json) {
    return Conversion(json["startCurrency"], json["endCurrency"], json["startValue"], json["endValue"], json["dateAndTime"]);
  }

  static Map<String, dynamic> toMap(Conversion conversion) => {
    'startCurrency': conversion.startCurrency,
    'endCurrency': conversion.endCurrency,
    'startValue': conversion.startValue,
    'endValue': conversion.endValue,
    'dateAndTime': conversion.dateAndTime,
  };

  static String encode(List<Conversion> list) => json.encode(
    list.map<Map<String, dynamic>>(
            (item) => Conversion.toMap(item)
    ).toList(),
  );

  static List<Conversion> decode(String string) =>
      (json.decode(string) as List<dynamic>)
          .map<Conversion>((item) => Conversion.fromJson(item))
          .toList();
}