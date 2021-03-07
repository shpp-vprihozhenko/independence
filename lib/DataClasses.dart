import 'globals.dart' as globals;

class Expense {
  String name;
  int cost;

  Expense(this.name, this.cost);

  @override
  String toString() {
    return name + ' - ' + cost.toString();
  }
}

class Car {
  String name;
  int cost;

  Car(this.name, this.cost);

  @override
  String toString() {
    return name + ' - ' + cost.toString();
  }
}

class Estate {
  String name;
  int cost;

  Estate(this.name, this.cost);

  @override
  String toString() {
    return name + ' - ' + cost.toString();
  }
}

class MoneyOperation {
  double sum;
  double percent;
  int months;
  DateTime untilDate;

  MoneyOperation(this.sum, this.percent, this.months) {
    DateTime _now = globals.currentState.date;
    int _y = _now.year;
    int _m = _now.month;
    int _d = _now.day;
    _m += months;
    while (_m > 12) {
      _y++;
      _m -= 12;
    }
    untilDate = DateTime(_y, _m, _d);
    print('new mo mo sum $sum % $percent months $months until $untilDate');
  }

  @override
  String toString() {
    return 'Сумма: $sum, ${percent.toStringAsFixed(1)}%, $months мес.\n(до ${globals.dateRus(untilDate)})';
  }
}

class CurrentState {
  double healthLevel = 100;
  double experienceLevel = 0;
  double educationLevel = 11;
  DateTime date;
  int moneyOnHand;
  int moneyOnAccount = 0;
  List<Car> cars = [];
  List<Estate> estate = [];
  bool hasComputer = false;
  bool internetOn = false;
  double cryptOnHand = 0;
  int workHours = 0,
      studyHours = 0,
      sportHours = 0,
      sleepHours = 8,
      restHours = 0,
      freeHours = 16;
  int salary = 0;
  double curSalary = 0;
  globals.Vacancy vacancy;
  DateTime releaseDT;
  int lifeDaysCounter = 0;

  List<MoneyOperation> deposits = [];
  List<MoneyOperation> credits = [];

  CurrentState(this.date, this.moneyOnHand);

  updateFreeHours() {
    freeHours =
        24 - sleepHours - sportHours - workHours - studyHours - restHours;
    print('freeHours updated $freeHours');
  }

  workingState() {
    if (workHours == 8) {
      return 'полный день';
    } else if (workHours == 4) {
      return 'на полставки';
    } else if (workHours == 12) {
      return 'на полторы ставки';
    }
    return 'не работаешь';
  }

  studyingState() {
    if (studyHours == 8) {
      return 'очно весь день';
    } else if (studyHours == 4) {
      return 'заочно полдня';
    }
    return 'не учишься';
  }

  @override
  String toString() {
    print(
        'h $healthLevel ex $experienceLevel edu $educationLevel dt $date moneyOnHand $moneyOnHand moneyOnAcc $moneyOnAccount');
    return super.toString();
  }
}
