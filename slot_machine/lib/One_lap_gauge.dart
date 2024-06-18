import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OneLapGauge extends StatefulWidget {
  const OneLapGauge({super.key});

  @override
  State<OneLapGauge> createState() => _OneLapGaugeState();
}

class _OneLapGaugeState extends State<OneLapGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final FocusNode _focusNode = FocusNode(); // FocusNodeを定義

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 780),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.space &&
        event.runtimeType == RawKeyDownEvent) {
      // スペースキーが押された時の処理
      print('PUSHボタンが押されました (スペースキー)');
    }
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _handleKeyEvent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return SizedBox(
                height: 20,
                child: LinearProgressIndicator(
                  value: _controller.value,
                  backgroundColor: Colors.grey,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            autofocus: true, // ボタンに自動的にフォーカスを当てる
            onFocusChange: (hasFocus) {
              if (!hasFocus) {
                _focusNode.requestFocus(); // フォーカスが外れたら再取得
              }
            },
            onPressed: () {
              print('PUSHボタンが押されました');
            },
            child: const Text('PUSH'),
          ),
        ],
      ),
    );
  }
}
