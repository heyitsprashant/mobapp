import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/quote_app.dart';
import 'providers/daily_content_provider.dart';
import 'services/app_bootstrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final bootstrapper = AppBootstrapper();
  await bootstrapper.initialize();

  runApp(
    MultiProvider(
      providers: bootstrapper.providers,
      child: const QuoteApp(),
    ),
  );
}
