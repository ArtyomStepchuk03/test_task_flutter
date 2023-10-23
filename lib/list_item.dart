/// An object which contains information about currency.
/// The list of currencies in main screen is filled with this object.
class ListItem {
  final String _charCode, _name, _vunitRate, _value;

  ListItem(this._charCode, this._name, this._vunitRate, this._value);

  get charCode => _charCode;
  get name => _name;
  get vunitRate => _vunitRate;
  get value => _value;
}