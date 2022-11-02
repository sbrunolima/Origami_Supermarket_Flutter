import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/start_screen.dart';

class WatsScreens extends StatelessWidget {
  static const routeName = '/wats-screen';
  @override
  Widget build(BuildContext context) {
    final divider = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: const Divider(),
    );

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context)
            .popAndPushNamed(StartScreen.routeName, arguments: '4');

        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              size: 30,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context)
                  .popAndPushNamed(StartScreen.routeName, arguments: '4');
            },
          ),
          title: Text(
            'WhatsApp',
            style: GoogleFonts.openSans(
              color: Colors.blue,
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 15),
            address('', '', ''),
            divider,
            address('', '', ''),
          ],
        ),
      ),
    );
  }

  Widget address(String shopNumber, String phone, String address) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(4),
        color: Colors.white,
      ),
      child: Column(
        children: [
          ListTile(
            title: ListTile(
              title: Text(shopNumber),
              subtitle: Text(phone),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(address),
            ),
            trailing: Image.asset(
              'assets/wats_logo.png',
              scale: 8,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
