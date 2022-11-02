import 'package:flutter/foundation.dart';

class Links with ChangeNotifier {
  final String? id;
  final String? linkUrl;

  Links({
    @required this.id,
    @required this.linkUrl,
  });
}
