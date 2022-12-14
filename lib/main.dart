import 'package:attendence/app.dart';
import 'package:attendence/base/base.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  final Base base = Base();
  runApp(App(base));
}
