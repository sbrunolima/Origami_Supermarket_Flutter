import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Badge extends StatelessWidget {
  var child;
  var value;
  final Color? color;

  Badge({
    @required this.child,
    @required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 5,
          top: 10,
          child: Container(
            padding: const EdgeInsets.all(2.0),
            // color: Theme.of(context).accentColor,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.red,
            ),
            constraints: const BoxConstraints(
              minWidth: 21,
              minHeight: 14,
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        )
      ],
    );
  }
}
