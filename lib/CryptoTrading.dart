import 'dart:convert';
import 'dart:math';
import 'CryptoSell.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ExchAccCash.dart';
import 'globals.dart' as globals;
import 'package:http/http.dart' as http;
import 'Service.dart';
import 'CryptoChart.dart';
import 'CryptoBuy.dart';

final _btcUrl = 'https://api.binance.com/api/v3/ticker/24hr?symbol=BTCUSDT';

class CryptoTrading extends StatefulWidget {
  @override
  _CryptoTradingState createState() => _CryptoTradingState();
}

class _CryptoTradingState extends State<CryptoTrading> {
  double ask = 0, bid = 0;
  List<String> exchHistory = [];
  List<double> exchAskHistory = [];
  final _exchRefreshDur = Duration(seconds: 10);
  List<CryptoChartData> data = [];
  int maxCryptoLength = 20;
  double startAsk = 500;

  @override
  void initState() {
    print('got globals st ${globals.currentState}');
    super.initState();
    var rng = new Random();
    maxCryptoLength = rng.nextInt(maxCryptoLength)+1;
    _startUpdtAsk();
    globals.addMsgToHistory('Вы зашли на биржу криптовалют. maxCryptoLength $maxCryptoLength');
  }

  _startUpdtAsk() async {
    print('_start _startUpdtAsk');

    var value = await http.get(_btcUrl);

    if (value.statusCode != 200) {
      await showAlertPage(context, 'Криптобиржа сегодня не работает(');
      Navigator.pop(context);
      return;
    }

    print('got ask val $value');

    double _ask = 0;

    try {
      var jv = jsonDecode(value.body);
      _ask = double.parse(jv['askPrice']);
    } catch (e) {
      print('got some err $e');
      await showAlertPage(context, 'Что-то не так с сервером биржи. \n$e');
    }

    if (_ask > 0) {
      startAsk = _myNormalizator(_ask);
    }
    print('got startAsk $startAsk');

    _updtExch();
  }

  _updtExch() async {
    print('_updtExch');

    var rng = new Random();
    int _percentChange = rng.nextInt(10)-5;
    ask = startAsk*(1+_percentChange/100);
    print('got % $_percentChange ask $ask');
    bid = ask * 0.99;

    DateTime dt = DateTime.now();
    String timeNow = _add0str(dt.hour) +
        ':' +
        _add0str(dt.minute) +
        ':' +
        _add0str(dt.second);
    exchHistory.add(timeNow +
        ' / ' +
        ask.toStringAsFixed(2) +
        ' / ' +
        bid.toStringAsFixed(2));
    exchAskHistory.add(ask);

    data.add(CryptoChartData(timeNow, ask));
    if (data.length > maxCryptoLength) {
      //data.removeAt(0);
      await showAlertPage(
          context, 'Извините, криптобиржа закрывается. Приходите завтра!');
      Navigator.pop(context);
      if (Navigator.of(context).canPop()){
        print('can pop - pop');
        Navigator.pop(context);
      }
      //Navigator.of(context).pushNamedAndRemoveUntil('/', ModalRoute.withName('/'));
      return;
    }
    globals.ask = ask;
    globals.askWithNotif.value = ask;

    setState(() {});
    Future.delayed(_exchRefreshDur, _updtExch);
  }

  _add0str(int n) {
    return n > 9 ? '$n' : '0$n';
  }

  _myNormalizator(_sum) {
    //double _rest = (_sum ~/ 1) / 10;
    int _th = _sum ~/ 1000;
    double _rest = _sum - _th * 1000;
    if (globals.ask != null && globals.ask > _rest) {
      double delta = globals.ask - _rest;
      if (delta / globals.ask > 0.6) {
        print('correct _rest from $_rest to ${_rest + 1000}');
        _rest += 1000;
      } else if (delta / globals.ask < -0.6) {
        print('correct _rest to ${globals.ask}');
        _rest = globals.ask;
      }
    }
    //int newTh = _th ~/ 10;
    //double newSum = newTh * 1000 + _rest;
    //print('th $_th rest $_rest newTh $newTh newSum $newSum');
    return _rest;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Криптобиржа'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Кошелёк: ${globals.currentState.moneyOnHand}   ',
                  textScaleFactor: 1.3,
                ),
                /*
                FloatingActionButton(
                  heroTag: 'exch1',
                  backgroundColor: Colors.green,
                  onPressed: _exchAccCash,
                  tooltip: 'Обмен крипты',
                  child: Icon(Icons.sync_alt, size: 36,),
                ),

                 */
              ],
            ),
            SizedBox(
              height: 12,
            ),
            Text(
              'Денег на счету:',
              textScaleFactor: 1.4,
            ),
            SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${globals.currentState.moneyOnAccount}   ',
                  textScaleFactor: 1.5,
                ),
//                IconButton(
//                  color: Colors.blue,
//                  icon: Icon(Icons.sync_alt, size: 24,),
//                  onPressed: _exchAccCash,
//                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Крипта: ${globals.currentState.cryptOnHand}  ',
                      textScaleFactor: 1.5),
                ]),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  heroTag: 'exch3',
                  backgroundColor: Colors.green,
                  onPressed: _exchCryptoBuy,
                  tooltip: 'Покупка крипты',
                  child: Icon(
                    Icons.add,
                    size: 36,
                  ),
                ),
                SizedBox(
                  width: 25,
                ),
                FloatingActionButton(
                  heroTag: 'exch4',
                  backgroundColor: Colors.blue,
                  onPressed: _exchCryptoSell,
                  tooltip: 'Продажа крипты',
                  child: Icon(
                    Icons.remove,
                    size: 36,
                  ),
                ), // This trai
              ],
            ), // This trai
            SizedBox(
              height: 20,
            ),
            Container(
                padding: EdgeInsets.all(8),
                color: Colors.grey[200],
                child: Text('Курс крипты:', textScaleFactor: 1.5)),
            Expanded(
              child: Column(
                children: [
                  Text('  Время  /  Покупка  /  Продажа'),
                  Expanded(
                    child: Scrollbar(
                      child: ListView.builder(
                        //reverse: true,
                        itemCount: exchHistory.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              exchHistory[exchHistory.length - index - 1],
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CryptoChart(data),
              ),
            ),
          ],
        ),
      ),
      /*
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: _exchAccCrypto,
        tooltip: 'Обмен крипты',
        child: Icon(Icons.shuffle, size: 36,),
      ),
       // This trailing comma makes auto-formatting nicer for build methods.
       */
    );
  }

  _exchCryptoBuy() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: CryptoBuy(),
          );
        });
    setState(() {});
    //Navigator.pop(context);
  }

  _exchCryptoSell() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: CryptoSell(),
          );
        });
    setState(() {});
    //Navigator.pop(context);
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
}
