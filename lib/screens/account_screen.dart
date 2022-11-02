import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/user.dart';
import '../screens/add_adress_screen.dart';
import '../widgets/user_data_widget.dart';
import '../screens/start_screen.dart';
import '../screens/choose_address_screen.dart';

class AccountScreen extends StatefulWidget {
  static const routeName = '/account-screen';

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  var _isLoading = false;
  var _isInit = true;
  var receivedArg = "";
  var sendedArg = "authScreen";

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final pageId = ModalRoute.of(context)!.settings.arguments;
      if (pageId != null) {
        setState(() {
          receivedArg = pageId.toString();
        });
      }
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });

      await Provider.of<User>(context, listen: false).fetchUserData();
      setState(() {
        _isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<User>(context);

    return WillPopScope(
      onWillPop: () async {
        if (receivedArg.contains("chooseAddress")) {
          Navigator.of(context).popAndPushNamed(ChooseAddressScreen.routeName);
        } else {
          Navigator.of(context)
              .popAndPushNamed(StartScreen.routeName, arguments: '4');
        }
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
              if (receivedArg.contains("chooseAddress")) {
                Navigator.of(context)
                    .popAndPushNamed(ChooseAddressScreen.routeName);
              } else {
                Navigator.of(context)
                    .popAndPushNamed(StartScreen.routeName, arguments: '4');
              }
            },
          ),
          title: Text(
            'Meu Endereço',
            style: GoogleFonts.openSans(
              color: Colors.blue,
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        body: userData.users.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: userData.users.length,
                itemBuilder: (ctx, i) => UserDataWidget(userData.users[i]))
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Text(
                            'CADASTRO E ENDEREÇO',
                            style: GoogleFonts.openSans(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          textReturned('Nome: ', ''),
                          textReturned('Telefone: ', ''),
                          textReturned('Endereço: ', ''),
                          textReturned('Complemento: ', ''),
                          textReturned('Cidade: ', ''),
                          const SizedBox(height: 20),
                          SizedBox(
                            height: 50,
                            width: 330,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              child: Text(
                                'Editar endereço',
                                style: GoogleFonts.openSans(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context)
                                    .popAndPushNamed(AddAdressScreen.routeName);
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget textReturned(String title, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          const SizedBox(height: 8),
          Text(
            text,
            style: GoogleFonts.openSans(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 6),
          const Divider(
            color: Colors.grey,
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
