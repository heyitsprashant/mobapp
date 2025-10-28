import 'package:flutter/material.dart';

import '../../data/quote.dart';
import 'quote_card.dart';

class HighlightCarousel extends StatelessWidget {
  const HighlightCarousel({super.key, required this.quotes});

  final List<Quote> quotes;

  @override
  Widget build(BuildContext context) {
    if (quotes.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Trending quotes',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => QuoteCard(quote: quotes[index]),
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemCount: quotes.length,
          ),
        ),
      ],
    );
  }
}
