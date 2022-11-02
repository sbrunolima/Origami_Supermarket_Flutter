import 'package:flutter/material.dart';

class HomeAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: const Icon(
        Icons.menu,
        color: Colors.black,
      ),
      title: Center(
        child: Image.asset(
          'assets/logo.png',
          scale: 4,
        ),
      ),
      actions: [
        Icon(
          Icons.shopping_cart_outlined,
          color: Colors.black,
          size: 30,
        ),
        SizedBox(width: 20),
      ],
    );
  }
}
