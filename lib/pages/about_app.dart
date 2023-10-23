import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// This screen contains information about developer and about used libraries.
class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('about_app'.tr()),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Row(
                children: [
                  Text('about_developer.title'.tr(),
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Row(
                children: [
                  SizedBox(
                    width: 350,
                    child: Text('about_developer.content'.tr(),
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Row(
                children: [
                  Text('libraries'.tr(),
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
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