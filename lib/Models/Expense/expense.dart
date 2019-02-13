class Expense {
  int id;
  String date;
  String item;
  double amount;
  String category;
  String year;
  Expense(
      {this.id, this.date, this.item, this.amount, this.category, this.year});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["id"] = id;
    map["date"] = date;
    map["item"] = item;
    map["price"] = amount;
    map["category"] = category;
    map["year"] = year;
    return map;
  }
}
