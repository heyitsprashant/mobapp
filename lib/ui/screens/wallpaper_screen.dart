import 'dart:io';

import 'package:flutter/material.dart';

import '../../data/quote.dart';
import '../../providers/daily_content_provider.dart';
import '../widgets/wallpaper_preview.dart';

class WallpaperScreen extends StatefulWidget {
  const WallpaperScreen({super.key, required this.provider});

  final DailyContentProvider provider;

  @override
  State<WallpaperScreen> createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> {
  final GlobalKey _previewKey = GlobalKey();
  File? _wallpaperFile;
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final quote = widget.provider.todayQuote;
    if (quote == null) {
      return const Center(child: Text('Load today\'s quote to generate a wallpaper.'));
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Expanded(
            child: WallpaperPreview(
              quote: quote,
              repaintKey: _previewKey,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _isProcessing ? null : () => _exportWallpaper(context, quote),
            icon: _isProcessing
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.image_outlined),
            label: const Text('Generate wallpaper'),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: _wallpaperFile == null || _isProcessing
                ? null
                : () => _applyWallpaper(context),
            icon: const Icon(Icons.wallpaper),
            label: const Text('Set as device wallpaper'),
          ),
        ],
      ),
    );
  }

  Future<void> _exportWallpaper(BuildContext context, Quote quote) async {
    setState(() => _isProcessing = true);
    try {
      final file = await widget.provider.generateWallpaper(_previewKey);
      setState(() => _wallpaperFile = file);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Wallpaper for '${quote.author}' saved temporarily.")),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to export wallpaper: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<void> _applyWallpaper(BuildContext context) async {
    final file = _wallpaperFile;
    if (file == null) {
      return;
    }
    setState(() => _isProcessing = true);
    try {
      await widget.provider.applyWallpaper(file);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wallpaper applied successfully.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to set wallpaper: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }
}
