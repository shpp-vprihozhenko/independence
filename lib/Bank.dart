import 'package:flutter/material.dart';
import 'DataClasses.dart';
import 'ExchAccCash.dart';
import 'globals.dart' as globals;
import 'Service.dart';

class Bank extends StatefulWidget {
  @override
  _BankState createState() => _BankState();
}

class _BankState extends State<Bank> {
  @override
  void initState() {
    globals.addMsgToHistory('Вы зашли в Банк!');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Банк"),
      ),
      body: SafeArea(
        child: Center(
          child: ListView(shrinkWrap: true, children: [
            Image.asset(
              'assets/BANK.jpg',
              width: 222,
              height: 222,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Денег в кошельке: ${globals.currentState.moneyOnHand}',
              textScaleFactor: 1.6,
              textAlign: TextAlign.center,
            ),
            Text(
              'Денег на счету: ${globals.currentState.moneyOnAccount}',
              textScaleFactor: 1.6,
              textAlign: TextAlign.center,
            ),
            Text(
              'Депозиты:',
              textScaleFactor: 1.6,
              textAlign: TextAlign.center,
            ),
            _depCredW(0),
            Text(
              'Кредиты:',
              textScaleFactor: 1.6,
              textAlign: TextAlign.center,
            ),
            _depCredW(1),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      width: 300,
                      child: FlatButton(
                        color: Colors.blueAccent,
                        textColor: Colors.white,
                        onPressed: _exchAccCash,
                        child: Text(
                          'Трансфер кошелёк-счёт',
                          textScaleFactor: 1.2,
                        ),
                      ),
                    ),
                    Container(
                      width: 300,
                      child: FlatButton(
                        color: Colors.blueAccent,
                        textColor: Colors.white,
                        onPressed: globals.currentState.moneyOnAccount == 0
                            ? null
                            : _putMoneyToDeposit,
                        child: Text(
                          'Депозит (${globals.curMonthBankDepositPercent.toStringAsFixed(1)} %/мес.)',
                          textScaleFactor: 1.3,
                        ),
                      ),
                    ),
                    Container(
                      width: 300,
                      child: FlatButton(
                        color: Colors.blueAccent,
                        textColor: Colors.white,
                        onPressed: _getMoneyAsCredit,
                        child: Text(
                          'Кредит (${globals.curMonthBankCreditPercent.toStringAsFixed(1)} %/мес.)',
                          textScaleFactor: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Widget _depCredW(_mode) {
    List<Widget> _res = [];
    if (_mode == 0) {
      for (int idx = 0; idx < globals.currentState.deposits.length; idx++) {
        MoneyOperation _mo = globals.currentState.deposits[idx];
        //for (MoneyOperation _mo in globals.currentState.deposits) {
        _res.add(Row(
          children: [
            Expanded(
                child: Text(
              '$_mo',
              textScaleFactor: 1.6,
              textAlign: TextAlign.center,
            )),
            CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _breakDep(idx);
                  }),
            )
          ],
        ));
      }
    } else {
      for (MoneyOperation _mo in globals.currentState.credits) {
        _res.add(Row(
          children: [
            Expanded(
                child: Text(
              '$_mo',
              textScaleFactor: 1.6,
              textAlign: TextAlign.center,
            )),
          ],
        ));
      }
    }
    return Column(
      children: _res,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
    );
  }

  _breakDep(_idx) async {
    bool _res = await askYesNoPage(context,
        'Разорвать договор депозита?\nУчтите, проценты по вкладу будут утеряны.');
    if (_res) {
      print('breake  $_idx');
      int _sum = globals.currentState.deposits[_idx].sum.toInt();
      globals.currentState.deposits.removeAt(_idx);
      globals.currentState.moneyOnAccount += _sum;
      setState(() {});
    }
  }

  _exchAccCash() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: ExchAccCash(),
          );
        });
    setState(() {});
  }

  _putMoneyToDeposit() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: PutMoneyToDeposit(),
          );
        });
    setState(() {});
  }

  _getMoneyAsCredit() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: GetMoneyAsCredit(),
          );
        });
    setState(() {});
  }
}

//----------------------------------------------------------------

class PutMoneyToDeposit extends StatefulWidget {
  @override
  _PutMoneyToDepositState createState() => _PutMoneyToDepositState();
}

class _PutMoneyToDepositState extends State<PutMoneyToDeposit> {
  TextEditingController _tec = TextEditingController();
  int months = 1;

  @override
  void initState() {
    _tec.text = '1000';
    super.initState();
  }

