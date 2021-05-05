import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// ミミッミの画像を提供するロジック
class MimimmiImageProvider {
  static const _assetPath = 'assets/mimimmi.png';

  /// ミミッミの画像を提供する。
  Future<ui.Image> provide() async {
    const assetImg = AssetImage(_assetPath);
    final stream = assetImg.resolve(ImageConfiguration.empty);
    final completer = Completer<ImageInfo>();
    stream.addListener(
      ImageStreamListener(
        (info, _) => completer.complete(info),
        onError: (error, stack) => completer.completeError(error, stack),
      ),
    );

    return (await completer.future).image;
  }
}
