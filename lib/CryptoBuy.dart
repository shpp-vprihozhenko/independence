import 'Service.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;

class CryptoBuy extends StatefulWidget {
  @override
  _CryptoBuyState createState() => _CryptoBuyState();
}

class _CryptoBuyState extends State<CryptoBuy> {
  TextEditingController _tec = TextEditingController();
  int accSum, sumForCrypto = 0;
  double cryptoSum;

  @override
  void initState() {
    print('got globals st ${globals.currentState}');
    accSum = globals.currentState.moneyOnAccount;
    cryptoSum = globals.currentState.cryptOnHand;
    _tec.text = '0';
    super.initState();
    globals.askWithNotif.addListener(_refresh);
  }

  _refresh() {
    double _sum = 0;
    try {
      _sum = double.parse(_tec.text);
    } catch (e) {}
    sumForCrypto = (_sum * globals.ask).toInt();
    print('refresh on ask change');
    setState(() {});
  }

  @override
  void dispose() {
    globals.askWithNotif.removeListener(_refresh);
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
            padding: EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Text(
              'Покупка крипты',
              textScaleFactor: 1.7,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Курс:',
                    textScaleFactor: 1.5,
                  ),
                  Text(
                    globals.ask == null
                        ? '-'
                        : 'Покупка: ${globals.ask.toStringAsFixed(2)}',
                    textScaleFactor: 1.5,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Счёт: $accSum   ',
            textScaleFactor: 1.4,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(labelText: 'Покупаю крипты'),
                  controller: _tec,
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(height: 10),
              IconButton(
                  icon: Icon(Icons.arrow_downward, color: Colors.blue),
                  onPressed: () {
                    double _sum = 0;
                    try {
                      _sum = double.parse(_tec.text);
                    } catch (e) {}
                    if (_sum > 1) {
                      _sum -= 1;
                      _tec.text = _sum.toString();
                      _refresh();
                    }
                  }),
              SizedBox(
                width: 10,
              ),
              IconButton(
                  icon: Icon(
                    Icons.arrow_upward,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    double _sum = 0;
                    try {
                      _sum = double.parse(_tec.text);
                    } catch (e) {}
                    _sum += 1;
                    _tec.text = _sum.toString();
                    _refresh();
                  }),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Затраты на покупку:',
            textScaleFactor: 1.3,
          ),
          Text(
            '$sumForCrypto',
            textScaleFactor: 1.5,
          ),
          SizedBox(
            height: 20,
          ),
          FloatingActionButton(child: Icon(Icons.done), onPressed: _ok),
        ],
      ),
    );
  }

  _ok() async {
    _refresh();
    if (sumForCrypto > globals.currentState.moneyOnAccount) {
      await showAlertPage(context, 'Не хватает денег.');
      return;
    }
    if (sumForCrypto == 0) {
      await showAlertPage(context, 'Неверная сумма при покупке крипты.');
      return;
    }
    try {
      double _sum = double.parse(_tec.text);
      globals.currentState.cryptOnHand += _sum;
      globals.currentState.moneyOnAccount -= sumForCrypto;
      await showAlertPage(context, 'Вы купили $_sum крипты за $sumForCrypto.');
    } catch (e) {}
    Navigator.pop(context);
  }
}
