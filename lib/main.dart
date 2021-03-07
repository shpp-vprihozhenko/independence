import 'dart:math';
import 'Roulette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'About.dart';
import 'Bank.dart';
import 'CryptoTrading.dart';
import 'DataClasses.dart';
import 'Service.dart';
import 'Study.dart';
import 'Work.dart';
import 'History.dart';
import 'globals.dart' as globals;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Независимость',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Независимость'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int startMoney = 10000;
  CurrentState currentState;
  bool userInteraction = false;
  bool gameStarted = false;
  final int refreshPeriodSec = 1;
  int refreshPeriodMult = 1;
  List<Expense> dailyExpenses = [];
  List<Expense> monthlyExpenses = [];
  double lastSalary = 0;
  String _aboutText = '';
  bool _alreadyShowNoMoneyMsg = false;
  int _cRndEvDays = 25;
  List<Expense> monthlyIncoming = [];
  List<Expense> monthlyOutcoming = [];

  getTextFromAssets() async {
    _aboutText = await rootBundle.loadString('assets/new.txt');
    print(_aboutText);
  }

  @override
  void initState() {
    //getTextFromAssets();
    super.initState();
    setNewGameParameters();
  }

  setNewGameParameters() {
    currentState = CurrentState(DateTime.now(), startMoney);
    globals.currentState = currentState;
    dailyExpenses.clear();
    dailyExpenses.add(Expense('Питание', 10));
    monthlyExpenses.clear();
    monthlyExpenses.add(Expense('Жильё', 1000));
    _setNewMonthlyPercents();
  }

  _setNewMonthlyPercents() {
    var rng = new Random();
    globals.curMonthBankDepositPercent = rng.nextInt(100) / 10;
    globals.curMonthBankCreditPercent =
        globals.curMonthBankDepositPercent + rng.nextInt(20) / 10;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Сегодня ' + globals.dateRus(currentState.date),
              textScaleFactor: 1.7,
            ),
            Text(
              'Денег в кошельке: ${currentState.moneyOnHand}',
              textScaleFactor: 1.6,
            ),
            Text(
              'Денег на счету: ${currentState.moneyOnAccount}',
              textScaleFactor: 1.6,
            ),
            Text(
              'Здоровье: ${currentState.healthLevel.toStringAsFixed(1)}%',
              textScaleFactor: 1.6,
            ),
            Text(
              'Работа: ${currentState.workingState()}',
              textScaleFactor: 1.6,
            ),
            globals.currentState.workHours == 0
                ? SizedBox()
                : Text(
                    'Зарплата: ${globals.currentState.salary}',
                    textScaleFactor: 1.6,
                  ),
            Text(
              'Тек. заработок: ${globals.currentState.curSalary.toStringAsFixed(1)}',
              textScaleFactor: 1.6,
            ),
            Text(
              'Опыт: ${currentState.experienceLevel}',
              textScaleFactor: 1.6,
            ),
            Text(
              'Образование: ${currentState.educationLevel.toStringAsFixed(2)}',
              textScaleFactor: 1.6,
            ),
            globals.currentState.studyHours == 0
                ? SizedBox()
                : Text(
                    'Учёба: ${globals.currentState.studyingState()}',
                    textScaleFactor: 1.6,
                  ),
            Text(
              'Свободное время: ${globals.currentState.freeHours} ч.',
              textScaleFactor: 1.6,
            ),
            SizedBox(
              height: 20,
            ),
            gameStarted
                ? SizedBox()
                : FlatButton(
                    onPressed: _startGame,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'СТАРТ',
                        textScaleFactor: 2,
                      ),
                    ),
                    color: Colors.lightBlueAccent,
                  ),
            FlatButton(
              child: Text(
                'Ежедневные расходы: ${_dailyExpenses()}',
                textScaleFactor: 1.6,
              ),
              onPressed: _showDailyExpenses,
            ),
            FlatButton(
              child: Text(
                'Ежемесячные расходы: ${_monthlyExpenses()}',
                textScaleFactor: 1.6,
              ),
              onPressed: _showMonthlyResult,
            ),
          ],
        ),
      ),
      floatingActionButton: (!gameStarted)
          ? FloatingActionButton(
              onPressed: _about,
              tooltip: 'о программе',
              child: Text('?', textScaleFactor: 2),
            )
          : _usualBtnLine(), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Row _usualBtnLine() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: 'h1',
          onPressed: _about,
          tooltip: 'о программе',
          child: Text('?', textScaleFactor: 2),
        ),
        SizedBox(
          width: 30,
        ),
        FloatingActionButton(
          heroTag: 'h2',
          onPressed: _showHistory,
          tooltip: 'история сообщений',
          child: Icon(
            Icons.history,
            size: 40,
          ),
        ),
        SizedBox(
          width: 30,
        ),
        FloatingActionButton(
          heroTag: 'h3',
          onPressed: _doSomething,
          tooltip: 'действие',
          child: Icon(
            Icons.language,
            size: 40,
          ),
        ),
      ],
    );
  }

  _showHistory() async {
    userInteraction = true;
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => History()));
    userInteraction = false;
  }

  _about() async {
    userInteraction = true;
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => About()));
    userInteraction = false;
  }

  _showDailyExpenses() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: Container(
                height: 150,
                width: 300,
                child: ListView(
                  children: _listDailyExpenses(),
                ),
              ),
            ));
  }

  _showMonthlyResult() async {
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: Container(
                height: 300,
                width: 300,
                child: ListView(
                  children: _listMonthlyExpenses(),
                ),
              ),
            ));
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: Container(
                height: 300,
                width: 300,
                child: ListView(
                  children: _formListMothlyRes(),
                ),
              ),
            ));
  }

  Map<String, int> _findActives() {
    Map<String, int> _res = {};
    _res['Кошелёк'] = globals.currentState.moneyOnHand;
    _res['Счёт'] = globals.currentState.moneyOnAccount;
    globals.currentState.deposits.forEach((element) {
      _res['Депозит до ${globals.dateRus(element.untilDate)}'] =
          element.sum.toInt();
    });
    double _crypt = globals.currentState.cryptOnHand;
    if (_crypt != null && _crypt > 0) {
      double _ask = globals.ask;
      if (_ask != null && _ask > 0) {
        _res['Крипта ($_crypt)'] =
            (globals.currentState.cryptOnHand * globals.ask).toInt();
      }
    }
    return _res;
  }

  Map<String, int> _findPassives() {
    Map<String, int> _res = {};
    globals.currentState.credits.forEach((element) {
      _res['Кредит до ${globals.dateRus(element.untilDate)}'] =
          element.sum.toInt();
    });
    return _res;
  }

  List<Widget> _formListMothlyRes() {
    List<Widget> res = [];
    res.add(Text(
      'Результат месяца:',
      textScaleFactor: 1.4,
    ));
    res.add(SizedBox(height: 20));
    res.add(Text(
      'Ваши активы:',
      textScaleFactor: 1.3,
      style: TextStyle(color: Colors.blue),
    ));
    Map<String, int> actives = _findActives();
    int totalActives = 0;
    actives.forEach((k, v) {
      totalActives += v;
      res.add(Text(
        ' $k = $v',
        style: TextStyle(color: Colors.blue),
      ));
    });
    res.add(Text(
      'Всего активы: $totalActives',
      textScaleFactor: 1.2,
      style: TextStyle(color: Colors.blue),
    ));
    res.add(SizedBox(height: 20));
    res.add(Text(
      'Ваши пассивы:',
      textScaleFactor: 1.3,
      style: TextStyle(color: Colors.red),
    ));
    Map<String, int> passives = _findPassives();
    int totalPassives = 0;
    passives.forEach((k, v) {
      totalPassives += v;
      res.add(Text(
        ' $k = $v',
        style: TextStyle(color: Colors.red),
      ));
    });
    res.add(Text(
      'Всего вы должны: $totalPassives',
      textScaleFactor: 1.2,
      style: TextStyle(color: Colors.red),
    ));
    print('a tot $totalActives / $totalPassives /p $passives');
    int saldo = totalActives - totalPassives;
    res.add(SizedBox(height: 20));
    res.add(Text(
      'Общий итог: $saldo',
      textScaleFactor: 1.4,
    ));
    res.add(SizedBox(height: 40));
    return res;
  }

  List<Widget> _listDailyExpenses() {
    List<Widget> l = [];
    l.add(Text(
      'Ежедневные расходы:',
      textScaleFactor: 1.5,
    ));
    l.add(SizedBox(height: 20));
    dailyExpenses.forEach((el) {
      l.add(Text(el.toString()));
    });
    return l;
  }

  List<Widget> _listMonthlyExpenses() {
    List<Widget> l = [];
    l.add(Text(
      'Завершился ${globals.dateRus(globals.currentState.date, true)}',
      textScaleFactor: 1.5,
      textAlign: TextAlign.center,
    ));
    l.add(Text(
      'Ежемесячный отчёт:',
      textScaleFactor: 1.5,
    ));
    l.add(SizedBox(height: 15));
    l.add(Text(
      'Расходы:',
      textScaleFactor: 1.5,
    ));
    l.add(SizedBox(height: 8));
    monthlyExpenses.forEach((el) {
      l.add(Text(
        el.toString(),
        textScaleFactor: 1.2,
      ));
    });
    l.add(SizedBox(height: 15));
    l.add(Text(
      'Доходы:',
      textScaleFactor: 1.5,
    ));
    l.add(SizedBox(height: 8));
    l.add(Text(
      'Зарплата: ${lastSalary.toStringAsFixed(1)}',
      textScaleFactor: 1.2,
    ));
    return l;
  }

  _startGame() {
    //await Navigator.push(context, MaterialPageRoute(builder: (context) => GoogleMapPage()));
    setNewGameParameters();
    gameStarted = true;
    userInteraction = false;
    Future.delayed(
        Duration(seconds: refreshPeriodSec * refreshPeriodMult), _incDate);
  }

  _releaseFromWork() {
    globals.currentState.vacancy = null;
    globals.currentState.salary = 0;
    globals.currentState.workHours = 0;
    globals.currentState.updateFreeHours();
    globals.currentState.releaseDT = null;
  }

  _incDate() async {
    if (!userInteraction) {
      userInteraction = true;
      currentState.date = currentState.date.add(Duration(days: 1));
      globals.currentState.lifeDaysCounter++;
      if (globals.currentState.lifeDaysCounter == 366) {
        await showAlertPage(
            context, 'Вау! Ты продержался целый год! Поздравляю!');
      }
      if (globals.currentState.releaseDT != null) {
        if (globals.datesAreEquals(
            currentState.date, globals.currentState.releaseDT)) {
          await showAlertPage(
              context, 'Ура! Наконец-то вас уволили. \nТеперь вы безработный!');
          _releaseFromWork();
        }
      }
      if (currentState.date.day == 1) {
        _setNewMonthlyPercents();
      }
      //print('inc date ${currentState.date}');
      await _makeDailyCalculations();
      int _numDaysPerMonth =
          DateTime(currentState.date.year, currentState.date.month + 1, 0).day;
      if (currentState.date.day == _numDaysPerMonth) {
        lastSalary = globals.currentState.curSalary;
        _makeMonthlyCalculations();
        await _showMonthlyResult();
      }
      if (currentState.moneyOnHand < 0 && currentState.moneyOnAccount > 0) {
        int _needSumCash = -currentState.moneyOnHand;
        int _courierServiceCost = 50;
        int _sumDecrAcc = (_needSumCash + _courierServiceCost).toInt();
        if (_sumDecrAcc <= currentState.moneyOnAccount) {
          currentState.moneyOnAccount -= _sumDecrAcc;
          currentState.moneyOnHand += _needSumCash;
          if (!_alreadyShowNoMoneyMsg) {
            await showAlertPage(context,
                'У вас внезапно кончилась наличка. \nКурьер банка по вашей просьбе привёз немного денег с вашего счёта. \nСтоимость услуг курьера - $_courierServiceCost');
            _alreadyShowNoMoneyMsg = true;
          }
        }
      } else {
        _alreadyShowNoMoneyMsg = false;
      }
      setState(() {});
      if (currentState.moneyOnHand < -1000) {
        await _showEndGameMsg();
        gameStarted = false;
        userInteraction = true;
      } else if (currentState.moneyOnHand < 0) {
        await showAlertPage(context,
            'У вас совсем нет наличных(\nЗнакомые пока ещё дают вам товары в долг, но долго это не продлится.\nРешите вопрос!');
      }
      if (globals.currentState.healthLevel <= 0) {
        await _showEndLifeMsg();
        gameStarted = false;
      }
      userInteraction = false;
    }
    Future.delayed(
        Duration(seconds: refreshPeriodSec * refreshPeriodMult), _incDate);
  }

  _showEndGameMsg() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: Container(
                height: 300,
                width: 300,
                child: ListView(children: [
                  Text(
                    'УВЫ, ВЫ ОБАНКРОТИЛИСЬ(',
                    textScaleFactor: 1.6,
                  ),
                  Text(
                    'Попросите помощи у родителей',
                    textScaleFactor: 1.5,
                  ),
                  Text('или идите собирать бутылки...', textScaleFactor: 1.5),
                ]),
              ),
            ));
  }

  _showEndLifeMsg() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: Container(
                height: 150,
                width: 300,
                child: ListView(children: [
                  Text(
                    'УВЫ, ВЫ НЕ УБЕРЕГДИ СЕБЯ(',
                    textScaleFactor: 1.6,
                  ),
                  Text(
                    'Ваше здоровье не позволяет вам больше работать',
                    textScaleFactor: 1.5,
                  ),
                  Text('Поживите лучше пока с родителями...',
                      textScaleFactor: 1.5),
                ]),
              ),
            ));
  }

  _makeMonthlyCalculations() async {
    monthlyExpenses.forEach((el) {
      currentState.moneyOnHand -= el.cost;
    });
    if (globals.currentState.curSalary > 0 &&
        globals.currentState.curSalary >= globals.currentState.salary * 0.9) {
      currentState.experienceLevel++;
      if (currentState.experienceLevel % 10 == 0) {
        //int salBefore = globals.currentState.salary;
        globals.currentState.salary =
            (globals.currentState.salary * 1.1).toInt();
        await showAlertPage(context,
            'Ваш стаж работы позволил увеличить вашу зарплату на 10%!\nНовая ставка ${globals.currentState.salary}');
      }
    }
    if (globals.currentState.healthLevel < 50) {
      await showAlertPage(context,
          'У вас очень слабое здоровье, вы очень часто болеете.\nРуководство снизило вам зарплату на 30%');
      globals.currentState.curSalary = globals.currentState.curSalary * 0.7;
    } else if (globals.currentState.healthLevel < 75) {
      await showAlertPage(context,
          'У вас слабое здоровье, вы часто болеете.\nРуководство снизило вам зарплату на 15%');
      globals.currentState.curSalary = globals.currentState.curSalary * 0.85;
    }
    if (globals.currentState.healthLevel < 90) {
      await showAlertPage(context,
          'У вас слабое здоровье, вы часто болеете.\nРуководство снизило вам зарплату на 7%');
      globals.currentState.curSalary = globals.currentState.curSalary * 0.93;
    }
    currentState.moneyOnHand += globals.currentState.curSalary.toInt();
    globals.currentState.curSalary = 0;
    setState(() {});
  }

  _checkForDailyRandomEvent() async {
    var rng = new Random();
    if (rng.nextInt(_cRndEvDays) == 1) {
      int _pos = rng.nextInt(globals.dailyRandomEvents.length);
      print('pos ev $_pos');
      globals.RandomEvent _ev = globals.dailyRandomEvents[_pos];
      int _sum = 0;
      String _msg = _ev.descr + '\n';
      if (_ev.sourceType == 'acc') {
        if (_ev.sum == 0) {
          _sum = globals.currentState.moneyOnAccount * _ev.percent ~/ 100;
        } else {
          _sum = _ev.sum;
        }
        if (_sum > 0) {
          _msg += 'На ваш счёт поступило $_sum';
        } else {
          _msg += 'С вашего счёта списано $_sum';
        }
        globals.currentState.moneyOnAccount += _sum;
      } else if (_ev.sourceType == 'cash') {
        if (_ev.sum == 0) {
          _sum = globals.currentState.moneyOnHand * _ev.percent ~/ 100;
        } else {
          _sum = _ev.sum;
        }
        if (_sum > 0) {
          _msg += 'Кошелёк пополнился на $_sum';
        } else {
          _msg += 'Вы потратили $_sum';
        }
        globals.currentState.moneyOnHand += _sum;
      } else {
        if (_ev.sum == 0) {
          _sum = (globals.currentState.moneyOnHand +
                  globals.currentState.moneyOnAccount) *
              _ev.percent ~/
              100;
        } else {
          _sum = _ev.sum;
        }
        if (_sum > 0) {
          _msg += 'Вы получили $_sum';
          globals.currentState.moneyOnHand += _sum;
        } else {
          _msg += 'Вы потратили $_sum';
          globals.currentState.moneyOnHand += _sum;
          if (globals.currentState.moneyOnHand < 0) {
            globals.currentState.moneyOnAccount +=
                globals.currentState.moneyOnHand;
            globals.currentState.moneyOnHand = 0;
            _msg += '\nЧасть суммы списана с вашего счёта.';
          }
        }
      }
      await showAlertPage(context, _msg);
    }
    setState(() {});
  }

  _makeDailyCalculations() async {
    await _checkForDailyRandomEvent();
    dailyExpenses.forEach((el) {
      currentState.moneyOnHand -= el.cost;
    });
    int _numDaysPerMonth =
        DateTime(currentState.date.year, currentState.date.month + 1, 0).day;
    if (globals.currentState.workHours > 0) {
      double dailySalary = globals.currentState.workHours /
          8 *
          globals.currentState.salary /
          _numDaysPerMonth;
      globals.currentState.curSalary += dailySalary;
    }
    if (globals.currentState.studyHours > 0) {
      int lastEducLevel = (globals.currentState.educationLevel).toInt();
      globals.currentState.educationLevel +=
          globals.currentState.studyHours / 8 / _numDaysPerMonth / 12;
      int newEducLevel = (globals.currentState.educationLevel).toInt();
      if (newEducLevel > lastEducLevel) {
        globals.currentState.salary =
            (globals.currentState.salary * 1.1).toInt();
        showAlertPage(context,
            'Ваш уровень образования позволил увеличить вашу зарплату на 10%!\nНовая ставка ${globals.currentState.salary}');
      }
    }
    await _checkDepositsAndCreditsSate();
    await _checkHealth();
    setState(() {});
  }

  _dailyExpenses() {
    int sum = 0;
    dailyExpenses.forEach((el) {
      sum += el.cost;
    });
    return sum;
  }

  _monthlyExpenses() {
    int sum = 0;
    monthlyExpenses.forEach((el) {
      sum += el.cost;
    });
    return sum;
  }

  _checkDepositsAndCreditsSate() async {
    for (int i = 0; i < globals.currentState.deposits.length; i++) {
      MoneyOperation _mo = globals.currentState.deposits[i];
      if (globals.datesAreEquals(_mo.untilDate, globals.currentState.date)) {
        double _sumPercents = _mo.sum * _mo.percent / 100 * _mo.months;
        globals.currentState.moneyOnAccount += (_sumPercents + _mo.sum).toInt();
        globals.currentState.deposits.removeAt(i);
        await showAlertPage(context,
            'Завершился срок депозита\n$_mo\nПолучен доход ${_sumPercents.toStringAsFixed(1)}');
      }
    }

    for (int i = 0; i < globals.currentState.credits.length; i++) {
      MoneyOperation _mo = globals.currentState.credits[i];
      if (globals.datesAreEquals(_mo.untilDate, globals.currentState.date)) {
        double _sumPercents = _mo.sum * _mo.percent / 100 * _mo.months;
        globals.currentState.moneyOnAccount -= (_sumPercents + _mo.sum).toInt();
        globals.currentState.credits.removeAt(i);
        await showAlertPage(context,
            'Погашен кредит\n$_mo\nУплачены % по кредиту ${_sumPercents.toStringAsFixed(1)}');
      }
    }
  }

  _checkHealth() async {
    if (globals.currentState.workHours + globals.currentState.studyHours > 12) {
      globals.currentState.healthLevel -= 0.1;
    } else if (globals.currentState.workHours +
            globals.currentState.studyHours <
        8) {
      globals.currentState.healthLevel += 0.1;
    }
  }

  _doSomething() {
    if (!userInteraction) {
      userInteraction = true;
      _chooseInteraction();
    } else {
      userInteraction = false;
      //_incDate();
    }
  }

  _chooseInteraction() async {
    var value = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Действие:',
                  textScaleFactor: 1.6,
                  style: TextStyle(color: Colors.blue),
                ),
                SizedBox(
                  height: 16,
                ),
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context, 'work');
                    },
                    child: Text(
                      'Работа',
                      textScaleFactor: 1.8,
                    )),
                SizedBox(
                  height: 16,
                ),
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context, 'study');
                    },
                    child: Text(
                      'Учёба',
                      textScaleFactor: 1.8,
                    )),
                SizedBox(
                  height: 16,
                ),
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context, 'bank');
                    },
                    child: Text(
                      'Банк',
                      textScaleFactor: 1.8,
                    )),
                SizedBox(
                  height: 16,
                ),
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context, 'crypto');
                    },
                    child: Text(
                      'Криптобиржа',
                      textScaleFactor: 1.8,
                    )),
                SizedBox(
                  height: 16,
                ),
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context, 'roulette');
                    },
                    child: Text(
                      'Казино',
                      textScaleFactor: 1.8,
                    )),
              ],
            ),
          );
        });
    print('got val $value');
    if (value == null) {
      userInteraction = false;
      return;
    }
    if (value == 'crypto') {
      if (globals.currentState.freeHours < 4) {
        await showAlertPage(
            context, 'Похоже, у вас не осталось времени на эти глупости...');
        return;
      }
      //userInteraction = false;
      //refreshPeriodMult = 10;
      await Navigator.push(
          context, MaterialPageRoute(builder: (context) => CryptoTrading()));
      //refreshPeriodMult = 1;
    } else if (value == 'work') {
      await Navigator.push(
          context, MaterialPageRoute(builder: (context) => Work()));
      print('got2 cur vac ${globals.currentState.vacancy}');
    } else if (value == 'study') {
      await Navigator.push(
          context, MaterialPageRoute(builder: (context) => Study()));
    } else if (value == 'roulette') {
      if (globals.currentState.freeHours < 4) {
        await showAlertPage(
            context, 'Похоже, у вас не осталось времени на эти глупости...');
        return;
      }
      await Navigator.push(
          context, MaterialPageRoute(builder: (context) => Roulette()));
    } else if (value == 'bank') {
      await Navigator.push(
          context, MaterialPageRoute(builder: (context) => Bank()));
    }

    userInteraction = false;
    setState(() {});
  }
}