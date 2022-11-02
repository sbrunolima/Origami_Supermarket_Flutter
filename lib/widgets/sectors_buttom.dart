import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SectorsButtom extends StatelessWidget {
  String image;
  String title;

  SectorsButtom(this.image, this.title);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.white60,
          ),
          child: Image.asset(
            image,
            scale: 8,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: GoogleFonts.lato(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
