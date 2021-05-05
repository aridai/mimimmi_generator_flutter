import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:mimimmi_generator_flutter/mimimmi_painter.dart';

/// 出力画像の生成ロジック
class OutputImageGenerator {
  /// 出力画像のBase64文字列を生成する。
  /// (PNG形式のBase64文字列でMIMEタイプ情報などは含まれない。)
  Future<String> generate(ui.Image img, String text) async {
    //  TODO: WebWorkerの検討

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final painter = MimimmiPainter(img, text);
    const size = Size(MimimmiPainter.width, MimimmiPainter.height);
    painter.paint(canvas, size);

    final picture = recorder.endRecording();
    final image = await picture.toImage(
      size.width.toInt(),
      size.height.toInt(),
    );
    final pingByteData = await image.toByteData(format: ui.ImageByteFormat.png);
    const encoder = Base64Encoder();
    final bytes = pingByteData!.buffer.asUint8List();
    final base64Str = encoder.convert(bytes);

    return base64Str;
  }
}
