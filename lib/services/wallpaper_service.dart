import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';

class WallpaperService {
  WallpaperService();

  Future<File> captureQuoteAsImage(GlobalKey repaintKey) async {
    final boundary = repaintKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary?;
    if (boundary == null) {
      throw Exception('Unable to capture wallpaper preview.');
    }
    final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw Exception('Failed to encode wallpaper image.');
    }
    final Uint8List pngBytes = byteData.buffer.asUint8List();
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/daily_quote.png');
    await file.writeAsBytes(pngBytes, flush: true);
    return file;
  }

  Future<void> setWallpaper(File file) async {
    await WallpaperManagerFlutter().setwallpaperfromFile(file, WallpaperManagerFlutter.HOME_SCREEN);
  }
}
