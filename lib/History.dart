import 'package:flutter/material.dart';
import 'globals.dart' as globals;

class History extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("История событий"),
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(10),
        child: Center(
          child: ListView(shrinkWrap: true, children: _historyMsgsList()),
        ),
      ),
    );
  }

  List<Widget> _historyMsgsList() {
    List<Widget> _res = [];
    for (int i = 0; i < globals.msgsHistory.length; i++) {
      int _pos = globals.msgsHistory.length - i - 1;
      print('pos $_pos');
      _res.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          globals.msgsHistory[_pos].toString(),
          textScaleFactor: 1.2,
        ),
      ));
    }
    return _res;
  }
}
