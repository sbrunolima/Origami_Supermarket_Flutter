import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/cart.dart';
import '../data/product.dart';

class AllProductItem extends StatefulWidget {
  @override
  State<AllProductItem> createState() => _AllProductItemState();
}

class _AllProductItemState extends State<AllProductItem> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);

    return Consumer<Product>(
      builder: (ctx, product, child) => Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(6),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Container(
                child: Column(
                  children: [
                    product.oferta
                        ? promotion('assets/oferta.png')
                        : promotion('assets/ofertablank.png'),
                    Container(
                      height: 120,
                      width: 120,
                      child: Image.network(
                        product.imageUrl.toString(),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 1, color: Colors.grey),
              SizedBox(
                height: 40,
                width: 150,
                child: ElevatedButton(
                  style: ButtonStyle(
                    overlayColor:
                        MaterialStateColor.resolveWith((states) => Colors.red),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                  onPressed: () {
                    cart.addItem(
                      product.id.toString(),
                      double.parse(product.price.toString()),
                      product.title.toString(),
                      product.imageUrl.toString(),
                      product.id.toString(),
                    );
                    print(product.id);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Item Adicionado ao Carrinho!',
                        ),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                  child: const Text(
                    'ADICIONAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Text(
                      'R\$ ',
                      style: GoogleFonts.openSans(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${product.price}',
                      style: GoogleFonts.openSans(
                        color: product.oferta ? Colors.red : Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Container(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    product.title.toString(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.openSans(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget promotion(String image) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Image.asset(
            image,
            scale: 12,
          ),
        ),
      ],
    );
  }
}
