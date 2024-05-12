class ExpenseEntryMainModel{
  String _date,_time,_amount,_method,_category,_note;

  ExpenseEntryMainModel(this._date, this._time, this._amount, this._method,
      this._category, this._note);

  get note => _note;

  set note(value) {
    _note = value;
  }

  get category => _category;

  set category(value) {
    _category = value;
  }

  get method => _method;

  set method(value) {
    _method = value;
  }

  get amount => _amount;

  set amount(value) {
    _amount = value;
  }

  get time => _time;

  set time(value) {
    _time = value;
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }
}