import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/user.dart';
import '../screens/add_adress_screen.dart';

class UserDataWidget extends StatefulWidget {
  final NewUser newUser;

  UserDataWidget(this.newUser);

  @override
  State<UserDataWidget> createState() => _UserDataWidgetState();
}

class _UserDataWidgetState extends State<UserDataWidget> {
  // Verifica se a cidade es tá disponivel pra entrega
  var testCidade = false;
  var _isLoading = false;
  var _isInit = true;
  String? _finalCidade;

  //Procura a cidade no servidor
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
  void didChangeDependencies() {
    if (_isInit) {
      _finalCidade = _textSelect(widget.newUser.cidade.toString());
      searchCidade(_finalCidade.toString());
    }

    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<User>(context);
    setState(() {
      testCidade = userData.deliveryOK;
    });
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
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
            color: Colors.white,
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              textReturned('Nome: ', '${widget.newUser.name}'),
              textReturned('Telefone: ', '${widget.newUser.fone}'),
              textReturned('Endereço: ', '${widget.newUser.rua}'),
              textReturned('Complemento: ', '${widget.newUser.complemento}'),
              textReturned('Cidade: ', '${widget.newUser.cidade}'),
              !testCidade
                  ? Padding(
                      padding: const EdgeInsets.all(0),
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text(
                              'Infelizmente ainda não entregamos nesse enderaço.',
                              style: TextStyle(color: Colors.redAccent),
                            ),
                    )
                  : const SizedBox(),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                width: 330,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).popAndPushNamed(
                        AddAdressScreen.routeName,
                        arguments: widget.newUser.id);
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
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
