class CategoryMainModel{
  int _categoryId;
  String _category;

  CategoryMainModel(this._categoryId, this._category);

  String get category => _category;

  set category(String value) {
    _category = value;
  }

  int get categoryId => _categoryId;

  set categoryId(int value) {
    _categoryId = value;
  }
}