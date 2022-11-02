import 'package:flutter/material.dart';

class PromoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _mediaQueryData = MediaQuery.of(context);
    final screenWidth = _mediaQueryData.size.width;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: 220.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Container(
            height: 200.0,
            width: screenWidth,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(2),
              color: Colors.grey,
            ),
            child: Image.asset(
              'assets/promo01.jpg',
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 5),
          Container(
            height: 200.0,
            width: screenWidth,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(2),
              color: Colors.grey,
            ),
            child: Image.asset(
              'assets/promo02.jpg',
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 5),
          Container(
            height: 200.0,
            width: screenWidth,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(2),
              color: Colors.grey,
            ),
            child: Image.asset(
              'assets/promo03.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
