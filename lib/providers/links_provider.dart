import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../providers/links.dart';

class LinksProvider with ChangeNotifier {
  List<Links> _links = [];

  List<Links> get links {
    return [..._links];
  }

  // ADD LINKS e ADIT LINKS
  Future<void> updateLinks(String id, Links newLink) async {
    final linkIndex = _links.indexWhere((link) => link.id == id);
    if (linkIndex >= 0) {
      final url = Uri.parse('');
      await http.patch(
        url,
        body: json.encode({
          'link': newLink.linkUrl,
        }),
      );
      _links[linkIndex] = newLink;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> loadLinks() async {
    final url = Uri.parse('');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Links> loadedLinks = [];
      extractedData.forEach((linkId, linkData) {
        loadedLinks.add(
          Links(
            id: linkId,
            linkUrl: linkData['link'],
          ),
        );
      });
      _links = loadedLinks;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
