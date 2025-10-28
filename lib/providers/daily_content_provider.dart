import 'dart:io';

import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;

import '../data/quote.dart';
import '../services/daily_content_service.dart';
import '../services/notification_service.dart';
import '../services/settings_service.dart';
import '../services/wallpaper_service.dart';

class DailyContentProvider extends ChangeNotifier {
  DailyContentProvider({
    required DailyContentService dailyContentService,
    required SettingsService settingsService,
    required NotificationService notificationService,
    required WallpaperService wallpaperService,
  })  : _dailyContentService = dailyContentService,
        _settingsService = settingsService,
        _notificationService = notificationService,
        _wallpaperService = wallpaperService,
        _themeMode = settingsService.loadThemeMode();

  final DailyContentService _dailyContentService;
  final SettingsService _settingsService;
  final NotificationService _notificationService;
  final WallpaperService _wallpaperService;

  Quote? _todayQuote;
  List<Quote> _highlights = <Quote>[];
  List<String> _categories = <String>[];
  bool _isLoading = false;
  ThemeMode _themeMode;

  Quote? get todayQuote => _todayQuote;
  List<Quote> get highlights => _highlights;
  List<String> get categories => _categories;
  bool get isLoading => _isLoading;
  ThemeMode get themeMode => _themeMode;
  bool get notificationsEnabled => _notificationService.notificationsEnabled;

  Future<void> refreshDailyContent() async {
    _isLoading = true;
    notifyListeners();
    try {
      final quote = await _dailyContentService.getQuoteForToday();
      final highlights = await _dailyContentService.getHighlights();
      final categories = await _dailyContentService.getCategories();
      _todayQuote = quote;
      _highlights = highlights;
      _categories = categories;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Quote>> loadCategory(String category) {
    return _dailyContentService.getByCategory(category);
  }

  Future<void> updateThemeMode(ThemeMode themeMode) async {
    _themeMode = themeMode;
    await _settingsService.updateThemeMode(themeMode);
    notifyListeners();
  }

  Future<void> enableNotifications(TimeOfDay timeOfDay) async {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    await _notificationService.scheduleDailyNotification(time: scheduled);
    await _settingsService.updateNotificationPreference(true);
    notifyListeners();
  }

  Future<void> disableNotifications() async {
    await _notificationService.cancelDailyNotification();
    await _settingsService.updateNotificationPreference(false);
    notifyListeners();
  }

  Future<File> generateWallpaper(GlobalKey repaintKey) async {
    return _wallpaperService.captureQuoteAsImage(repaintKey);
  }

  Future<void> applyWallpaper(File file) async {
    await _wallpaperService.setWallpaper(file);
  }
}
