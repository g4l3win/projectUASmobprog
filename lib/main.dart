import 'package:flutter/material.dart';
import 'package:quizdb/screens/SignIn.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kuis Interaktif',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Signin(),
      debugShowCheckedModeBanner: false, // Disable the debug banner
    );
  }
}
