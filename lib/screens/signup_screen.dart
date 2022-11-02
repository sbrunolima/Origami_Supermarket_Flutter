import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../data/http_exceptions.dart';
import '../screens/auth_screen.dart';
import '../screens/start_screen.dart';

enum AutorizationMode {
  Signup,
  Login,
}

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup-screen';

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var _isInit = true;
  var receivedArg = "";

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
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        if (receivedArg.contains('authScreen')) {
          Navigator.of(context)
              .popAndPushNamed(StartScreen.routeName, arguments: "4");
        } else if (receivedArg.contains('carrinho')) {
          Navigator.of(context)
              .popAndPushNamed(AuthScreen.routeName, arguments: receivedArg);
        }

        return true;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              if (receivedArg.contains('authScreen')) {
                Navigator.of(context)
                    .popAndPushNamed(StartScreen.routeName, arguments: "4");
              } else if (receivedArg.contains('carrinho')) {
                Navigator.of(context).popAndPushNamed(AuthScreen.routeName,
                    arguments: receivedArg);
              }
            },
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: deviceSize.width > 600 ? 2 : 1,
              child: AutorizationCard(receivedArg.toString()),
            ),
          ],
        ),
      ),
    );
  }
}

class AutorizationCard extends StatefulWidget {
  final String receivedArg;

  AutorizationCard(this.receivedArg);

  @override
  _AutorizationCardState createState() => _AutorizationCardState();
}

class _AutorizationCardState extends State<AutorizationCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AutorizationMode _authMode = AutorizationMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  var _isLoading = false;
  final _passwordController = TextEditingController();

  var nome, email, fone, rua, complemento, cidade;

  void _errorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ops, algo deu errado!'),
        content: Text(message),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.blueAccent,
                ),
                child: const Center(
                  child: Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Se dados forem invalidos
      return;
    }

    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<Auth>(context, listen: false).signup(
        _authData['email'].toString(),
        _authData['password'].toString(),
      );
      Navigator.of(context)
          .popAndPushNamed(StartScreen.routeName, arguments: "4");
    } on HttpException catch (error) {
      print('erro: $error');
      String errorMessage = 'Falha de autenticação.';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'E-mail em uso.';
      } else if (error.toString().contains('INVALID_EXISTS')) {
        errorMessage = 'E-mail inválidos.';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'Senha fraca.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Sem usuários com esse e-mail.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Senha errada.';
      }
      _errorDialog(errorMessage);
    } catch (error) {
      const errorMessage = 'Autentication faild. Try again!';
      _errorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final sizedBox = SizedBox(height: 10);
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Image.asset(
                'assets/origami.png',
                scale: 1.5,
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Colors.white,
                  ),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'E-mail',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value.toString().isEmpty ||
                              !value.toString().contains('@gmail.com') &&
                                  !value.toString().contains('@Outlook.com') &&
                                  !value.toString().contains('@hotmail.com') &&
                                  !value.toString().contains('@live.com') &&
                                  !value.toString().contains('@yahoo.com') &&
                                  !value.toString().contains('@test.com')) {
                            return 'Email Invalido!';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _authData['email'] = value.toString();
                          email = value.toString();
                        },
                      ),
                      sizedBox,
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        obscureText: true,
                        controller: _passwordController,
                        validator: (value) {
                          if (value.toString().isEmpty ||
                              value.toString().length < 5) {
                            return 'Senha muito curta!';
                          }
                        },
                        onSaved: (value) {
                          _authData['password'] = value.toString();
                        },
                      ),
                      sizedBox,
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Confirmar Senha',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return 'Senhas diferentes!';
                          }
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
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.red)
                                : const Text(
                                    'Criar conta',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                            onPressed: () async {
                              _submit();
                            },
                          ),
                        ),
                      const SizedBox(height: 30),
                      GestureDetector(
                        onTap: () {
                          if (widget.receivedArg.contains('authScreen')) {
                            Navigator.of(context).popAndPushNamed(
                                StartScreen.routeName,
                                arguments: "4");
                          } else if (widget.receivedArg.contains('carrinho')) {
                            Navigator.of(context).popAndPushNamed(
                                AuthScreen.routeName,
                                arguments: widget.receivedArg);
                          }
                        },
                        child: const Text(
                          'Voltar',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
