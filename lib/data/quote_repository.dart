import 'dart:convert';

import 'package:flutter/services.dart';

import 'quote.dart';

class QuoteRepository {
  QuoteRepository();

  List<Quote>? _cache;

  Future<List<Quote>> loadQuotes() async {
    if (_cache != null) {
      return _cache!;
    }
    final data = await rootBundle.loadString('assets/quotes/quotes.json');
    final List<dynamic> jsonList = json.decode(data) as List<dynamic>;
    _cache = jsonList
        .map((dynamic item) => Quote.fromJson(item as Map<String, dynamic>))
        .toList();
    return _cache!;
  }

  Future<List<Quote>> loadByCategory(String category) async {
    final quotes = await loadQuotes();
    return quotes.where((quote) => quote.category == category).toList();
  }

  Future<Quote> findById(String id) async {
    final quotes = await loadQuotes();
    return quotes.firstWhere((quote) => quote.id == id);
  }

  Future<List<String>> loadCategories() async {
    final quotes = await loadQuotes();
    return quotes.map((quote) => quote.category).toSet().toList()..sort();
  }
}
