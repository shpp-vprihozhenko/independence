import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'Service.dart';

class Study extends StatefulWidget {
  @override
  _StudyState createState() => _StudyState();
}

class _StudyState extends State<Study> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Учёба'),
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
              child: Text(
                globals.currentState.studyingState(),
                textScaleFactor: 1.6,
              ),
              color: Colors.yellow[200],
              padding: EdgeInsets.all(8),
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              'Пойти учиться:',
              textScaleFactor: 1.7,
            ),
            Container(
              color: Colors.yellow[200],
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FlatButton(
                    color: Colors.lightGreenAccent,
                    onPressed: () {
                      _study(8);
                    },
                    child: Text(
                      'Очно, весь день',
                      textScaleFactor: 1.6,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FlatButton(
                    color: Colors.lightBlue[100],
                    onPressed: () {
                      _study(4);
                    },
                    child: Text(
                      'Заочно, пол дня',
                      textScaleFactor: 1.6,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FlatButton(
                    color: Colors.grey[200],
                    onPressed: () {
                      _study(0);
                    },
                    child: Text(
                      'Прекратить учиться',
                      textScaleFactor: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _study(int hours) async {
    if (globals.currentState.freeHours < hours) {
      await showAlertPage(
          context, 'Недостаточно свободного времени для учёбы.');
      return;
    }
    await showAlertPage(
        context,
        hours == 0
            ? 'Вы прекратили учёбу'
            : "Вы начали учиться $hours ч. в день");
    globals.currentState.studyHours = hours;
    globals.currentState.updateFreeHours();
    Navigator.pop(context);
  }
}
