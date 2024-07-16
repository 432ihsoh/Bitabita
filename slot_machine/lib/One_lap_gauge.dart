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

  int _count = 0;
  int _bitaCount = 0;
  final FocusNode _focusNode = FocusNode();
  bool _isInTimingWindow = false;
  bool _isBitaSccess = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 750),
      vsync: this,
    )
      ..addListener(_updateTimingWindow)
      ..repeat();
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
      _incrementCounter();
      _count--;
      if (_isBitaSccess) {
        _bitaCount--;
      }
    }
  }

  void _incrementCounter() {
    setState(() {
      _count++;
      if (_isInTimingWindow) {
        _bitaCount++;
        _isBitaSccess = true;
      } else {
        _isBitaSccess = false;
      }
    });
  }

  void _updateTimingWindow() {
    double gaugeValue = _controller.value;
    setState(() {
      _isInTimingWindow = (gaugeValue >= 0.962 && gaugeValue <= 1.0) ||
          (gaugeValue >= 0.0 && gaugeValue <= 0.038);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _handleKeyEvent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FractionallySizedBox(
            widthFactor: 3 / 5,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return SizedBox(
                    height: 20,
                    child: LinearProgressIndicator(
                      minHeight: 5,
                      value: _controller.value,
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _controller.value >= 0.962 || _controller.value <= 0.038
                            ? Colors.red
                            : Colors.blue,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'ボタンを押した回数: $_count',
            style: const TextStyle(
              fontSize: 24,
              color: Colors.black,
              decoration: TextDecoration.underline,
              decorationColor: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'ビタ押し成功回数: $_bitaCount',
            style: const TextStyle(
              fontSize: 24,
              color: Colors.black,
              decoration: TextDecoration.underline,
              decorationColor: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            autofocus: true,
            onFocusChange: (hasFocus) {
              if (!hasFocus) {
                _focusNode.requestFocus();
              }
            },
            onPressed: _incrementCounter,
            child: const Text('PUSH'),
          ),
          const SizedBox(width: 20), // ボタン間のスペース
          ElevatedButton(
            // 戻るボタン
            onPressed: () {
              Navigator.of(context).pop(); // 前の画面に戻る
            },
            child: const Text('戻る'),
          ),
        ],
      ),
    );
  }
}
