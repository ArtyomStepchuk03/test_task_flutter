import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:test_task_flutter/pages/history.dart';
import 'package:test_task_flutter/pages/about_app.dart';
import 'package:test_task_flutter/pages/main_screen.dart';

void main() => runApp(FilesystemPickerDefaultOptions(
  fileTileSelectMode: FileTileSelectMode.wholeTile,
  theme: FilesystemPickerTheme(
    topBar: FilesystemPickerTopBarThemeData(
      backgroundColor: Colors.teal,
    ),
  ),
  child: MaterialApp(
    routes: {
      '/': (context) => const MainScreen(),
      '/history': (context) => const History(),
      '/about-app': (context) => const AboutApp(),
    },
  ),
));