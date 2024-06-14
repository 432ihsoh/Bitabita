import 'package:flutter/material.dart';

class OneLapGauge extends StatefulWidget {
  const OneLapGauge({super.key});

  @override
  State<OneLapGauge> createState() => _OneLapGaugeState();
}

class _OneLapGaugeState extends State<OneLapGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isResetting = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 750),
      vsync: this,
    )..repeat(); // 初期状態でループを開始
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _resetGauge() {
    setState(() {
      _isResetting = true;
    });
    _controller.reset();
    _controller.forward().then((_) {
      setState(() {
        _isResetting = false;
      });
      _controller.repeat(); // リセット後にループを再開
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
        const SizedBox(height: 20), // ボタンとの間隔
        ElevatedButton(
          onPressed: _isResetting ? null : _resetGauge, // リセット中なら無効化
          child: const Text('Reset'),
        ),
      ],
    );
  }
}
