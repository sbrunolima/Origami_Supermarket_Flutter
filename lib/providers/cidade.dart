import 'package:flutter/foundation.dart';

class Cidade with ChangeNotifier {
  final String? id;
  final String? cidadeName;

  Cidade({
    @required this.id,
    @required this.cidadeName,
  });
}
