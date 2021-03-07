import 'dart:math';

import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'Service.dart';

class Work extends StatefulWidget {
  @override
  _WorkState createState() => _WorkState();
}

class _WorkState extends State<Work> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Работа'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Текущий статус:',
              textScaleFactor: 1.7,
            ),
            SizedBox(
              height: 6,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              child: Text(
                (globals.currentState.workHours > 0 ? 'работаешь ' : '') +
                    globals.currentState.workingState(),
                textScaleFactor: 1.6,
                textAlign: TextAlign.center,
              ),
              color: Colors.greenAccent[100],
              padding: EdgeInsets.all(16),
            ),
            SizedBox(
              height: 10,
            ),
            globals.currentState.workHours == 0
                ? SizedBox()
                : Text(
                    'Должность: ${globals.currentState.vacancy.name}',
                    textScaleFactor: 1.4,
                  ),
            SizedBox(
              height: 16,
            ),
            globals.currentState.workHours == 0
                ? SizedBox()
                : Text(
                    'З/п : ${globals.currentState.salary} в месяц',
                    textScaleFactor: 1.5,
                  ),
            SizedBox(
              height: 16,
            ),
            globals.currentState.releaseDT == null
                ? SizedBox()
                : Text(
                    'Последний рабочий день - \n' +
                        globals.dateRus(globals.currentState.releaseDT),
                    textScaleFactor: 1.3,
                    textAlign: TextAlign.center),
            globals.currentState.workHours == 0
                ? Column(children: [
                    Text(
                      'Устроиться на работу:',
                      textScaleFactor: 1.7,
                    ),
                    Container(
                        color: Colors.yellow[200],
                        padding: EdgeInsets.all(10),
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          FlatButton(
                            color: Colors.lightGreenAccent[100],
                            onPressed: () {
                              _work(8);
                            },
                            child: Text(
                              'Полная занятость (8ч)',
                              textScaleFactor: 1.6,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FlatButton(
                            color: Colors.lightGreenAccent[100],
                            onPressed: () {
                              _work(4);
                            },
                            child: Text(
                              'На полставки (4ч)',
                              textScaleFactor: 1.6,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          FlatButton(
                            color: Colors.lightGreenAccent[100],
                            onPressed: () {
                              _work(12);
                            },
                            child: Text(
                              'На полторы ставки (12ч)',
                              textScaleFactor: 1.6,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ]))
                  ])
                : (globals.currentState.releaseDT == null
                    ? FlatButton(
                        color: Colors.grey[200],
                        onPressed: () {
                          _work(0);
                        },
                        child: Text(
                          'Уволиться',
                          textScaleFactor: 1.6,
                        ),
                      )
                    : SizedBox()),
          ],
        ),
      ),
    );
  }

  _work(int hours) async {
    if (hours == 0) {
      await showAlertPage(
          context, 'Согласно трудового договора, надо отработь ещё 1 неделю.');
      globals.currentState.releaseDT =
          globals.currentState.date.add(Duration(days: 7));
      print('you will ne released from ${globals.currentState.releaseDT}');
      Navigator.pop(context);
      return;
    }
    if (globals.currentState.freeHours < hours) {
      await showAlertPage(context, 'Недостаточно свободного времени.');
      return;
    }
    var value = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Доступны вакансии:',
                  textScaleFactor: 1.5,
                  style: TextStyle(color: Colors.blue),
                ),
                SizedBox(
                  height: 16,
                ),
                Column(children: _listVac()),
              ],
            ),
          );
        });
    print('got val $value');
    if (value == null) {
      return;
    }
    var rng = new Random();

    double _chance = value.getFullChance(globals.currentState);
    print('chance $_chance');

    if (rng.nextInt(100) < _chance) {
      print('chance realised.');
      await showAlertPage(context, 'Танцуйте! Вас взяли на работу!');
      await showAlertPage(context, 'Вы теперь - ${value.name}!');
      globals.currentState.vacancy = value;
      globals.currentState.salary = (value.baseSalary * hours / 8).toInt();
      print('got salary ${globals.currentState.salary}');
      globals.currentState.workHours = hours;
      globals.currentState.updateFreeHours();
      print('got1 cur vac ${globals.currentState.vacancy}');
    } else {
      print('chance is facked');
      await showAlertPage(context, 'Не повезло, вы не прошли собеседование.');
    }
    Navigator.pop(context);
  }

  List<Widget> _listVac() {
    List<Widget> _res = [];
    globals.vacancies.forEach((element) {
      double _chance = element.getFullChance(globals.currentState);
      _res.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: FlatButton(
            color: Colors.lightBlue[100],
            onPressed: () {
              Navigator.pop(context, element);
            },
            child: Text(
              element.name +
                  ' - з/п ' +
                  element.baseSalary.toString() +
                  ', шанс ' +
                  _chance.toStringAsFixed(2) +
                  '%',
              textScaleFactor: 1.3,
              textAlign: TextAlign.center,
            )),
      ));
    });
    return _res;
  }
}
