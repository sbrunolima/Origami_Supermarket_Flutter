import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../data/http_exceptions.dart';
import '../screens/signup_screen.dart';
import '../screens/start_screen.dart';
import '../screens/choose_address_screen.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth-screen';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
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
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        if (receivedArg.contains('carrinho')) {
          Navigator.of(context)
              .popAndPushNamed(StartScreen.routeName, arguments: "3");
        } else {
          Navigator.of(context).popAndPushNamed(StartScreen.routeName);
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
              if (receivedArg.contains('carrinho')) {
                Navigator.of(context)
                    .popAndPushNamed(StartScreen.routeName, arguments: "3");
              } else {
                Navigator.of(context).popAndPushNamed(StartScreen.routeName);
              }
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              AutorizationCard(sendedArg.toString(), receivedArg.toString()),
            ],
          ),
        ),
      ),
    );
  }
}

class AutorizationCard extends StatefulWidget {
  final String sendedArg;
  final String receivedArg;

  AutorizationCard(this.sendedArg, this.receivedArg);

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
  var _isFormOk = true;
  final _passwordController = TextEditingController();

  var _isInit = true;

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
      setState(() {
        _isFormOk = false;
      });
      return;
    }

    _formKey.currentState!.save();
    setState(() {
      _isFormOk = true;
      _isLoading = true;
    });

    try {
      await Provider.of<Auth>(context, listen: false).login(
        _authData['email'].toString(),
        _authData['password'].toString(),
      );

      if (widget.receivedArg.contains('carrinho')) {
        Navigator.of(context).popAndPushNamed(ChooseAddressScreen.routeName);
      } else {
        Navigator.of(context).popAndPushNamed(StartScreen.routeName);
      }
    } on HttpException catch (error) {
      String errorMessage = 'Falha de autenticação.';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'E-mail em uso.';
      } else if (error.toString().contains('INVALID_EXISTS')) {
        errorMessage = 'E-mail inválido.';
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
    final user = Provider.of<Auth>(context, listen: false);
    final deviceSize = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Image.asset(
              'assets/origami.png',
              scale: 1.5,
            ),
            const SizedBox(height: 10),
            Container(
              height: _isFormOk ? 280 : 300,
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
                            borderRadius: BorderRadius.circular(6)),
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
                          return 'E-mail Inválido!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['email'] = value.toString();
                      },
                    ),
                    SizedBox(height: !_isFormOk ? 8 : 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6)),
                      ),
                      obscureText: true,
                      controller: _passwordController,
                      validator: (value) {
                        if (value.toString().isEmpty ||
                            value.toString().length < 5) {
                          return 'Senha inválida!';
                        }
                      },
                      onSaved: (value) {
                        _authData['password'] = value.toString();
                      },
                    ),
                    if (_authMode == AutorizationMode.Signup)
                      TextFormField(
                        enabled: _authMode == AutorizationMode.Signup,
                        decoration:
                            const InputDecoration(labelText: 'Confirmar Senha'),
                        obscureText: true,
                        validator: _authMode == AutorizationMode.Signup
                            ? (value) {
                                if (value != _passwordController.text) {
                                  return 'Senhas diferentes!';
                                }
                              }
                            : null,
                      ),
                    SizedBox(height: !_isFormOk ? 8 : 20),
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
                          child: Text(
                            'Acessar conta',
                            style: GoogleFonts.openSans(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: _submit,
                        ),
                      ),
                    const SizedBox(height: 30),
                    // GestureDetector(
                    //   onTap: () {
                    //     Navigator.of(context)
                    //         .popAndPushNamed(ForgotPasswordScreen.routeName);
                    //   },
                    //   child: Text(
                    //     'Esqueci minha senha',
                    //     style: GoogleFonts.openSans(
                    //       color: Colors.black,
                    //       fontSize: 16,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Ainda não possui uma conta?',
              style: GoogleFonts.openSans(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 50,
              width: 330,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.red.shade500),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                child: Text(
                  'Cadastre-se',
                  style: GoogleFonts.openSans(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  if (widget.receivedArg.contains('carrinho')) {
                    Navigator.of(context).popAndPushNamed(
                        SignupScreen.routeName,
                        arguments: widget.receivedArg);
                  } else {
                    Navigator.of(context).popAndPushNamed(
                        SignupScreen.routeName,
                        arguments: widget.sendedArg);
                  }
                },
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
