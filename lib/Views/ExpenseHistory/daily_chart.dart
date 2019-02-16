import '../../Models/Expense/expense.dart';
import '../../Database/expense_db.dart';

DBProvider db = DBProvider();
List<Expense> dataList = [];
var priceTotal = 0.0;

List<Expense> dailyChartFunction(List<Expense> _listExp) {
  dataList.clear();
  var clothingTotal = 0.0;
  var entertainmentTotal = 0.0;
  var foodTotal = 0.0;
  var giftsTotal = 0.0;
  var healthTotal = 0.0;
  var personalTotal = 0.0;
  var transTotal = 0.0;
  var utilitiesTotal = 0.0;
  var clothdata = _listExp.where((cate) => cate.category == "Clothing");
  var enterdata = _listExp.where((cate) => cate.category == "Entertainment");
  var fooddata = _listExp.where((cate) => cate.category == "Food");
  var giftsdata = _listExp.where((cate) => cate.category == "Gifts/Donations");
  var healthdata =
      _listExp.where((cate) => cate.category == "Medical/Healthcare");
  var personaldata = _listExp.where((cate) => cate.category == "Personal");
  var transdata = _listExp.where((cate) => cate.category == "Transportation");
  var utitilitiesdata = _listExp.where((cate) => cate.category == "Utilities");
  for (var item in clothdata) {
    clothingTotal += item.amount;
  }
  for (var item in enterdata) {
    entertainmentTotal += item.amount;
  }
  for (var item in fooddata) {
    foodTotal += item.amount;
  }
  for (var item in giftsdata) {
    giftsTotal += item.amount;
  }
  for (var item in healthdata) {
    healthTotal += item.amount;
  }
  for (var item in personaldata) {
    personalTotal += item.amount;
  }
  for (var item in transdata) {
    transTotal += item.amount;
  }
  for (var item in utitilitiesdata) {
    utilitiesTotal += item.amount;
  }
  return dataList = [
    Expense(category: "Clothing", amount: clothingTotal),
    Expense(category: "Entertainment", amount: entertainmentTotal),
    Expense(category: "Food", amount: foodTotal),
    Expense(category: "Gifts/Donations", amount: giftsTotal),
    Expense(category: "Medical/Healthcare", amount: healthTotal),
    Expense(category: "Personal", amount: personalTotal),
    Expense(category: "Transportation", amount: transTotal),
    Expense(category: "Utilities", amount: utilitiesTotal),
  ];
}
