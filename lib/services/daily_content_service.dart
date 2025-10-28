import 'dart:math';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/quote.dart';
import '../data/quote_repository.dart';
import '../utils/constants.dart';

class DailyContentService {
  DailyContentService({
    required QuoteRepository quoteRepository,
    required SharedPreferences preferences,
  })  : _quoteRepository = quoteRepository,
        _preferences = preferences;

  final QuoteRepository _quoteRepository;
  final SharedPreferences _preferences;

  Future<Quote> getQuoteForToday() async {
    final todayKey = _dateKey(DateTime.now());
    final cachedId = _preferences.getString(kDailyQuotePrefKey);
    final cachedDate = _preferences.getString(kDailyQuoteDatePrefKey);

    if (cachedId != null && cachedDate == todayKey) {
      return _quoteRepository.findById(cachedId);
    }

    final quotes = await _quoteRepository.loadQuotes();
    final random = Random(todayKey.hashCode);
    final quote = quotes[random.nextInt(quotes.length)];

    await _preferences.setString(kDailyQuotePrefKey, quote.id);
    await _preferences.setString(kDailyQuoteDatePrefKey, todayKey);

    return quote;
  }

  Future<List<Quote>> getHighlights({int count = 5}) async {
    final quotes = await _quoteRepository.loadQuotes();
    return quotes.take(count).toList();
  }

  Future<List<String>> getCategories() => _quoteRepository.loadCategories();

  Future<List<Quote>> getByCategory(String category) =>
      _quoteRepository.loadByCategory(category);

  String _dateKey(DateTime dateTime) => DateFormat('yyyy-MM-dd').format(dateTime);
}
