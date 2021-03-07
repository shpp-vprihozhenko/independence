import 'Service.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;

class ExchAccCash extends StatefulWidget {
  @override
  _ExchAccCashState createState() => _ExchAccCashState();
}

class _ExchAccCashState extends State<ExchAccCash> {
  TextEditingController _tec = TextEditingController();
  int _transferSum = 0;

  @override
  void initState() {
    _tec.text = '1000';
    print('got globals st ${globals.currentState}');
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
                'Трансфер денег',
                textScaleFactor: 1.7,
                textAlign: TextAlign.center,
              )),
          SizedBox(height: 10),
          Text(
            'Кошелёк: ${globals.currentState.moneyOnHand}   ',
            textScaleFactor: 1.5,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(labelText: 'Сумма'),
                  controller: _tec,
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 10),
              IconButton(
                  icon: Icon(Icons.arrow_downward),
                  onPressed: () {
                    int _sum = 0;
                    try {
                      _sum = int.parse(_tec.text);
                    } catch (e) {}
                    if (_sum > globals.currentState.moneyOnHand) {
                      _sum = globals.currentState.moneyOnHand;
                    }
                    globals.currentState.moneyOnHand -= _sum;
                    globals.currentState.moneyOnAccount += _sum;
                    _transferSum += _sum;
                    setState(() {});
                  }),
              SizedBox(width: 10),
              IconButton(
                  icon: Icon(Icons.arrow_upward),
                  onPressed: () {
                    int _sum = 0;
                    try {
                      _sum = int.parse(_tec.text);
                    } catch (e) {}
                    if (_sum > globals.currentState.moneyOnAccount) {
                      _sum = globals.currentState.moneyOnAccount;
                    }
                    globals.currentState.moneyOnHand += _sum;
                    globals.currentState.moneyOnAccount -= _sum;
                    _transferSum -= _sum;
                    setState(() {});
                  }),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'Счет: ${globals.currentState.moneyOnAccount}   ',
            textScaleFactor: 1.5,
          ),
          SizedBox(
            height: 20,
          ),
          FloatingActionButton(
              child: Icon(Icons.done),
              onPressed: () async {
                await showAlertPage(
                    context,
                    _transferSum > 0
                        ? 'Вы переместили из кошелька на счёт $_transferSum'
                        : 'Вы переместили со счёта в кошелёк $_transferSum');
                Navigator.pop(context);
              })
        ],
      ),
    );
  }
}
