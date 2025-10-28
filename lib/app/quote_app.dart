import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/daily_content_provider.dart';
import '../ui/screens/home_screen.dart';
import '../ui/theme.dart';

class QuoteApp extends StatefulWidget {
  const QuoteApp({super.key});

  @override
  State<QuoteApp> createState() => _QuoteAppState();
}

class _QuoteAppState extends State<QuoteApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DailyContentProvider>().refreshDailyContent();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aurora Quotes',
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: context.watch<DailyContentProvider>().themeMode,
      home: const HomeScreen(),
    );
  }
}
