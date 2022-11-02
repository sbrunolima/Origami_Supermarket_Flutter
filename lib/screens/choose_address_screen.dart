import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/account_screen.dart';
import '../providers/user.dart';
import '../widgets/cart_resume_bar_widget.dart';
import '../screens/payment_screen.dart';
import '../screens/start_screen.dart';

class ChooseAddressScreen extends StatefulWidget {
  static const routeName = '/choose-address-screen';

  @override
  State<ChooseAddressScreen> createState() => _ChooseAddressScreenState();
}

class _ChooseAddressScreenState extends State<ChooseAddressScreen> {
  var _isLoading = false;
  var _isInit = true;
  var testCidade = false;
  var sendedArg = "chooseAddress";

  //Procura a cidade no servido
  Future<void> searchCidade(String query) async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<User>(context, listen: false).findCidades(query);
    setState(() {
      _isLoading = false;
    });
  }

  //Remove caracteres
  String _textSelect(String str) {
    str = str.replaceAll('ã', 'a');
    str = str.replaceAll(' ', '');
    str = str.replaceAll('á', 'a');

    return str;
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      await Provider.of<User>(context, listen: false).fetchUserData();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<User>(context);
    if (_isInit) {
      int size = 0;
      for (int i = 0; i < userData.users.length; i++) {
        setState(() {
          String _finalCidade =
              _textSelect(userData.users[i].cidade.toString());
          searchCidade(_finalCidade);
          testCidade = userData.deliveryOK;
        });
        size++;
      }
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context)
            .popAndPushNamed(StartScreen.routeName, arguments: "3");

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
                  .popAndPushNamed(StartScreen.routeName, arguments: "3");
            },
          ),
          title: Text(
            'Endereço de entrega',
            style: GoogleFonts.openSans(
              color: Colors.blue,
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  'DADOS DA ENTREGA',
                  style: GoogleFonts.openSans(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              userData.users.length <= 0
                  ? noAddress()
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.white,
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: userData.users.length,
                          itemBuilder: (ctx, i) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                address('Nome:  ', '${userData.users[i].name}'),
                                const Divider(),
                                address(
                                    'Telefone:  ', '${userData.users[i].fone}'),
                                const Divider(),
                                address(
                                    'Endereço:  ', '${userData.users[i].rua}'),
                                const Divider(),
                                address('Complemento:  ',
                                    '${userData.users[i].complemento}'),
                                const Divider(),
                                address(
                                    'Cidade:  ', '${userData.users[i].cidade}'),
                                !testCidade
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: _isLoading
                                            ? const CircularProgressIndicator()
                                            : const Text(
                                                'Infelizmente ainda não entregamos nesse enderaço.',
                                                style: TextStyle(
                                                    color: Colors.redAccent),
                                              ),
                                      )
                                    : const SizedBox(),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
              const SizedBox(height: 10),
              CartResumeBar(),
              const SizedBox(height: 10),
              const SizedBox(height: 80),
            ],
          ),
        ),
        persistentFooterButtons: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.green.shade600),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    child: Text(
                      'Ir para pagamento',
                      style: GoogleFonts.openSans(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: !testCidade
                        ? () {}
                        : () {
                            Navigator.of(context)
                                .popAndPushNamed(PaymentScreen.routeName);
                          },
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ],
      ),
    );
  }

  Widget noAddress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SizedBox(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.red.shade500),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          child: Text(
            'Adicionar novo endereço',
            style: GoogleFonts.openSans(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          onPressed: () {
            Navigator.of(context)
                .popAndPushNamed(AccountScreen.routeName, arguments: sendedArg);
          },
        ),
      ),
    );
  }

  Widget address(String title, String name) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.openSans(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            name,
            style: GoogleFonts.openSans(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          )
        ],
      ),
    );
  }
}
