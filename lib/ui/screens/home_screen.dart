import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/daily_content_provider.dart';
import '../widgets/daily_quote_view.dart';
import '../widgets/highlight_carousel.dart';
import '../widgets/loading_view.dart';
import '../widgets/quote_categories_sheet.dart';
import 'settings_screen.dart';
import 'wallpaper_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DailyContentProvider>();

    final tabs = <Widget>[
      _buildDailyTab(provider),
      WallpaperScreen(provider: provider),
      SettingsScreen(provider: provider),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aurora Quotes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: provider.refreshDailyContent,
            tooltip: 'Refresh content',
          ),
          IconButton(
            icon: const Icon(Icons.category_outlined),
            onPressed: () => _showCategories(context, provider),
            tooltip: 'Explore categories',
          ),
        ],
      ),
      body: provider.isLoading
          ? const LoadingView()
          : AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: tabs[_index],
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.sunny_snowing),
            label: 'Daily',
          ),
          NavigationDestination(
            icon: Icon(Icons.wallpaper),
            label: 'Wallpapers',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  Widget _buildDailyTab(DailyContentProvider provider) {
    final quote = provider.todayQuote;
    if (quote == null) {
      return const Center(child: Text('No quote available yet.'));
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        DailyQuoteView(quote: quote),
        const SizedBox(height: 24),
        HighlightCarousel(quotes: provider.highlights),
      ],
    );
  }

  Future<void> _showCategories(
    BuildContext context,
    DailyContentProvider provider,
  ) async {
    final categories = provider.categories;
    if (!context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => QuoteCategoriesSheet(
        categories: categories,
        provider: provider,
      ),
    );
  }
}
