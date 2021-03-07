import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Помощь"),
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(10),
        child: Center(
          child: ListView(shrinkWrap: true, children: [
            SizedBox(
              height: 20,
            ),
            Text(
              """
  Правила игры:
Родители подарили тебе небольшой стартовый капитал и отправили в самостоятельное плаванье по реке жизни.

  Цель:
Выжить и достичь благополучия. Убедиться, что ты сможешь прожить самостоятельно.

  Оцениваемые результаты:
минимум - продержись на плаву 1 год!
максимум - миллион в активе!
  Всё в твоих руках!
  
Не забывай! В жизни важна не сиюсекундная прибыль.
Залог успеха - стабильный доход, хорошее здоровье, оптимистичное настроение!

Твои возможности заработка:
  - найти хорошую работу;
  - перебиваться случайными выигрышами в казино;
  - торговать на криптобирже;
  - положить деньги в банк под проценты;
  - случайные доходы.

Твои расходы делятся на фиксированные (аренда квартиры, питание) и случайные.
Будь готов ко всему!)

Получить хорошую работу можно повышая уровень образования.
Хотя шанс есть и так. Просто небольшой)

Следи за здоровьем!
  - оно улучшается когда ты в меру работаешь, в меру учишься.
  - падает когда перенапрягаешься.
Слабое здоровье уменьшает шанс получения хорошей работы, уменьшает з/п т.к. приходится чаще лечиться дома.


Успехов!)

              """,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton(
              child: Text('p.s.: Ты всегда можешь начать игру заново, нажав эту кнопку!'),
              color: Colors.greenAccent,
              onPressed: (){
                Navigator.of(context).pushNamedAndRemoveUntil('/', ModalRoute.withName('/'));
              },
            ),
            SizedBox(
              height: 40,
            ),
          ]),
        ),
      ),
    );
  }
}
