class PassBookEntryMainModel{
  String _date,_time,_amount,_transaction_method,_total_balance, _category;

  PassBookEntryMainModel(this._date, this._time, this._amount, this._transaction_method, this._total_balance, this._category);

  get category => _category;

  set category(value) {
    _category = value;
  }

  get total_balance => _total_balance;

  set total_balance(value) {
    _total_balance = value;
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

  get transaction_method => _transaction_method;

  set transaction_method(value) {
    _transaction_method = value;
  }
}