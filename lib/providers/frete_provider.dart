import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Frete with ChangeNotifier {
  String? id;
  String? valorFrete;

  Frete({
    @required this.id,
    @required this.valorFrete,
  });
}

class FreteProvider with ChangeNotifier {
  List<Frete> _frete = [];

  List<Frete> get frete {
    return [..._frete];
  }

  Future<void> loadFretes() async {
    final url = Uri.parse('');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Frete> loadedFrete = [];
      extractedData.forEach((freteId, freteData) {
        loadedFrete.add(
          Frete(
            id: freteId,
            valorFrete: freteData['frete'],
          ),
        );
      });

      _frete = loadedFrete;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
