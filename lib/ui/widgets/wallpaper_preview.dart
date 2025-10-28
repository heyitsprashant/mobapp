import 'package:flutter/material.dart';

import '../../data/quote.dart';

class WallpaperPreview extends StatelessWidget {
  const WallpaperPreview({super.key, required this.quote, required this.repaintKey});

  final Quote quote;
  final GlobalKey repaintKey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RepaintBoundary(
      key: repaintKey,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onPrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Text(
                      quote.category.toUpperCase(),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                quote.text,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  height: 1.3,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  quote.author,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
