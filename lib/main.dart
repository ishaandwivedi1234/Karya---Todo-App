import 'package:flutter/material.dart';
import 'package:karya/pages/splash.dart';

void main() {
  runApp(KaryaApp());
}

class KaryaApp extends StatefulWidget {
  @override
  _KaryaAppState createState() => _KaryaAppState();
}

class _KaryaAppState extends State<KaryaApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Karya", debugShowCheckedModeBanner: false, home: Splash());
  }
}
