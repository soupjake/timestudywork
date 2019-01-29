import 'package:flutter/material.dart';
import 'package:timestudyapp/pages/home_page.dart';

class TimeStudyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark, primaryColor: Color.fromRGBO(237, 28, 36, 1.0), accentColor: Color.fromRGBO(243, 99, 104, 1.0)),
        home: HomePage());
  }
}
