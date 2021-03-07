import 'Service.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;

class CryptoSell extends StatefulWidget {
  @override
  _CryptoSellState createState() => _CryptoSellState();
}

class _CryptoSellState extends State<CryptoSell> {
  TextEditingController _tec = TextEditingController();
  int accSum, sumForCrypto = 0;
  double cryptoSum;

  @override
  void initState() {
    print('got globals st ${globals.currentState}');
    accSum = globals.currentState.moneyOnAccount;
    cryptoSum = globals.currentState.cryptOnHand;
    _tec.text = globals.currentState.cryptOnHand.toString();
    super.initState();
    globals.askWithNotif.addListener(_refresh);
  }

  _countSumForCrypto() {
    double _sum = 0;
    try {
      _sum = double.parse(_tec.text) * globals.ask * 0.99;
    } catch (e) {}
    sumForCrypto = _sum.toInt();
  }

  _refresh() {
    print('refresh on ask change');
    _countSumForCrypto();
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
              'Продажа крипты',
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
                    'Продажа: ${(globals.ask * 0.99).toStringAsFixed(2)}',
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
            'Крипта: ${globals.currentState.cryptOnHand}   ',
            textScaleFactor: 1.4,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(labelText: 'продаю'),
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
                    if (_sum > globals.currentState.cryptOnHand) {
                      _sum = globals.currentState.cryptOnHand;
                    }
                    _tec.text = _sum.toString();
                    _refresh();
                  }),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Получим при продаже:',
            textScaleFactor: 1.3,
          ),
          Text(
            '$sumForCrypto',
            textScaleFactor: 1.5,
          ),
          SizedBox(
            height: 20,
          ),
          FloatingActionButton(
              child: Icon(Icons.done),
              onPressed: () async {
                double _sum = double.parse(_tec.text);
                _refresh();
                if (_sum == 0 || sumForCrypto == 0) {
                  await showAlertPage(
                      context, 'Неверная сумма при продаже крипты.');
                  return;
                }
                try {
                  globals.currentState.cryptOnHand -= _sum;
                  globals.currentState.moneyOnAccount += sumForCrypto;
                  await showAlertPage(
                      context, 'Вы продали $_sum крипты за $sumForCrypto');
                } catch (e) {}
                Navigator.pop(context);
              })
        ],
      ),
    );
  }
}
