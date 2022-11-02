import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/user.dart';
import '../providers/cart.dart';
import '../screens/start_screen.dart';
import '../screens/orders_screen.dart';
import '../screens/account_screen.dart';
import '../providers/auth.dart';
import '../providers/orders.dart';
import '../screens/our_shops_screen.dart';
import '../screens/wats_screen.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/profile-screen';

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userName;
  var sendedArg = "profileScreen";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).popAndPushNamed(StartScreen.routeName);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[300],
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
                  .popAndPushNamed(StartScreen.routeName, arguments: '0');
            },
          ),
          title: Text(
            'Minha Conta',
            style: GoogleFonts.openSans(
              color: Colors.blue,
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.exit_to_app_sharp,
                color: Colors.red,
                size: 30,
              ),
              onPressed: () {
                Navigator.of(context).popAndPushNamed(StartScreen.routeName);
                Provider.of<Auth>(context, listen: false).logout();
                Provider.of<User>(context, listen: false).clear();
                Provider.of<Orders>(context, listen: false).clear();
                Provider.of<Cart>(context, listen: false).clear();
              },
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(4),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 6),
                  ListTile(
                    leading:
                        const Icon(Icons.description_sharp, color: Colors.grey),
                    title: Text('Meus Pedidos'),
                    onTap: () {
                      Navigator.of(context).popAndPushNamed(
                          OrdersScreen.routeName,
                          arguments: sendedArg);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.person, color: Colors.grey),
                    title: Text('Meu Endereço'),
                    onTap: () {
                      Navigator.of(context).popAndPushNamed(
                          AccountScreen.routeName,
                          arguments: sendedArg);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.location_pin, color: Colors.grey),
                    title: Text('Nossas Lojas'),
                    onTap: () {
                      Navigator.of(context).popAndPushNamed(
                          OurShopsScreens.routeName,
                          arguments: sendedArg);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.phone_in_talk_rounded,
                        color: Colors.grey),
                    title: Text('WhatsApp'),
                    onTap: () {
                      Navigator.of(context).popAndPushNamed(
                          WatsScreens.routeName,
                          arguments: sendedArg);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading:
                        const Icon(Icons.exit_to_app_sharp, color: Colors.red),
                    title: Text('Sair'),
                    onTap: () {
                      Navigator.of(context)
                          .popAndPushNamed(StartScreen.routeName);
                      Provider.of<Auth>(context, listen: false).logout();
                      Provider.of<User>(context, listen: false).clear();
                      Provider.of<Orders>(context, listen: false).clear();
                      Provider.of<Cart>(context, listen: false).clear();
                    },
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
