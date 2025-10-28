import 'dart:typed_data';

import 'package:daily_quotation_app/data/quote_repository.dart';
import 'package:daily_quotation_app/services/daily_content_service.dart';
import 'package:daily_quotation_app/utils/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DailyContentService', () {
    late DailyContentService service;
    late SharedPreferences preferences;

    setUp(() async {
      const quotesJson = '[{"id":"1","author":"Test","text":"Hello","category":"Test"}]';
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', (message) async {
        final assetKey = const StringCodec().decodeMessage(message);
        if (assetKey == 'assets/quotes/quotes.json') {
          final buffer = Uint8List.fromList(quotesJson.codeUnits).buffer;
          return ByteData.view(buffer);
        }
        return null;
      });
      SharedPreferences.setMockInitialValues(<String, Object>{});
      preferences = await SharedPreferences.getInstance();
      service = DailyContentService(
        quoteRepository: QuoteRepository(),
        preferences: preferences,
      );
    });

    test('returns a quote for today', () async {
      final quote = await service.getQuoteForToday();
      expect(quote.text, 'Hello');
      expect(preferences.getString(kDailyQuotePrefKey), quote.id);
    });
  });
}
