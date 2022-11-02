import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../providers/cart.dart';
import '../providers/orders.dart';
import '../providers/payment_type.dart';
import '../screens/payment_screen.dart';
import '../providers/user.dart';
import '../screens/orders_screen.dart';
import '../providers/frete_provider.dart';

class FinishMoneyScreen extends StatefulWidget {
  static const routeName = '/finish-money-screen';

  @override
  State<FinishMoneyScreen> createState() => _FinishMoneyScreenState();
}

class _FinishMoneyScreenState extends State<FinishMoneyScreen> {
  var _isLoading = false;
  final _observation = FocusNode();
  final _form = GlobalKey<FormState>();

  var troco = '';
  var description = '';
  var cpf = '';
  var address = '';
  var nomeTel = '';
  double freteValor = 0;
  double finalValor = 0;

  var _continue = false;

  @override
  void dispose() {
    _observation.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    } else {
      _continue = true;
      _form.currentState!.save();
    }
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
    final cart = Provider.of<Cart>(context);
    final payment = Provider.of<Payment>(context);
    final userData = Provider.of<User>(context);
    final freteData = Provider.of<FreteProvider>(context);

    for (int i = 0; i < freteData.frete.length; i++) {
      freteValor = double.parse(freteData.frete[i].valorFrete.toString());
      finalValor = cart.totalAmount + freteValor;
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).popAndPushNamed(PaymentScreen.routeName);
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
                  .pushReplacementNamed(PaymentScreen.routeName);
            },
          ),
          title: Text(
            'Finalizar Compra',
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
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'FORMA DE PAGAMENTO SELECIONADA',
                  style: GoogleFonts.openSans(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              const SizedBox(height: 6),
              paymentWidget(
                payment.returnedPayment == 1
                    ? 'assets/credit.png'
                    : payment.returnedPayment == 2
                        ? 'assets/debit.png'
                        : payment.returnedPayment == 3
                            ? 'assets/aliment.png'
                            : 'assets/money.png',
                payment.payment,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Form(
                  // Pega os dados do usuario
                  key: _form,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.shade300,
                        ),
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          titleOPC('Troco? Para qual valor?', true),
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Digite o valor'),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Entre com o VALOR.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              troco = value.toString();
                            },
                          ),
                          const SizedBox(height: 10),
                          titleOPC('CPF na nota?', false),
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: 'Digite o CPF'),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (value) {
                              _saveForm();
                            },
                            onSaved: (value) {
                              cpf = value.toString();
                            },
                          ),
                          const SizedBox(height: 10),
                          titleOPC('Observações:', false),
                          TextFormField(
                            decoration: const InputDecoration(labelText: ''),
                            maxLines: 5,
                            keyboardType: TextInputType.multiline,
                            focusNode: _observation,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (value) {
                              _saveForm();
                            },
                            onSaved: (value) {
                              description = value.toString();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total:  ',
                      style: GoogleFonts.openSans(
                        color: Colors.grey.shade700,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(double.parse(finalValor.toString()))}',
                      style: GoogleFonts.openSans(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _isLoading
                    ? const CircularProgressIndicator(color: Colors.grey)
                    : SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.green.shade600),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          child: Text(
                            'Finalizar',
                            style: GoogleFonts.openSans(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () async {
                            _saveForm();

                            setState(() {
                              _isLoading = true;
                            });

                            for (int i = 0; i < userData.users.length; i++) {
                              setState(
                                () {
                                  address =
                                      ('${userData.users[i].rua.toString()}, ${userData.users[i].complemento.toString()}, ${userData.users[i].cidade.toString()}');
                                  nomeTel =
                                      ('${userData.users[i].name.toString()}, ${userData.users[i].fone.toString()}');
                                },
                              );
                            }

                            if (_continue) {
                              await Provider.of<Orders>(context, listen: false)
                                  .addOrder(
                                cart.items.values.toList(),
                                finalValor,
                                payment.payment,
                                troco == '' ? 'Não' : troco,
                                description == '' ? 'Nenhuma' : description,
                                cpf == '' ? 'Nenhuma' : cpf,
                                address.toString(),
                                nomeTel.toString(),
                                freteValor,
                                cart.totalAmount,
                              );

                              await Provider.of<Orders>(context, listen: false)
                                  .adminOrder(
                                cart.items.values.toList(),
                                finalValor,
                                payment.payment,
                                troco == '' ? 'Não' : troco,
                                description == '' ? 'Nenhuma' : description,
                                cpf == '' ? 'Nenhuma' : cpf,
                                address.toString(),
                                nomeTel.toString(),
                                freteValor,
                                cart.totalAmount,
                              );

                              cart.clear();

                              popDialog(context);
                            }

                            setState(() {
                              _isLoading = false;
                            });
                          },
                        ),
                      ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future popDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
          border: Border.all(),
        ),
        child: AlertDialog(
          title: Center(
            child: Text(
              'Pedido Enviado!',
              style: GoogleFonts.openSans(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Container(
            child: Text(
              'Seu pedido foi enviado com sucesso! Dentro de instantes entraremos em contado com você.',
              style: GoogleFonts.openSans(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          actions: [
            Center(
              child: SizedBox(
                height: 50,
                width: 250,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  child: Text(
                    'Continuar',
                    style: GoogleFonts.openSans(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => OrdersScreen(),
                      ),
                      (route) => false,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget paymentWidget(String image, String paymentType) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade300,
            ),
            color: Colors.white,
            borderRadius: BorderRadius.circular(5)),
        child: ListTile(
          leading: Image.asset(image),
          title: Text(
            paymentType,
            style: GoogleFonts.openSans(
              color: Colors.black,
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget titleOPC(String title, bool opc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.openSans(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
        opc
            ? Text(
                '(obrigatório)',
                style: GoogleFonts.openSans(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              )
            : const Text(''),
      ],
    );
  }
}
