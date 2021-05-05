import 'dart:ui' as ui;

import 'package:mimimmi_generator_flutter/mimimmi_image_provider.dart';
import 'package:mimimmi_generator_flutter/output_image_generator.dart';
import 'package:rxdart/rxdart.dart';

/// ミミッミジェネレータのページのBLoC
class GeneratorPageBloc {
  GeneratorPageBloc(this._imgProvider, this._outputGenerator) {
    _loadImg();
  }

  /// ミミッミのセリフの初期値
  static const initialText = 'にぇにぇ';

  final MimimmiImageProvider _imgProvider;
  final OutputImageGenerator _outputGenerator;

  final _img = BehaviorSubject<ui.Image?>.seeded(null);
  final _text = BehaviorSubject.seeded(initialText);
  final _isGenerating = BehaviorSubject.seeded(false);
  final _toOutputPageEvent = PublishSubject<String>();

  /// ミミッミの画像
  Stream<ui.Image?> get img => _img;

  /// ミミッミのセリフ
  Stream<String> get text => _text.stream;

  /// ミミッミのセリフのSink
  Sink<String> get textSink => _text.sink;

  /// 画像の生成処理が走っているかどうか
  Stream<bool> get isGenerating => _isGenerating.stream;

  /// 出力ページへの遷移を通知するイベント
  Stream<String> get toOutputPageEvent => _toOutputPageEvent.stream;

  /// 画像出力が要求されたとき。
  Future<void> onOutputRequest() async {
    _isGenerating.add(true);

    final mimimmiImg = _img.requireValue!;
    final currentText = _text.requireValue;
    final result = await _outputGenerator.generate(mimimmiImg, currentText);

    _toOutputPageEvent.add(result);
    _isGenerating.add(false);
  }

  /// 終了処理を行う。
  void dispose() {
    _img.close();
    _text.close();
    _isGenerating.close();
    _toOutputPageEvent.close();
  }

  //  画像を読み込む。
  Future<void> _loadImg() async {
    final img = await _imgProvider.provide();
    _img.add(img);
  }
}
