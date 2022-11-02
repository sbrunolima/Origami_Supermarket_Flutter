import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../providers/cart.dart';
import '../data/http_exceptions.dart';

class OrderItem {
  final String? id;
  final double? amount;
  final List<CartItem>? products;
  final DateTime? dateTime;
  final String? paymentType;
  final String? troco;
  final String? description;
  final String? cpf;
  final String? address;
  final String? nomeTel;
  final double? frete;
  final double? cartAmount;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
    @required this.paymentType,
    @required this.troco,
    @required this.description,
    @required this.cpf,
    @required this.address,
    @required this.nomeTel,
    @required this.frete,
    @required this.cartAmount,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  //Adicoina os pedidos no API firebase
  Future<void> addOrder(
      List<CartItem> cartProducts,
      double total,
      String paymentType,
      String troco,
      String description,
      String cpf,
      String address,
      String nomeTel,
      double frete,
      double cartAmount) async {
    final url = Uri.parse('');
    //Data do aparelho do usuario
    final timestamp = DateTime.now();

    final response = await http.post(
      url,
      body: json.encode(
        {
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map(
                (cartProd) => {
                  'id': cartProd.id,
                  'title': cartProd.title,
                  'quantity': cartProd.quantity,
                  'price': cartProd.price,
                  'imageUrl': cartProd.imageUrl,
                },
              )
              .toList(),
          'paymentType': paymentType,
          'troco': troco,
          'description': description,
          'cpf': cpf,
          'address': address,
          'nomeTel': nomeTel,
          'frete': frete,
          'cartAmount': cartAmount,
        },
      ),
    );
    notifyListeners();
  }

  Future<void> adminOrder(
      List<CartItem> cartProducts,
      double total,
      String paymentType,
      String troco,
      String description,
      String cpf,
      String address,
      String nomeTel,
      double frete,
      double cartAmount) async {
    final url = Uri.parse('');
    //Data do aparelho do usuario
    final timestamp = DateTime.now();

    final response = await http.post(
      url,
      body: json.encode(
        {
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map(
                (cartProd) => {
                  'id': cartProd.id,
                  'title': cartProd.title,
                  'quantity': cartProd.quantity,
                  'price': cartProd.price,
                  'imageUrl': cartProd.imageUrl,
                },
              )
              .toList(),
          'paymentType': paymentType,
          'troco': troco,
          'description': description,
          'cpf': cpf,
          'address': address,
          'nomeTel': nomeTel,
          'frete': frete,
          'cartAmount': cartAmount,
        },
      ),
    );
    notifyListeners();
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse('');
    final response = await http.get(url);

    final List<OrderItem> loadedOrders = [];
    final extraxtedData = json.decode(response.body) as Map<String, dynamic>;
    if (extraxtedData == null) {
      return;
    }

    extraxtedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price'],
                    imageUrl: item['imageUrl'],
                  ))
              .toList(),
          dateTime: DateTime.parse(orderData['dateTime']),
          paymentType: orderData['paymentType'],
          troco: orderData['troco'],
          description: orderData['description'],
          cpf: orderData['cpf'],
          address: orderData['address'],
          nomeTel: orderData['nomeTel'],
          frete: orderData['frete'],
          cartAmount: orderData['cartAmount'],
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> deleteOrder(String id) async {
    final url = Uri.parse('');
    final existingOrderIndex = _orders.indexWhere((prod) => prod.id == id);
    var existingOrder = _orders[existingOrderIndex];

    _orders.removeAt(existingOrderIndex);
    notifyListeners();

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _orders.insert(existingOrderIndex, existingOrder);
      notifyListeners();
      throw HttpException('Não foi possível deletar o produto.');
    }
    existingOrder;
  }

  Future<void> clear() async {
    _orders.clear();
    notifyListeners();
  }
}
