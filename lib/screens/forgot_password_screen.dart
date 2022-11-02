import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/start_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  static const routeName = '/forget-password-screen';

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context)
            .popAndPushNamed(StartScreen.routeName, arguments: "4");

        return true;
      },
      child: Scaffold(
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
              Navigator.of(context)
                  .popAndPushNamed(StartScreen.routeName, arguments: "4");
            },
          ),
        ),
        body: Column(
          children: [
            Text('Entre com o e-mail cadastrado'),
            TextFormField(
              controller: emailController,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: 'E-mail',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
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
              onSaved: (value) {},
            ),
            SizedBox(
              height: 50,
              width: 350,
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                child: Text(
                  'Resetar senha',
                  style: GoogleFonts.openSans(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
