import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import '../data/quote_repository.dart';
import '../providers/daily_content_provider.dart';
import 'daily_content_service.dart';
import 'notification_service.dart';
import 'settings_service.dart';
import 'wallpaper_service.dart';

class AppBootstrapper {
  AppBootstrapper();

  late final QuoteRepository _quoteRepository;
  late final SettingsService _settingsService;
  late final DailyContentService _dailyContentService;
  late final NotificationService _notificationService;
  late final WallpaperService _wallpaperService;
  late final SharedPreferences _prefs;

  List<ChangeNotifierProvider> get providers {
    return <ChangeNotifierProvider>[
      ChangeNotifierProvider<DailyContentProvider>(
        create: (_) => DailyContentProvider(
          dailyContentService: _dailyContentService,
          settingsService: _settingsService,
          notificationService: _notificationService,
          wallpaperService: _wallpaperService,
        ),
      ),
    ];
  }

  Future<void> initialize() async {
    _quoteRepository = QuoteRepository();
    _prefs = await SharedPreferences.getInstance();
    _settingsService = SettingsService(_prefs);
    _dailyContentService = DailyContentService(
      quoteRepository: _quoteRepository,
      preferences: _prefs,
    );
    _notificationService = NotificationService(_prefs);
    _wallpaperService = WallpaperService();

    tz.initializeTimeZones();
    try {
      final locationName = DateTime.now().timeZoneName;
      tz.setLocalLocation(tz.getLocation(locationName));
    } catch (_) {
      // Fallback to UTC if the native timezone cannot be resolved in package:timezone.
      tz.setLocalLocation(tz.getLocation('UTC'));
    }
    await _notificationService.initialize();
    await MobileAds.instance.initialize();
  }
}
