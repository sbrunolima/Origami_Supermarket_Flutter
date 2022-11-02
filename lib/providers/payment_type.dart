import 'package:flutter/cupertino.dart';

class PaymentType {
  String paymentType;

  PaymentType(this.paymentType);
}

class Payment with ChangeNotifier {
  String _payments = '';

  String get payment {
    return _payments;
  }

  int returnedPayment = 0;

  void setPayment(int opc) {
    if (opc == 1) {
      _payments = 'Cartão de Crédito';
    } else if (opc == 2) {
      _payments = 'Cartão de Débito';
    } else if (opc == 3) {
      _payments = 'Cartão Alimentação';
    } else if (opc == 4) {
      _payments = 'Dinheiro';
    }

    returnedPayment = opc;
    notifyListeners();
  }
}
