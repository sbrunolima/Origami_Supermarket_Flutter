import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/cart.dart';
import '../providers/frete_provider.dart';

class CartResumeBar extends StatefulWidget {
  // final String title;
  // final String price;

  // CartResumeBar(this.title, this.price);

  @override
  State<CartResumeBar> createState() => _CartResumeBarState();
}

class _CartResumeBarState extends State<CartResumeBar> {
  var _isLoading = false;
  var _isInit = true;
  double freteValor = 0;
  double finalValor = 0;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<FreteProvider>(context).loadFretes().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final freteData = Provider.of<FreteProvider>(context);
    for (int i = 0; i < freteData.frete.length; i++) {
      freteValor = double.parse(freteData.frete[i].valorFrete.toString());
      finalValor = cart.totalAmount + freteValor;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Resumo',
                style: GoogleFonts.openSans(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  barItems(
                    'Subtotal',
                    '${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(double.parse(cart.totalAmount.toString()))}',
                  ),
                  const Divider(),
                  barItems(
                    'Frete',
                    '${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(double.parse(freteValor.toString()))}',
                  ),
                  const Divider(),
                  barItems(
                    'Total do pedido',
                    '${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(double.parse(finalValor.toString()))}',
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget barItems(String title, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.openSans(
              color: Colors.grey.shade700,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            price,
            style: GoogleFonts.openSans(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
