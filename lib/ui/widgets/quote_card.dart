import 'package:flutter/material.dart';

import '../../data/quote.dart';

class QuoteCard extends StatelessWidget {
  const QuoteCard({super.key, required this.quote});

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theme.colorScheme.surfaceVariant,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(
              quote.text,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            quote.author,
            style: theme.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: <Widget>[
              FilterChip(
                label: Text(quote.category),
                onSelected: (_) {},
              ),
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () {
                  // integrate share_plus when running on device
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sharing requires share_plus integration.')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
