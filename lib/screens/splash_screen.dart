import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  static const routeName = 'aplash';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/origami.png'),
      ),
    );
  }
}
