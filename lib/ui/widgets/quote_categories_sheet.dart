import 'package:flutter/material.dart';

import '../../providers/daily_content_provider.dart';
import 'quote_list_dialog.dart';

class QuoteCategoriesSheet extends StatelessWidget {
  const QuoteCategoriesSheet({
    super.key,
    required this.categories,
    required this.provider,
  });

  final List<String> categories;
  final DailyContentProvider provider;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final category = categories[index];
          return ListTile(
            title: Text(category),
            leading: const Icon(Icons.label_outline),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _openCategory(context, category),
          );
        },
        separatorBuilder: (_, __) => const Divider(),
        itemCount: categories.length,
      ),
    );
  }

  Future<void> _openCategory(BuildContext context, String category) async {
    final quotes = await provider.loadCategory(category);
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (_) => QuoteListDialog(category: category, quotes: quotes),
    );
  }
}
