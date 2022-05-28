import 'package:easy_management/route/route.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = "Easy Management";

  @override
  Widget build(BuildContext context) {
    Map<int, Color> colorSwatch = const {
      50: Color.fromRGBO(86, 149, 44, .1),
      100: Color.fromRGBO(86, 149, 44, .2),
      200: Color.fromRGBO(86, 149, 44, .3),
      300: Color.fromRGBO(86, 149, 44, .4),
      400: Color.fromRGBO(86, 149, 44, .5),
      500: Color.fromRGBO(86, 149, 44, .6),
      600: Color.fromRGBO(86, 149, 44, .7),
      700: Color.fromRGBO(86, 149, 44, .8),
      800: Color.fromRGBO(86, 149, 44, .9),
      900: Color.fromRGBO(86, 149, 44, 1),
    };

    MaterialColor primaryAppColor = MaterialColor(0xFF56952C, colorSwatch);

    return MaterialApp(
      title: _title,
      theme: ThemeData(
        primarySwatch: primaryAppColor,
      ),
      initialRoute: '/login',
      onGenerateRoute: RoutesConroller.generateRoute,
    );
  }
}
