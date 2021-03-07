import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Service.dart';
import 'globals.dart' as globals;

class Roulette extends StatefulWidget {
  @override
  _RouletteState createState() => _RouletteState();
}

class _RouletteState extends State<Roulette>
    with SingleTickerProviderStateMixin {
  int incSumOnHand;
  int maxBet = 50000;
  List<String> variants = [
    'Число (х35)',
    'Пара (х17)',
    'Трио (х11)',
    'Цвет (х2)',
    'Чёт / нечёт (x2)',
    'Low / Hi (x2)',
  ];
  int rotCounter = 0;
  int choose = 0;
  bool isOdd = true;
  int choosedNumber1 = 0, choosedNumber2 = 0, choosedNumber3 = 0;
  int sumOnHand = 0, sumSet = 0, sumWithProfit = 0;
  TextEditingController _tecSumSet = TextEditingController();
  TextEditingController _tecVar = TextEditingController();
  TextEditingController _tecN1 = TextEditingController();
  TextEditingController _tecN2 = TextEditingController();
  TextEditingController _tecN3 = TextEditingController();

  Animation<double> animation;
  AnimationController _acontroller;
  int _angle = 0;
  var scaleAnimation;

  @override
  void dispose() async {
    _tecN1.dispose();
    _tecN2.dispose();
    _tecN3.dispose();
    _tecVar.dispose();
    _tecSumSet.dispose();
    _acontroller.dispose();
    super.dispose();
  }

  _recalcProfit() {
    sumSet = 0;
    try {
      sumSet = int.parse(_tecSumSet.text);
    } catch (e) {}
    int _mult = 2;
    if (choose == 0) {
      _mult = 35;
    } else if (choose == 1) {
      _mult = 17;
    } else if (choose == 2) {
      _mult = 11;
    }
    sumWithProfit = sumSet * _mult;
    setState(() {});
  }

  @override
  void initState() {
    globals.addMsgToHistory('Вы зашли в Казино!');
    sumOnHand = globals.currentState.moneyOnHand;
    incSumOnHand = sumOnHand;
    _tecSumSet.text = '0';
    _tecSumSet.addListener(() {
      _recalcProfit();
    });
    _tecN1.text = '0';
    _tecN2.text = '0';
    _tecN3.text = '0';
    super.initState();

    _acontroller = AnimationController(
      vsync: this,
      debugLabel: "animations demo",
      duration: Duration(seconds: 6),
    );

    _acontroller.addListener(() {
      setState(() {
        _angle = (scaleAnimation.value * 360.0).toInt();
      });
    });

    _acontroller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _checkResult();
      }
    });
    _initAnim();
  }

  _checkResult() async {
    rotCounter++;
    var rng = new Random();
    int _winNum = rng.nextInt(37);
    List<int> redL = [
      1,
      3,
      5,
      7,
      9,
      12,
      14,
      16,
      18,
      19,
      21,
      23,
      25,
      27,
      30,
      32,
      34,
      36
    ];
    int _winColor = 1;
    if (_winNum == 0) {
      _winColor = 2;
    } else if (redL.indexOf(_winNum) > -1) {
      _winColor = 0;
    }
    print('checkResult with $_winNum isRed $_winColor');
    await showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text(
              'Выпало $_winNum ${_winColor == 2 ? '' : (_winColor == 0 ? 'красное' : 'чёрное')}',
              textAlign: TextAlign.center,
            )));
    bool _win = false;
    if (choose == 0) {
      int _n = _parseTec(_tecN1.text);
      if (_n == _winNum) {
        _win = true;
      }
    } else if (choose == 1) {
      int _n1 = _parseTec(_tecN1.text);
      int _n2 = _parseTec(_tecN2.text);
      if (_n1 == _winNum || _n2 == _winNum) {
        _win = true;
      }
    } else if (choose == 2) {
      int _n1 = _parseTec(_tecN1.text);
      int _n2 = _parseTec(_tecN2.text);
      int _n3 = _parseTec(_tecN2.text);
      if (_n1 == _winNum || _n2 == _winNum || _n3 == _winNum) {
        _win = true;
      }
    } else if (choose == 3) {
      if (_winColor < 2) {
        _win = _winColor == choosedNumber1;
      }
    } else if (choose == 4) {
      if (_winNum > 0) {
        if (_winNum % 2 > 0) {
          if (isOdd) {
            _win = true;
          }
        } else {
          if (!isOdd) {
            _win = true;
          }
        }
      }
    } else if (choose == 5) {
      if (!isOdd) {
        if (_winNum > 0 && _winNum < 19) {
          _win = true;
        }
      } else {
        if (_winNum > 18) {
          _win = true;
        }
      }
    }
    if (_win) {
      sumOnHand += sumWithProfit;
      globals.currentState.moneyOnHand = sumOnHand;
      setState(() {});
      await showAlertPage(context, 'Вы выиграли $sumWithProfit');
    } else {
      await showAlertPage(context, 'Вы проиграли ставку $sumSet');
      /*
      await showDialog(
          context: context,
          builder: (_) => AlertDialog(
                  title: Text(
                'Вы проиграли',
                textAlign: TextAlign.center,
              )));
              */
    }
    if (rotCounter == 10) {
      await showAlertPage(context, 'Извините, мы уже закрываемся.');
      Navigator.pop(context);
    }
  }

  _parseTec(_text) {
    int _res = 0;
    try {
      _res = int.parse(_text);
    } catch (e) {}
    return _res;
  }

  _initAnim() {
    var rng = new Random();
    scaleAnimation = Tween(
      begin: 0.0,
      end: 3 + rng.nextDouble(),
    ).animate(CurvedAnimation(parent: _acontroller, curve: Curves.decelerate));
  }

  _testRng() {
    var rng = new Random();
    int num14 = 0;
    for (var i = 0; i < 150; i++) {
      int num = rng.nextInt(15);
      print(num);
      if (num == 14) {
        num14++;
      }
    }
    print('num14 = $num14');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Казино - Рулетка"),
      ),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Ваши деньги:  ',
                  textScaleFactor: 1.5,
                ),
                Text(
                  sumOnHand.toString(),
                  textScaleFactor: 1.8,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Ваша ставка: ',
                  textScaleFactor: 1.4,
                ),
                Container(
                  width: 150,
                  child: TextField(
                    controller: _tecSumSet,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22),
                    //decoration: InputDecoration(labelText: "сумма ставки"),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ], // Only numbers can be entered
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Возможный выигрыш: $sumWithProfit',
              textScaleFactor: 1.6,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Ставка на:',
              textScaleFactor: 1.4,
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                      heroTag: 'left',
                      child: Icon(Icons.keyboard_arrow_left),
                      onPressed: () {
                        choose--;
                        if (choose < 0) {
                          choose = variants.length - 1;
                        }
                        _recalcProfit();
                        setState(() {});
                      }),
                  Container(
                    width: 200,
                    child: Text(
                      variants[choose],
                      textScaleFactor: 1.7,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  FloatingActionButton(
                      heroTag: 'right',
                      child: Icon(Icons.keyboard_arrow_right),
                      onPressed: () {
                        choose++;
                        if (choose == variants.length) {
                          choose = 0;
                        }
                        _recalcProfit();
                        setState(() {});
                      }),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                choose == 0 ? _buildRow1num() : SizedBox(),
                choose == 1 ? _buildRow2num() : SizedBox(),
                choose == 2 ? _buildRow3num() : SizedBox(),
                choose == 3 ? _buildRowColor() : SizedBox(),
                choose == 4 ? _buildRowOddEven() : SizedBox(),
                choose == 5 ? _buildRowLowHi() : SizedBox(),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 30,
                  child: FlatButton(
                    onPressed: _startGame,
                    child: Text(
                      'СТАРТ',
                      textScaleFactor: 1.5,
                    ),
                    color: Colors.lightGreenAccent,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12,
            ),
            _rollerW()
          ],
        ),
      ),
    );
  }

  Transform _rollerW() {
    return Transform.rotate(
      angle: _angle * 3.1415926 / 180,
      child: Container(
        height: 150,
        width: 150,
        child: FittedBox(
          fit: BoxFit.contain,
          child: ClipOval(
            child: Image.asset(
              'assets/rul.jpg',
            ),
          ),
        ),
      ),
    );
  }

  _startGame() async {
    if (sumSet == 0) {
      await showAlertPage(context, 'Сделайте ставку!');
      return;
    }
    if (sumSet > maxBet) {
      await showAlertPage(
          context, 'Максимальная ставка в нашем казино - $maxBet!');
      return;
    }
    if (sumSet > sumOnHand) {
      await showAlertPage(context, 'У вас не хватает денег!');
      return;
    }
    sumOnHand -= sumSet;
    globals.currentState.moneyOnHand = sumOnHand;
    setState(() {});
    _initAnim();
    _acontroller.reset();
    _acontroller.forward();
  }

  Row _buildRowLowHi() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              "Low (1-18)",
              textScaleFactor: 1.5,
              style: TextStyle(color: isOdd ? Colors.black : Colors.green),
            ),
            Switch(
              value: isOdd,
              onChanged: (value) {
                setState(() {
                  isOdd = value;
                });
              },
              activeTrackColor: Colors.lightGreenAccent,
              activeColor: Colors.green,
              inactiveTrackColor: Colors.lightGreenAccent,
              inactiveThumbColor: Colors.green,
            ),
            Text(
              "Hi (19-36)",
              textScaleFactor: 1.5,
              style: TextStyle(color: isOdd ? Colors.green : Colors.black),
            ),
          ],
        ),
      ],
    );
  }

  Row _buildRowOddEven() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Ставим на: ', textScaleFactor: 1.4),
        Row(
          children: [
            Text(
              "Чёт",
              textScaleFactor: 1.5,
              style: TextStyle(color: isOdd ? Colors.black : Colors.green),
            ),
            Switch(
              value: isOdd,
              onChanged: (value) {
                setState(() {
                  isOdd = value;
                });
              },
              activeTrackColor: Colors.lightGreenAccent,
              activeColor: Colors.green,
              inactiveTrackColor: Colors.lightGreenAccent,
              inactiveThumbColor: Colors.green,
            ),
            Text(
              "Нечёт",
              textScaleFactor: 1.5,
              style: TextStyle(color: isOdd ? Colors.green : Colors.black),
            ),
          ],
        ),
      ],
    );
  }

  Row _buildRowColor() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Ставка на: ', textScaleFactor: 1.4),
        Text(
          choosedNumber1 == 0 ? ' Красный ' : ' Чёрный ',
          textScaleFactor: 1.7,
          style:
              TextStyle(color: choosedNumber1 == 0 ? Colors.red : Colors.black),
        ),
        FloatingActionButton(
          backgroundColor: choosedNumber1 == 0 ? Colors.black : Colors.red,
          heroTag: 'exch',
          child: Icon(
            Icons.import_export,
            size: 36,
          ),
          onPressed: () {
            choosedNumber1 = choosedNumber1 == 0 ? 1 : 0;
            setState(() {});
          },
        ),
      ],
    );
  }

  Row _buildRow1num() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Ваше число', textScaleFactor: 1.4),
        Container(
          width: 60,
          child: TextField(
            controller: _tecN1,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22),
            //decoration: InputDecoration(labelText: "сумма ставки"),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ], // Only numbers can be entered
          ),
        ),
      ],
    );
  }

  Row _buildRow2num() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Ваши числа',
          textScaleFactor: 1.4,
        ),
        Container(
          width: 60,
          child: TextField(
            controller: _tecN1,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22),
            //decoration: InputDecoration(labelText: "сумма ставки"),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ], // Only numbers can be entered
          ),
        ),
        Text(
          'и',
          textScaleFactor: 1.4,
        ),
        Container(
          width: 60,
          child: TextField(
            controller: _tecN2,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ], // Only numbers can be entered
          ),
        ),
      ],
    );
  }

  Row _buildRow3num() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Ваши числа',
          textScaleFactor: 1.4,
        ),
        Container(
          width: 60,
          child: TextField(
            controller: _tecN1,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ], // Only numbers can be entered
          ),
        ),
        Text(
          'и',
          textScaleFactor: 1.4,
        ),
        Container(
          width: 60,
          child: TextField(
            controller: _tecN2,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22),
            //decoration: InputDecoration(labelText: "сумма ставки"),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ], // Only numbers can be entered
          ),
        ),
        Text(
          'и',
          textScaleFactor: 1.4,
        ),
        Container(
          width: 60,
          child: TextField(
            controller: _tecN3,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ], // Only numbers can be entered
          ),
        ),
      ],
    );
  }
}

extension CE on Widget {
  Widget clickable(void Function() action, {bool opaque = true}) {
    return GestureDetector(
      behavior: opaque ? HitTestBehavior.opaque : HitTestBehavior.deferToChild,
      onTap: action,
      child: this,
    );
  }
}
