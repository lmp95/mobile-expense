import '../../Models/Income/income.dart';
import '../../Database/expense_db.dart';

List<Income> getMnthlyIncome() {
  DBProvider db = DBProvider();
  List<Income> incomeList = [];
  db.getMonthlyIncome().then((results) {
    for (var result in results) {
      var income = Income(
          id: result.id,
          amount: result.amount,
          description: result.description,
          date: result.date,
          month: result.month,
          year: result.year);
      incomeList.add(income);
    }
  });
  return incomeList;
}
