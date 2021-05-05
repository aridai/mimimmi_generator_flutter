import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// ミミッミ描画用のCustomPainter
class MimimmiPainter extends CustomPainter {
  const MimimmiPainter(this._img, this._text);

  static const double width = 1280;
  static const double height = 720;
  static const double ratio = width / height;

  static final _paint = Paint();

  final ui.Image _img;
  final String _text;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / width, size.height / height);

    canvas.drawImage(_img, Offset.zero, _paint);

    final lines = _text.split('\n');
    for (var i = 0; i < lines.length; i++) {
      const x = 80.0;
      const y = 460.0;
      const lineHeight = 72.0;
      final offset = Offset(x, y + lineHeight * i);

      final span = TextSpan(
        text: lines[i],
        style: const TextStyle(fontSize: 48, color: Colors.black),
      );
      final painter = TextPainter(text: span, textDirection: TextDirection.ltr)
        ..layout();

      painter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
