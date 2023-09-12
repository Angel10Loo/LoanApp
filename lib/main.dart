import 'package:flutter/material.dart';
import 'package:loan_app/src/presentation/screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() {
  // Set the log level to a higher level to see fewer log messages.
  // Levels in increasing order of verbosity: OFF, FINEST, FINER, FINE, CONFIG, INFO, WARNING, SEVERE, SHOUT.
  // Adjust the log level as needed.
  debugPrint = (String? message, {int? wrapWidth}) {};
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }
}
