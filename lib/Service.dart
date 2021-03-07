import 'dart:ui';
import 'globals.dart' as globals;
import 'package:flutter/material.dart';

int testVar = 0;

Future<void> showAlertPage(context, String msg) async {
  globals.msgsHistory.add(globals.Msg(globals.currentState.date, msg));
  await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(msg),
        );
      });
}

Future<bool> askYesNoPage(context, String msg) async {
  var _res = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(msg),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                      color: Colors.grey[200],
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: Text('ДА')),
                  SizedBox(
                    width: 20,
                  ),
                  FlatButton(
                      color: Colors.grey[200],
                      onPressed: () {
                        Navigator.pop(context, false);
                      },
                      child: Text('НЕТ')),
                ],
              ),
            ],
          ),
        );
      });
  if (_res == null) return false;
  return _res;
}
