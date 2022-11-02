import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../providers/cart.dart';
import '../data/product.dart';

class ItemsOnCart extends StatefulWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;
  var image;

  ItemsOnCart(
    this.id,
    this.productId,
    this.price,
    this.quantity,
    this.title,
    this.image,
  );

  @override
  State<ItemsOnCart> createState() => _ItemsOnCartState();
}

class _ItemsOnCartState extends State<ItemsOnCart> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Consumer<Product>(
      builder: (ctx, product, child) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
        ),
        child: Row(
          children: [
            const SizedBox(height: 10, width: 10),
            Container(
              height: 100,
              width: 100,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  widget.image,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 200,
                  child: Text(
                    widget.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.openSans(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2).format(double.parse(widget.price.toString()))}',
                      style: GoogleFonts.openSans(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Container(
                  width: 200,
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 120,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade300,
                          ),
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.grey.shade300,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.remove,
                                size: 20,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                cart.removeSingleItem(widget.id);
                              },
                            ),
                            Container(
                              width: 20,
                              child: Text(
                                widget.quantity < 10
                                    ? '0${widget.quantity}'
                                    : '${widget.quantity}',
                                style: GoogleFonts.openSans(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.add,
                                size: 20,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                cart.addSingleItem(widget.id);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade300,
                              ),
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.grey.shade300,
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.delete_forever,
                                color: Colors.black87,
                                size: 23,
                              ),
                              onPressed: () {
                                cart.removeItem(widget.productId);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
