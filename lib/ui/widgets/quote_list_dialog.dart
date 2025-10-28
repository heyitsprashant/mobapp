import 'package:flutter/material.dart';

import '../../data/quote.dart';

class QuoteListDialog extends StatelessWidget {
  const QuoteListDialog({super.key, required this.category, required this.quotes});

  final String category;
  final List<Quote> quotes;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Quotes • $category'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final quote = quotes[index];
            return ListTile(
              title: Text(quote.text),
              subtitle: Text(quote.author),
            );
          },
          separatorBuilder: (_, __) => const Divider(),
          itemCount: quotes.length,
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
