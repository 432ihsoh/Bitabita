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
      duration: const Duration(milliseconds: 780),
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
    return Column(
      // Columnでゲージとボタンを縦に並べる
      mainAxisAlignment: MainAxisAlignment.center, // 縦方向中央揃え
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
        const SizedBox(height: 20), // ゲージとボタンの間隔
        ElevatedButton(
          // ElevatedButtonウィジェットでボタンを作成
          onPressed: () {
            // ボタンが押された時の処理をここに記述
            // 例: print('PUSHボタンが押されました');
          },
          child: const Text('PUSH'), // ボタンのテキスト
        ),
      ],
    );
  }
}
