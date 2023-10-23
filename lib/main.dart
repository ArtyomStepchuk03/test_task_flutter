import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:test_task_flutter/pages/history.dart';
import 'package:test_task_flutter/pages/about_app.dart';
import 'package:test_task_flutter/pages/main_screen.dart';

/// The key-method of app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ru')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ru'),
      child: const MyApp(),
      // child: FilesystemPickerDefaultOptions(
      //     fileTileSelectMode: FileTileSelectMode.wholeTile,
      //     theme: FilesystemPickerTheme(
      //       topBar: FilesystemPickerTopBarThemeData(
      //         backgroundColor: Colors.teal,
      //       ),
      //     ),
      //     child: const MyApp()
      // )
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      routes: {
        '/': (context) => const MainScreen(),
        '/history': (context) => const History(),
        '/about-app': (context) => const AboutApp(),
      },
    );
  }
}