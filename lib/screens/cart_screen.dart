import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../providers/cart.dart';
import '../providers/user.dart';
import '../screens/start_screen.dart';
import '../providers/products_provider.dart';
import '../widgets/items_on_cart.dart';
import '../providers/auth.dart';
import '../screens/auth_screen.dart';
import '../screens/departments_screen.dart';
import '../screens/choose_address_screen.dart';
import '../screens/search_screen.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart-screen';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isInit = true;
  var receivedArg = "";
  var sendedArg = "carrinho";

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
    // Get all teh cart items
    final cart = Provider.of<Cart>(context);
    final productsData = Provider.of<ProductsProvider>(context);
    final auth = Provider.of<Auth>(context);
    final userData = Provider.of<User>(context);

    return WillPopScope(
      onWillPop: () async {
        if (receivedArg.contains('departamentos')) {
          Navigator.of(context).popAndPushNamed(DepartmentScreen.routeName);
        } else {
          Navigator.of(context).popAndPushNamed(StartScreen.routeName);
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
              if (receivedArg.contains('departamentos')) {
                Navigator.of(context)
                    .popAndPushNamed(DepartmentScreen.routeName);
              } else if (receivedArg.contains('todosProdutos')) {
                Navigator.of(context)
                    .popAndPushNamed(StartScreen.routeName, arguments: '1');
              } else if (receivedArg.contains('searchScreen')) {
                Navigator.of(context).popAndPushNamed(SearchScreen.routeName);
              } else {
                Navigator.of(context).popAndPushNamed(StartScreen.routeName);
              }
            },
          ),
          title: Text(
            'Carrinho de compras',
            style: GoogleFonts.openSans(
              color: Colors.blue,
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        body: cart.totalAmount <= 0
            ? noItenOnCart()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: cart.items.length,
                      itemBuilder: (ctx, i) => ItemsOnCart(
                        cart.items.values.toList()[i].id.toString(),
                        cart.items.keys.toList()[i].toString(),
                        double.parse(
                            cart.items.values.toList()[i].price.toString()),
                        int.parse(
                            cart.items.values.toList()[i].quantity.toString()),
                        cart.items.values.toList()[i].title.toString(),
                        cart.items.values.toList()[i].imageUrl.toString(),
                      ),
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
        persistentFooterButtons: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: GoogleFonts.openSans(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(double.parse(cart.totalAmount.toString()))}',
                          // ' ${.toStringAsFixed(2)}',
                          style: GoogleFonts.openSans(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
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
                      'Finalizar pedido',
                      style: GoogleFonts.openSans(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: cart.totalAmount <= 0
                        ? () {}
                        : () {
                            auth.isAuth
                                ? Navigator.of(context).popAndPushNamed(
                                    ChooseAddressScreen.routeName)
                                : Navigator.of(context).popAndPushNamed(
                                    AuthScreen.routeName,
                                    arguments: sendedArg);
                          },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget noItenOnCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart,
            size: 60,
            color: Colors.grey.shade500,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Ainda não há nenhum produto no seu carrinho.',
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                color: Colors.grey,
                fontSize: 22,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
