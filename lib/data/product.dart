import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String? id;
  final String? title;
  final String? price;
  final String? offerPrice;
  final String? imageUrl;
  final String? sector;
  bool oferta;
  bool granel;

  Product({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.offerPrice,
    @required this.imageUrl,
    @required this.sector,
    this.oferta = false,
    this.granel = false,
  });
}
