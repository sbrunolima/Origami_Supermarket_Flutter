import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/account_screen.dart';
import '../providers/user.dart';

class AddAdressScreen extends StatefulWidget {
  static const routeName = '/add-adress-screen';

  @override
  State<AddAdressScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<AddAdressScreen> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: deviceSize.width > 600 ? 2 : 1,
              child: AutorizationCard(),
            ),
          ],
        ),
      ),
    );
  }
}

class AutorizationCard extends StatefulWidget {
  @override
  _AutorizationCardState createState() => _AutorizationCardState();
}

class _AutorizationCardState extends State<AutorizationCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  var _isLoading = false;
  final _passwordController = TextEditingController();

  var cidade;
  var _isInit = true;
  var _newUser = NewUser(
    id: null,
    name: '',
    fone: '',
    rua: '',
    complemento: '',
    cidade: '',
  );
  var _initValues = {
    'name': '',
    'fone': '',
    'rua': '',
    'complemento': '',
    'cidade': '',
    'hasAddress': true,
  };

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
      final userId = ModalRoute.of(context)!.settings.arguments as String;
      if (userId != null) {
        _newUser = Provider.of<User>(context, listen: false).findById(userId);
        _initValues = {
          'name': _newUser.name.toString(),
          'fone': _newUser.fone.toString(),
          'rua': _newUser.rua.toString(),
          'complemento': _newUser.complemento.toString(),
          'cidade': _newUser.cidade.toString(),
          'hasAddress': true,
        };
      }
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_newUser.id != null) {
      await Provider.of<User>(context, listen: false)
          .updateUserAdress(_newUser.id.toString(), _newUser);
      setState(() {
        _isLoading = false;
      });
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
    } else {
      await Provider.of<User>(context, listen: false)
          .addUser(_newUser)
          .catchError((error) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('A não!'),
            content: const Text(
              'Ocorreu um erro carregando os dados.',
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  child: const Text('Voltar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      });
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final sizedBox = SizedBox(height: 10);
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    sizedBox,
                    TextFormField(
                      initialValue: _initValues['name'].toString(),
                      decoration: InputDecoration(
                        labelText: 'Nome',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Entre com o NOME.';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _newUser = NewUser(
                          id: _newUser.id,
                          name: value.toString(),
                          fone: _newUser.fone,
                          rua: _newUser.rua,
                          complemento: _newUser.complemento,
                          cidade: _newUser.cidade,
                          hasAddress: true,
                        );
                      },
                    ),
                    sizedBox,
                    TextFormField(
                      initialValue: _initValues['fone'].toString(),
                      decoration: InputDecoration(
                        labelText: 'Telefone',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Entre com o TELEFONE.';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _newUser = NewUser(
                          id: _newUser.id,
                          name: _newUser.name,
                          fone: value.toString(),
                          rua: _newUser.rua,
                          complemento: _newUser.complemento,
                          cidade: _newUser.cidade,
                          hasAddress: true,
                        );
                      },
                    ),
                    sizedBox,
                    TextFormField(
                      initialValue: _initValues['rua'].toString(),
                      decoration: InputDecoration(
                        labelText: 'Endereço',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Entre com o ENDEREÇO.';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _newUser = NewUser(
                          id: _newUser.id,
                          name: _newUser.name,
                          fone: _newUser.fone,
                          rua: value.toString(),
                          complemento: _newUser.complemento,
                          cidade: _newUser.cidade,
                          hasAddress: true,
                        );
                      },
                    ),
                    sizedBox,
                    TextFormField(
                      initialValue: _initValues['complemento'].toString(),
                      decoration: InputDecoration(
                        labelText: 'Complemento',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Entre com o COMPLEMENTO.';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _newUser = NewUser(
                          id: _newUser.id,
                          name: _newUser.name,
                          fone: _newUser.fone,
                          rua: _newUser.rua,
                          complemento: value.toString(),
                          cidade: _newUser.cidade,
                          hasAddress: true,
                        );
                      },
                    ),
                    sizedBox,
                    TextFormField(
                      initialValue: _initValues['cidade'].toString(),
                      decoration: InputDecoration(
                        labelText: 'Cidade',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Entre com a CIDADE.';
                        }

                        return null;
                      },
                      onFieldSubmitted: (value) {
                        _submit();
                      },
                      onSaved: (value) {
                        _newUser = NewUser(
                          id: _newUser.id,
                          name: _newUser.name,
                          fone: _newUser.fone,
                          rua: _newUser.rua,
                          complemento: _newUser.complemento,
                          cidade: value.toString(),
                          hasAddress: true,
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    if (_isLoading)
                      const CircularProgressIndicator()
                    else
                      SizedBox(
                        height: 50,
                        width: 350,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.red)
                              : const Text(
                                  'Adicionar',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                          onPressed: () async {
                            _submit();
                            Navigator.of(context)
                                .popAndPushNamed(AccountScreen.routeName);
                          },
                        ),
                      ),
                    const SizedBox(height: 30),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .popAndPushNamed(AccountScreen.routeName);
                      },
                      child: const Text(
                        'Voltar',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
