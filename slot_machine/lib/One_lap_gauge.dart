import 'package:flutter/material.dart';

class OneLapGauge extends StatefulWidget {
  const OneLapGauge({super.key});

  @override
  State<OneLapGauge> createState() => _OneLapGaugeState();
}

class _OneLapGaugeState extends State<OneLapGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 780), // 0.78秒
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          height: 20, // ゲージの高さ（適宜調整）
          child: LinearProgressIndicator(
            value: _controller.value,
            backgroundColor: Colors.grey,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        );
      },
    );
  }
}
