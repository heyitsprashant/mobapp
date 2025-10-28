# Aurora Quotes

Aurora Quotes is a Flutter application designed for Android and iOS that delivers
a premium daily quotation experience. Users receive an inspirational quote every
morning, can generate bespoke wallpapers with the quote of the day, browse
categories, and configure reminders — all with monetization hooks for future
revenue opportunities.

## Features

- **Daily inspiration:** deterministic quote-of-the-day selection cached in local
  storage so each user sees a consistent message throughout the day.
- **Wallpaper generator:** render the quote of the day as an aesthetic gradient
  wallpaper and apply it directly to the device using platform wallpaper APIs.
- **Category exploration:** browse curated quote categories and view themed
  collections in a modal dialog.
- **Reminders:** schedule a daily push notification at the user’s preferred time
  using `flutter_local_notifications` and `timezone`.
- **Monetization ready:** integrates the Google Mobile Ads SDK and documents how
  to swap placeholder IDs for production. The settings page highlights premium
  upsell opportunities such as ad-free plans or exclusive quote packs.
- **Dynamic theming:** toggle between light, dark, and system themes.

## Getting started

1. [Install Flutter](https://docs.flutter.dev/get-started/install) (3.13 or newer).
2. From the repository root, run `flutter pub get` to install dependencies.
3. Configure a Firebase or custom backend if you plan to sync quotes remotely.
   The current build ships with local JSON seed data located in
   `assets/quotes/quotes.json`.
4. Run the application:
   ```bash
   flutter run
   ```

## Notifications configuration

- iOS requires requesting permission before scheduling reminders. Extend the
  bootstrap logic (for example, in `main.dart`) to prompt the user on first run.
- Android 13+ devices also require notification runtime permission. The
  `NotificationService` is ready to handle the scheduling once permissions are
  granted.

## Wallpaper integration

The wallpaper flow captures the preview widget to a PNG file and uses
`wallpaper_manager_flutter` to apply it. Additional permissions are required on
Android (`SET_WALLPAPER`, `WRITE_EXTERNAL_STORAGE` for legacy devices). Update
`AndroidManifest.xml` and `Info.plist` once the Flutter tooling generates the
platform folders.

## Monetization tips

- Replace test AdMob IDs with production ones in `main.dart` or a dedicated ad
  manager before releasing.
- Consider gating premium wallpapers, removing ads, or offering share packs via
  in-app purchases (`in_app_purchase` package) as future enhancements.

## Testing

Widget tests can be added under `test/` to validate providers and UI widgets.
Run the full test suite with:

```bash
flutter test
```

## Contributing

1. Fork the repository.
2. Create a feature branch: `git checkout -b feature/amazing-idea`.
3. Commit changes with descriptive messages.
4. Open a pull request and describe your updates.
