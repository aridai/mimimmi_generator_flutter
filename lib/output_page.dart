import 'dart:html';

import 'package:flutter/material.dart';
import 'package:mimimmi_generator_flutter/mimimmi_painter.dart';
import 'package:mimimmi_generator_flutter/platform_view.dart';

const _viewType = 'OUTPUT_PAGE_IMG';
final ImageElement _htmlImageElement = ImageElement();

/// 出力ページの初期化処理を行う。
void initOutputPage() {
  registerViewFactory(_viewType, (id) => _htmlImageElement);
}

/// 出力ページ
class OutputPage extends StatefulWidget {
  const OutputPage(this.result);

  final String result;

  @override
  State<StatefulWidget> createState() => _OutputPageState();
}

class _OutputPageState extends State<OutputPage> {
  @override
  void initState() {
    super.initState();

    _htmlImageElement.src = 'data:image/png;base64,${widget.result}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('出力画像')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: const AspectRatio(
            aspectRatio: MimimmiPainter.ratio,
            child: HtmlElementView(viewType: _viewType),
          ),
        ),
      ),
    );
  }
}
