import 'Service.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;

class ExchCrypto extends StatefulWidget {
  final double ask;
  ExchCrypto(this.ask);

  @override
  _ExchCryptoState createState() => _ExchCryptoState();
}

class _ExchCryptoState extends State<ExchCrypto> {
  TextEditingController _tec = TextEditingController();
  int accSum, sumForCrypto = 0;
  double cryptoSum;

  @override
  void initState() {
    print('got globals st ${globals.currentState}');
    accSum = globals.currentState.moneyOnAccount;
    cryptoSum = globals.currentState.cryptOnHand;
    _tec.text = '10';
    super.initState();
    globals.askWithNotif.addListener(_refresh);
  }

  _refresh() {
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
              'Торговля криптой',
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
                    'Покупка: ${globals.ask.toStringAsFixed(2)}',
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
                      sumForCrypto = (_sum * globals.ask).toInt();
                    }
                    setState(() {});
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
                    sumForCrypto = (_sum * globals.ask * 0.99).toInt();
                    setState(() {});
                  }),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Потратим на покупку:',
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
                if (accSum == 0) {
                  await showAlertPage(context, 'Неверная сумма при обмене.');
                  return;
                }
                globals.currentState.moneyOnAccount = accSum;
                globals.currentState.cryptOnHand = cryptoSum;
                Navigator.pop(context);
              })
        ],
      ),
    );
  }
}
