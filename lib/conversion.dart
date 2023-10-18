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
}