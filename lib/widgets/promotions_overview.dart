import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../providers/products_provider.dart';
import '../providers/cart.dart';

class PromotionsOverview extends StatefulWidget {
  @override
  State<PromotionsOverview> createState() => _PromotionsOverviewState();
}

class _PromotionsOverviewState extends State<PromotionsOverview> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    final productsData = Provider.of<ProductsProvider>(context,
        listen: false); //Acessa ProductsProvider
    final products = productsData.items; // Carzega os dados de ProductsProvider

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: products.length,
      padding: const EdgeInsets.symmetric(horizontal: 2),
      itemBuilder: (ctx, i) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 0),
                      child: Image.asset(
                        'assets/oferta.png',
                        scale: 12,
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 120,
                  width: 120,
                  child: Image.network(
                    products[i].imageUrl.toString(),
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: Image.asset(
                          'assets/loading_image.png',
                          scale: 2,
                        ),
                      );
                    },
                  ),
                ),
                Divider(thickness: 1, color: Colors.grey.shade300),
                SizedBox(
                  height: 40,
                  width: 155,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: Colors.green,
                      onPrimary: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      textStyle:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      cart.addItem(
                        products[i].id.toString(),
                        products[i].oferta
                            ? double.parse(products[i].offerPrice.toString())
                            : double.parse(products[i].price.toString()),
                        products[i].title.toString(),
                        products[i].imageUrl.toString(),
                        products[i].id.toString(),
                      );

                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Item Adicionado ao Carrinho!',
                          ),
                          duration: Duration(milliseconds: 100),
                        ),
                      );
                    },
                    child: const Text(
                      'ADICIONAR',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: products[i].oferta
                      ? Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  'de ${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(double.parse(products[i].price.toString()))} por:',
                                  style: GoogleFonts.openSans(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    textStyle: const TextStyle(
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(double.parse(products[i].offerPrice.toString()))}',
                                  style: GoogleFonts.openSans(
                                    color: products[i].oferta
                                        ? Colors.red
                                        : Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(double.parse(products[i].price.toString()))}',
                                  style: GoogleFonts.openSans(
                                    color: products[i].oferta
                                        ? Colors.red
                                        : Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
                ListTile(
                  title: Container(
                    height: 60,
                    child: Text(
                      products[i].title.toString(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      textAlign: TextAlign.start,
                      style: GoogleFonts.openSans(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                products[i].granel
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Text(
                          'Item de peso variável. Seu valor total pode ser atualizado após a pesagem. ',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          textAlign: TextAlign.start,
                          style: GoogleFonts.openSans(
                            color: Colors.black,
                            fontSize: 10,
                          ),
                        ),
                      )
                    : const Text(''),
              ],
            ),
          ),
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 390,
      ),
    );
  }
}
