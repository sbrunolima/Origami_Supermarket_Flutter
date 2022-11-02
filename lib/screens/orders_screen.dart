import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/orders.dart';
import '../widgets/order_items_list.dart';
import '../screens/start_screen.dart';
import '../providers/auth.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders-screen';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;
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
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);

    //Acessa os pedidos
    final orderData = Provider.of<Orders>(context);
    return WillPopScope(
      onWillPop: () async {
        if (receivedArg.contains('profileScreen')) {
          Navigator.of(context)
              .popAndPushNamed(StartScreen.routeName, arguments: '4');
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
              if (receivedArg.contains('profileScreen')) {
                Navigator.of(context)
                    .popAndPushNamed(StartScreen.routeName, arguments: '4');
              } else {
                Navigator.of(context).popAndPushNamed(StartScreen.routeName);
              }
            },
          ),
          title: Text(
            'Meus Pedidos',
            style: GoogleFonts.openSans(
              color: Colors.blue,
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        body: _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(
                      color: Colors.grey,
                    ),
                    SizedBox(height: 5),
                    Text('Carregando...'),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: orderData.orders.length <= 0
                    ? noItenOnCart()
                    : Column(
                        children: [
                          const SizedBox(height: 15),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: orderData.orders.length,
                            itemBuilder: (ctx, i) =>
                                OrdersItemsList(orderData.orders[i]),
                          ),
                        ],
                      ),
              ),
      ),
    );
  }

  Widget noItenOnCart() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 200),
          const Icon(
            Icons.shopping_cart,
            color: Colors.grey,
            size: 100,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Sua cesta está vazia, suas compras apareçerão aqui.',
              textAlign: TextAlign.center,
              style: GoogleFonts.openSans(
                color: Colors.grey,
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
