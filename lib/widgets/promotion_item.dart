import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/cart.dart';
import '../data/product.dart';

class PromotionItem extends StatefulWidget {
  final String prodId;
  final double price;
  final String title;
  final String imageUrl;

  PromotionItem({
    required this.prodId,
    required this.price,
    required this.title,
    required this.imageUrl,
  });

  @override
  State<PromotionItem> createState() => _PromotionItemState();
}

class _PromotionItemState extends State<PromotionItem> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);

    return Consumer<Product>(
      builder: (ctx, product, child) => Container(
        height: 100,
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
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
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
                      widget.imageUrl.toString(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            Divider(thickness: 1, color: Colors.grey.shade300),
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
                    widget.prodId,
                    double.parse(widget.price.toString()),
                    widget.title.toString(),
                    widget.imageUrl.toString(),
                    widget.prodId.toString(),
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
                    '${widget.price}',
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
    );
  }
}
