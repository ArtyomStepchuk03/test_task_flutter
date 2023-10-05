import 'package:flutter/material.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('О приложении'),
      ),
      body: const SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10, top: 10),
              child: Row(
                children: [
                  Text('О Разработчике',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, top: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 350,
                    child: Text('Данный пробник на мобильное приложение разработал студент 3 курса Томского '
                        'политехнического университета. Я могу написать столько, что никакой оперативы не хватит. '
                        'Скажу кратко... Возьмёте меня - не пожалеете (:',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, top: 10),
              child: Row(
                children: [
                  Text('Библиотеки',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, top: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 350,
                    child: Text('flutter:\n'
                      ' sdk: flutter\n'
                      'http: ^1.1.0\n'
                      'xml: ^6.3.0\n'
                      'intl: ^0.18.1\n'
                      'path_provider: ^2.1.1\n'
                      'shared_preferences: ^2.2.1\n'
                      'filesystem_picker: ^3.0.0\n'
                      'cupertino_icons: ^1.0.2',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}