class Income {
  int id;
  String description;
  double amount;
  String date;
  String month;
  String year;
  Income(
      {this.id,
      this.date,
      this.description,
      this.amount,
      this.month,
      this.year});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["id"] = id;
    map["description"] = description;
    map["price"] = amount;
    map["date"] = date;
    map["month"] = month;
    map["year"] = year;
    return map;
  }
}
