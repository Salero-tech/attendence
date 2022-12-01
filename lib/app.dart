import 'package:attendence/base/base.dart';
import 'package:attendence/screens/overview/overviewScreen.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  final Base base;
  const App(this.base, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('de', 'CH'),
      title: 'Attendence Manager',
      home: OverviewScreen(base),
    );
  }
}
