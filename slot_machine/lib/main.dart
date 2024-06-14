import 'package:flutter/material.dart';
import 'one_lap_gauge.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ...
      home: Scaffold(
        appBar: AppBar(
          title: const Text('One Lap Gauge'), // タイトルも変更
        ),
        body: const Center(
          child: OneLapGauge(), // インポートしたクラスを使用
        ),
      ),
    );
  }
}
