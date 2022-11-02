import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../propagandas/home_advertisement.dart';
import '../widgets/promotions_overview.dart';
import '../providers/products_provider.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';
import '../widgets/buttons_list.dart';

class HomePageScreen extends StatefulWidget {
  static const routeName = '/home-page-screen';

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      Provider.of<ProductsProvider>(context, listen: false)
          .loadProducts()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      Provider.of<ProductsProvider>(context).showOfertas();
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final divider = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Divider(thickness: 1),
    );

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Image.asset('assets/ofertablank.png'),
        title: ListTile(
          leading: Image.asset(
            'assets/origami.png',
            scale: 6,
          ),
          title: Text(
            'E-Supermarket',
            style: GoogleFonts.openSans(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          //CART BUTTOn WITH NOTIFICATION
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () {
                Navigator.of(context).popAndPushNamed(CartScreen.routeName);
              },
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeAdvertisement(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Categorias',
                  style: GoogleFonts.openSans(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ButtonsList(),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Ofertas em destaque',
                  style: GoogleFonts.openSans(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              divider,
              const SizedBox(height: 5),
              PromotionsOverview(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
