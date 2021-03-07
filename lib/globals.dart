library my_prj.globals;

import 'package:flutter/foundation.dart';
import 'DataClasses.dart';

class Msg {
  DateTime dt;
  String txt;

  Msg(this.dt, this.txt);

  @override
  String toString() {
    return dateRus(dt) + ': ' + txt;
  }
}

List<Msg> msgsHistory = [];

addMsgToHistory(text) {
  msgsHistory.add(Msg(currentState.date, text));
}

class Vacancy {
  String name;
  int baseSalary;
  int baseChance;
  double eduMultiplier;
  double expMultiplier;
  double maxChance;

  Vacancy(this.name, this.baseSalary, this.baseChance, this.eduMultiplier,
      this.expMultiplier, this.maxChance);

  double getFullChance(currentState) {
    double _helthPoint = (100 - currentState.healthLevel) / 10;
    if (_helthPoint < 0) {
      _helthPoint = 0;
    }
    print('helthPoint for work chance $_helthPoint');
    double _chance = baseChance +
        eduMultiplier * (currentState.educationLevel - 11) * 10 +
        expMultiplier * currentState.experienceLevel -
        _helthPoint;
    print(
        'count chance for $name with baseChance $baseChance eduMultiplier $eduMultiplier expMultiplier $expMultiplier currentState.educationLevel ${currentState.educationLevel} currentState.experienceLevel ${currentState.experienceLevel}');
    if (_chance > maxChance) {
      _chance = maxChance;
    }
    return _chance;
  }

  @override
  String toString() {
    return name +
        ' sal. $baseSalary chance $baseChance eduM $eduMultiplier expM $expMultiplier';
  }
}

List<Vacancy> vacancies = [
  Vacancy('Дворник', 1400, 70, 0, 1, 100),
  Vacancy('Водитель', 1800, 30, 1, 1, 100),
  Vacancy('Менеджер', 2300, 4, 0.5, 0.5, 50),
  Vacancy('Директор', 5000, 1, 0.2, 0.2, 25)
];

class RandomEvent {
  String descr;
  String sourceType;
  int sum;
  int percent;

  RandomEvent(this.descr, this.sourceType, this.sum, this.percent);

  @override
  String toString() {
    return descr + ' from: ' + sourceType + ' sum $sum % $percent';
  }
}

List<RandomEvent> dailyRandomEvents = [
  RandomEvent('Упс... У вас украли бумажник', 'cash', 0, -100),
  RandomEvent('Упс. Хакеры взломали ваш счёт', 'acc', 0, -100),
  RandomEvent('Вы заболели, лечение требует средств', 'both', 0, -20),
  RandomEvent('Вы простыли, лечение требует средств', 'both', -200, 0),
  RandomEvent('У вас сломался телефон, требуется ремонт', 'both', -100, 0),
  RandomEvent('У вас сломался компьютер, требуется ремонт', 'both', -200, 0),
  RandomEvent(
      'У вас заболел зуб, требуются услуги стоматолога', 'both', -300, 0),
  RandomEvent('Вы нашли бумажник!', 'cash', 0, 10),
  RandomEvent('Вы выиграли в лотерею', 'cash', 5000, 0),
  RandomEvent('Вы получили наследство', 'cash', 0, 50),
  RandomEvent('У вас заболел дедушка.', 'cash', -200, 0),
  RandomEvent('Ваш ботинок порвался. Требуется ремонт.', 'cash', -70, 0),
  RandomEvent('Вы решили загулять', 'cash', -250, 0),
  RandomEvent(
      'У вас день рождения! Вам подарили немного денег.', 'cash', 1000, 0),
  RandomEvent('Вы решили сменить стиль. Расходы на одежду', 'cash', -550, 0),
  RandomEvent('Удачная сделка!', 'acc', 0, 30),
];

int lang = 0;
CurrentState currentState;
double ask;
ValueNotifier askWithNotif = ValueNotifier(0);
double curMonthBankDepositPercent = 0;
double curMonthBankCreditPercent = 0;

dateRus(DateTime date, [monthOnly = false]) {
  List<String> monthes = [
    'января',
    'февраля',
    'марта',
    'апреля',
    'мая',
    'июня',
    'июля',
    'августа',
    'сентября',
    'октября',
    'ноября',
    'декабря'
  ];
  if (monthOnly) {
    monthes = [
      'январь',
      'февраль',
      'март',
      'апрель',
      'май',
      'июнь',
      'июль',
      'август',
      'сентябрь',
      'октябрь',
      'ноябрь',
      'декабрь'
    ];
    return monthes[date.month - 1];
  }
  return '${date.day} ${monthes[date.month - 1]} ${date.year}';
}

String mRest(_m) {
  if (_m == 1) return '';
  if (_m < 5) return 'а';
  return 'ев';
}

bool datesAreEquals(DateTime _dt1, DateTime _dt2) {
  return (_dt1.year == _dt2.year &&
      _dt1.month == _dt2.month &&
      _dt1.day == _dt2.day);
}
