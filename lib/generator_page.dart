import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:mimimmi_generator_flutter/generator_page_bloc.dart';
import 'package:mimimmi_generator_flutter/mimimmi_image_provider.dart';
import 'package:mimimmi_generator_flutter/mimimmi_painter.dart';
import 'package:mimimmi_generator_flutter/output_image_generator.dart';
import 'package:mimimmi_generator_flutter/output_page.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

/// ミミッミジェネレータのページ
class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<GeneratorPageBloc>(
      create: (context) => GeneratorPageBloc(
        MimimmiImageProvider(),
        OutputImageGenerator(),
      ),
      dispose: (context, bloc) => bloc.dispose(),
      child: _GeneratorPage(),
    );
  }
}

class _GeneratorPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<_GeneratorPage> {
  final _compositeSubscription = CompositeSubscription();
  late final TextEditingController _textController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final bloc = Provider.of<GeneratorPageBloc>(context);

    _textController = TextEditingController(
      text: GeneratorPageBloc.initialText,
    );

    bloc.text.listen((text) {
      _textController.value = _textController.value.copyWith(text: text);
    }).addTo(_compositeSubscription);

    bloc.toOutputPageEvent
        .listen((result) async => _toOutputPage(result))
        .addTo(_compositeSubscription);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<GeneratorPageBloc>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('ミミッミジェネレータ')),
      body: SingleChildScrollView(child: _buildBody(bloc)),
    );
  }

  @override
  void dispose() {
    _compositeSubscription.dispose();
    _textController.dispose();
    super.dispose();
  }

  //  ボディ部を生成する。
  Widget _buildBody(GeneratorPageBloc bloc) {
    return StreamBuilder<ui.Image?>(
      stream: bloc.img,
      builder: (context, snapshot) {
        final img = snapshot.data;
        if (img == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return _buildContent(bloc, img);
      },
    );
  }

  //  メインコンテンツを生成する。
  Widget _buildContent(GeneratorPageBloc bloc, ui.Image img) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMimimmiPreview(bloc, img),
          _instructionText,
          _buildTextField(bloc),
          _buildOutputButton(bloc),
        ],
      ),
    );
  }

  //  ミミッミのプレビューを生成する。
  Widget _buildMimimmiPreview(GeneratorPageBloc bloc, ui.Image img) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: AspectRatio(
          aspectRatio: MimimmiPainter.ratio,
          child: StreamBuilder<String>(
            stream: bloc.text,
            initialData: GeneratorPageBloc.initialText,
            builder: (context, snapshot) {
              final text = snapshot.requireData;

              return CustomPaint(painter: MimimmiPainter(img, text));
            },
          ),
        ),
      ),
    );
  }

  //  テキストフィールドを生成する。
  Widget _buildTextField(GeneratorPageBloc bloc) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _textController,
        minLines: 1,
        maxLines: 3,
        onChanged: (text) => bloc.textSink.add(text),
        decoration: const InputDecoration(hintText: 'ミミッミのセリフ'),
      ),
    );
  }

  //  指示文
  static const _instructionText = Padding(
    padding: EdgeInsets.fromLTRB(16, 32, 16, 0),
    child: Text(
      'ミミッミのセリフを考えよう!',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );

  //  出力ボタンを生成する。
  Widget _buildOutputButton(GeneratorPageBloc bloc) {
    return Container(
      padding: const EdgeInsets.all(32),
      alignment: Alignment.center,
      child: StreamBuilder<bool>(
          stream: bloc.isGenerating,
          initialData: false,
          builder: (context, snapshot) {
            final isIndicatorVisible = snapshot.requireData;
            if (isIndicatorVisible) return const CircularProgressIndicator();

            return ElevatedButton(
              onPressed: () async => bloc.onOutputRequest(),
              child: const Text('画像出力'),
            );
          }),
    );
  }

  //  出力ページに遷移する。
  Future<void> _toOutputPage(String result) async {
    final route = MaterialPageRoute<void>(
      builder: (context) => OutputPage(result),
    );
    await Navigator.push(context, route);
  }
}