  @override
  void dispose() {
    _tec.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              padding: EdgeInsets.all(20),
              color: Colors.grey[200],
              child: Text(
                'Деньги на депозит',
                textScaleFactor: 1.6,
                textAlign: TextAlign.center,
              )),
          SizedBox(height: 10),
          Text(
            'Есть на счету: ${globals.currentState.moneyOnAccount}',
            textScaleFactor: 1.5,
          ),
          Text(
            '% по вкладу: ${globals.curMonthBankDepositPercent}',
            textScaleFactor: 1.5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                  maxLength: 10,
                  decoration: InputDecoration(labelText: 'Ложим сумму:'),
                  controller: _tec,
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 10),
              IconButton(
                  icon: Icon(Icons.arrow_downward),
                  onPressed: () {
                    int _s = int.parse(_tec.text);
                    if (_s > 1000) {
                      _s -= 1000;
                    }
                    _tec.text = _s.toString();
                    setState(() {});
                  }),
              SizedBox(width: 10),
              IconButton(
                  icon: Icon(Icons.arrow_upward),
                  onPressed: () {
                    int _s = int.parse(_tec.text);
                    _s += 1000;
                    if (_s > globals.currentState.moneyOnAccount) {
                      _s = globals.currentState.moneyOnAccount;
                    }
                    _tec.text = _s.toString();
                    setState(() {});
                  }),
            ],
          ),
          Text('На срок:'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              IconButton(
                  icon: Icon(Icons.arrow_downward),
                  onPressed: () {
                    if (months > 1) {
                      months--;
                    }
                    setState(() {});
                  }),
              Text(
                '$months мес.',
                textScaleFactor: 1.5,
              ),
              IconButton(
                  icon: Icon(Icons.arrow_upward),
                  onPressed: () {
                    months++;
                    setState(() {});
                  }),
            ],
          ),
          SizedBox(height: 10),
          FloatingActionButton(
              child: Icon(Icons.done),
              onPressed: () async {
                int _sum = int.parse(_tec.text);
                if (_sum > 0) {
                  MoneyOperation _mo = MoneyOperation(_sum.toDouble(),
                      globals.curMonthBankDepositPercent, months);
                  globals.currentState.moneyOnAccount -= _sum;
                  globals.currentState.deposits.add(_mo);
                  await showAlertPage(
                      context, 'Вы положили на депозит $_sum на $months мес.');
                }
                Navigator.pop(context);
              })
        ],
      ),
    );
  }
}

//----------------------------------------------------------------

class GetMoneyAsCredit extends StatefulWidget {
  @override
  _GetMoneyAsCreditState createState() => _GetMoneyAsCreditState();
}

class _GetMoneyAsCreditState extends State<GetMoneyAsCredit> {
  TextEditingController _tec = TextEditingController();
  int months = 1;

  @override
  void initState() {
    _tec.text = '0';
    super.initState();
  }

  @override
  void dispose() {
    _tec.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              padding: EdgeInsets.all(20),
              color: Colors.grey[200],
              child: Text('Взять кредит', textScaleFactor: 1.6)),
          SizedBox(height: 10),
          Text(
            'Есть на счету: ${globals.currentState.moneyOnAccount}',
            textScaleFactor: 1.5,
          ),
          Text(
            '% по кредиту: ${globals.curMonthBankCreditPercent.toStringAsFixed(1)}',
            textScaleFactor: 1.5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextField(
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                  maxLength: 10,
                  decoration: InputDecoration(labelText: 'Просим сумму:'),
                  controller: _tec,
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 10),
              IconButton(
                  icon: Icon(Icons.arrow_downward),
                  onPressed: () {
                    int _s = int.parse(_tec.text);
                    if (_s > 1000) {
                      _s -= 1000;
                    }
                    _tec.text = _s.toString();
                    setState(() {});
                  }),
              SizedBox(width: 10),
              IconButton(
                  icon: Icon(Icons.arrow_upward),
                  onPressed: () {
                    int _s = int.parse(_tec.text);
                    _s += 1000;
                    int _freeAccMoney =
                        globals.currentState.moneyOnAccount - _allCreditsSum();
                    if (_s > _freeAccMoney) {
                      _s = _freeAccMoney;
                    }
                    if (_s < 0) {
                      _s = 0;
                    }
                    _tec.text = _s.toString();
                    setState(() {});
                  }),
            ],
          ),
          Text('На срок:'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              IconButton(
                  icon: Icon(Icons.arrow_downward),
                  onPressed: () {
                    if (months > 1) {
                      months--;
                    }
                    setState(() {});
                  }),
              Text(
                '$months мес.',
                textScaleFactor: 1.5,
              ),
              IconButton(
                  icon: Icon(Icons.arrow_upward),
                  onPressed: () {
                    if (months < 12) {
                      months++;
                      setState(() {});
                    }
                  }),
            ],
          ),
          SizedBox(height: 10),
          FloatingActionButton(
              child: Icon(Icons.done),
              onPressed: () async {
                int _sum = int.parse(_tec.text);
                if (_sum > 0) {
                  MoneyOperation _mo = MoneyOperation(_sum.toDouble(),
                      globals.curMonthBankCreditPercent, months);
                  globals.currentState.moneyOnAccount += _sum;
                  globals.currentState.credits.add(_mo);
                  await showAlertPage(
                      context, 'Вам дали кредит $_sum на $months мес.');
                }
                Navigator.pop(context);
              })
        ],
      ),
    );
  }

  _allCreditsSum() {
    int _sumC = 0;
    globals.currentState.credits.forEach((mo) {
      _sumC += mo.sum.toInt();
    });
    return _sumC * 2;
  }
}
