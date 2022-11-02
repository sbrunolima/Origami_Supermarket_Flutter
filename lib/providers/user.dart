import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../providers/cidade.dart';

class NewUser {
  final String? id;
  final String? name;
  final String? fone;
  final String? rua;
  final String? complemento;
  final String? cidade;
  bool hasAddress;

  NewUser({
    @required this.id,
    @required this.name,
    @required this.fone,
    @required this.rua,
    @required this.complemento,
    @required this.cidade,
    this.hasAddress = false,
  });
}

class User with ChangeNotifier {
  List<NewUser> _users = [];
  List<Cidade> _cidade = [];

  final String authToken;
  final String userId;

  bool deliveryOK = false;

  User(this.authToken, this.userId, this._users);

  List<NewUser> get users {
    return [..._users];
  }

  List<Cidade> get cidade {
    return [..._cidade];
  }

  NewUser findById(String id) {
    return _users.firstWhere((user) => user.id == id);
  }

  //Adicoina os pedidos no API firebase
  Future<void> addUser(NewUser newUser) async {
    final url = Uri.parse('');
    final response = await http.post(
      url,
      body: json.encode(
        {
          'nome': newUser.name,
          'fone': newUser.fone,
          'rua': newUser.rua,
          'complemento': newUser.complemento,
          'cidade': newUser.cidade,
          'hasAddress': true,
        },
      ),
    );
    notifyListeners();
  }

  Future<void> fetchUserData() async {
    final url = Uri.parse('');

    final response = await http.get(url);
    final List<NewUser> loadedUser = [];
    final extraxtedData = json.decode(response.body) as Map<String, dynamic>;
    if (extraxtedData == null) {
      return;
    }

    extraxtedData.forEach((orderId, userData) {
      loadedUser.add(
        NewUser(
          id: orderId,
          name: userData['nome'],
          fone: userData['fone'],
          rua: userData['rua'],
          complemento: userData['complemento'],
          cidade: userData['cidade'],
          hasAddress: userData['hasAddress'],
        ),
      );
    });
    _users = loadedUser.toList();

    notifyListeners();
  }

  Future<void> updateUserAdress(String id, NewUser editedUser) async {
    final userIndex = _users.indexWhere((user) => user.id == id);
    if (userIndex >= 0) {
      final url = Uri.parse('');
      await http.patch(
        url,
        body: json.encode({
          'nome': editedUser.name,
          'fone': editedUser.fone,
          'rua': editedUser.rua,
          'complemento': editedUser.complemento,
          'cidade': editedUser.cidade,
          'hasAddress': editedUser.hasAddress,
        }),
      );
      _users[userIndex] = editedUser;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> clear() async {
    _users.clear();
    notifyListeners();
  }

  //Carrega cidades disponivies para entrega
  Future<void> loadCidades() async {
    final url = Uri.parse('');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Cidade> loadedCidades = [];
      extractedData.forEach((cidadeId, cidadeData) {
        loadedCidades.add(
          Cidade(
            id: cidadeId,
            cidadeName: cidadeData['cidade'],
          ),
        );
      });
      _cidade = loadedCidades;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> findCidades(String query) async {
    final url = Uri.parse('');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Cidade> loadedCidades = [];
      extractedData.forEach((cidadeId, cidadeData) {
        if (cidadeData['cidade'].toString().toLowerCase().replaceAll(' ', '') ==
            query.toLowerCase()) {
          deliveryOK = true;
          print('query: $query');
          print('cidade: ${cidadeData['cidade']}');
        }
      });
      _cidade = loadedCidades;

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
