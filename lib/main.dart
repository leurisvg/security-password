import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:secure_sign_up/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
