import 'package:flutter/material.dart';

import '../../providers/daily_content_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key, required this.provider});

  final DailyContentProvider provider;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: <Widget>[
        const Text(
          'Personalize your daily inspiration and app experience.',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
        const Text('Appearance', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SegmentedButton<ThemeMode>(
          segments: const <ButtonSegment<ThemeMode>>[
            ButtonSegment<ThemeMode>(
              value: ThemeMode.system,
              label: Text('System'),
              icon: Icon(Icons.settings_suggest_outlined),
            ),
            ButtonSegment<ThemeMode>(
              value: ThemeMode.light,
              label: Text('Light'),
              icon: Icon(Icons.light_mode_outlined),
            ),
            ButtonSegment<ThemeMode>(
              value: ThemeMode.dark,
              label: Text('Dark'),
              icon: Icon(Icons.dark_mode_outlined),
            ),
          ],
          selected: <ThemeMode>{provider.themeMode},
          onSelectionChanged: (value) {
            provider.updateThemeMode(value.first);
          },
        ),
        const SizedBox(height: 24),
        const Text('Daily reminder', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SwitchListTile.adaptive(
          value: provider.notificationsEnabled,
          title: const Text('Enable daily reminder'),
          subtitle: const Text('Send a notification each morning with a fresh quote.'),
          onChanged: (value) async {
            if (value) {
              final time = await showTimePicker(
                context: context,
                initialTime: const TimeOfDay(hour: 7, minute: 0),
              );
              if (time != null) {
                await provider.enableNotifications(time);
              }
            } else {
              await provider.disableNotifications();
            }
          },
        ),
        const SizedBox(height: 24),
        const Text('Monetization toolkit', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text(
          'Integrate ad unit IDs from Google AdMob in production and explore premium
in-app purchases for ad-free experiences or exclusive quote packs.',
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: () {
            showLicensePage(context: context);
          },
          icon: const Icon(Icons.description_outlined),
          label: const Text('Open source licenses'),
        ),
      ],
    );
  }
}
