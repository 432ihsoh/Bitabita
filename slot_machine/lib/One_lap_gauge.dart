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
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 750),
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
      _incrementCounter();
      _count--;
    }
  }

  void _incrementCounter() {
    setState(() {
      _count++;
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
          Text(
            'Count: $_count',
            style: const TextStyle(fontSize: 24),
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
        ],
      ),
    );
  }
}
