import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

import '../utils/constants.dart';

class NotificationService {
  NotificationService(this._preferences);

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final SharedPreferences _preferences;

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleDailyNotification({required tz.TZDateTime time}) async {
    const androidDetails = AndroidNotificationDetails(
      'daily_quote_channel',
      'Daily Quote',
      channelDescription: 'Daily reminder for inspirational quotes',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    const iosDetails = DarwinNotificationDetails();

    await _notificationsPlugin.zonedSchedule(
      1,
      'Your daily inspiration awaits',
      'Open Aurora Quotes to reveal today\'s message',
      time,
      const NotificationDetails(android: androidDetails, iOS: iosDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
    await _preferences.setBool(kNotificationEnabledPrefKey, true);
  }

  Future<void> cancelDailyNotification() async {
    await _notificationsPlugin.cancel(1);
    await _preferences.setBool(kNotificationEnabledPrefKey, false);
  }

  bool get notificationsEnabled =>
      _preferences.getBool(kNotificationEnabledPrefKey) ?? false;
}
