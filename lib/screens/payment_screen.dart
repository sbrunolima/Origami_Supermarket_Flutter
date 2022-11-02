import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/cart.dart';
import '../providers/payment_type.dart';
import '../screens/finish_cards_screen.dart';
import '../screens/finish_money_screen.dart';
import '../screens/choose_address_screen.dart';
import '../widgets/cart_resume_bar_widget.dart';

class PaymentScreen extends StatefulWidget {
  static const routeName = '/payment-screen';

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int opc = 0;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).popAndPushNamed(ChooseAddressScreen.routeName);
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
                  .popAndPushNamed(ChooseAddressScreen.routeName);
            },
          ),
          title: Text(
            'Pagamento',
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
                  'FORMA DE PAGAMENTO',
                  style: GoogleFonts.openSans(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      paymentCard('assets/credit.png', 'Cartão de Crédito', 1),
                      paymentCard('assets/debit.png', 'Cartão de Débito', 2),
                      paymentCard(
                          'assets/aliment.png', 'Cartão Alimentação', 3),
                      paymentMoney('assets/money.png', 'Dinheiro', 4),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5),
              CartResumeBar(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget paymentCard(String image, String paymentType, int opc) {
    return GestureDetector(
      onTap: () {
        Provider.of<Payment>(context, listen: false).setPayment(opc);
        Navigator.of(context).popAndPushNamed(FinishCardScreen.routeName);
      },
      child: Padding(
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
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }

  Widget paymentMoney(String image, String paymentType, int opc) {
    return GestureDetector(
      onTap: () {
        Provider.of<Payment>(context, listen: false).setPayment(opc);
        Navigator.of(context).popAndPushNamed(FinishMoneyScreen.routeName);
      },
      child: Padding(
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
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
