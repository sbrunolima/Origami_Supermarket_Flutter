import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/start_screen.dart';
import '../screens/cart_screen.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../widgets/products_overview.dart';
import '../providers/products_provider.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/search-screen';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late List<ProductsProvider> products;
  String query = '';
  var sendedArg = 'searchScreen';

  @override
  void initState() {
    Provider.of<ProductsProvider>(context, listen: false).showAll();
  }

  Future<void> searchProduct(String query) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .findedProducts(query);
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    return Scaffold(
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
            Navigator.of(context).popAndPushNamed(StartScreen.routeName);
          },
        ),
        title: Text(
          'Buscar Produto',
          style: GoogleFonts.openSans(
            color: Colors.blue,
            fontSize: 20,
            fontWeight: FontWeight.normal,
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
                Navigator.of(context).pushReplacementNamed(CartScreen.routeName,
                    arguments: sendedArg);
              },
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                onChanged: (value) {
                  searchProduct(value.toString());
                },
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Buscar Produto',
                  prefixIcon: const Icon(Icons.search, color: Colors.black),
                ),
              ),
            ),
            ProductsOverview(),
          ],
        ),
      ),
    );
  }
}
