import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(SlotMachineApp());
}

class SlotMachineApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Slot Machine',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SlotMachinePage(),
    );
  }
}

class SlotMachinePage extends StatefulWidget {
  @override
  _SlotMachinePageState createState() => _SlotMachinePageState();
}

class _SlotMachinePageState extends State<SlotMachinePage>
    with TickerProviderStateMixin {
  final List<String> symbols = [
    "🍒",
    "⬛",
    "🍊",
    "🍇",
    "🔔",
    "⭐",
    "🍉",
    "7⃣",
    "🍍",
    "🏁",
    "🤔",
    "🍌",
    "🥝",
    "🥭",
    "🤔",
    "🤔",
    "🤔",
    "🍑",
    "🥥",
    "🍅"
  ];
  List<AnimationController> _controllers = [];
  List<Animation<double>> _animations = [];
  List<int> reelValues = [0, 0, 0];
  List<ScrollController> _scrollControllers = [];
  List<bool> spinning = [false, false, false];
  Random random = Random();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 3; i++) {
      AnimationController controller = AnimationController(
        duration:
            const Duration(milliseconds: 780), // 0.78 seconds per rotation
        vsync: this,
      );
      _controllers.add(controller);
      _animations.add(Tween<double>(begin: 0, end: symbols.length.toDouble())
          .animate(controller));
      _scrollControllers.add(ScrollController());
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var scrollController in _scrollControllers) {
      scrollController.dispose();
    }
    super.dispose();
  }

  void startSpinning() {
    setState(() {
      spinning = [true, true, true];
    });
    for (var controller in _controllers) {
      controller.repeat();
    }
    _spinReels();
  }

  void stopSpinning(int reelIndex) {
    if (!spinning[reelIndex]) return;
    _controllers[reelIndex].stop();
    setState(() {
      reelValues[reelIndex] = random.nextInt(symbols.length);
      _scrollControllers[reelIndex].jumpTo(reelValues[reelIndex] * 128.0);
      spinning[reelIndex] = false;
    });
  }

  Future<void> _spinReels() async {
    while (spinning.contains(true)) {
      setState(() {
        for (int i = 0; i < _scrollControllers.length; i++) {
          if (spinning[i]) {
            _scrollControllers[i].jumpTo(
                _scrollControllers[i].offset + random.nextDouble() * 128);
          }
        }
      });
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Slot Machine'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 64,
                    height: 128,
                    child: ListView.builder(
                      controller: _scrollControllers[index],
                      itemBuilder: (context, i) {
                        return Center(
                          child: Text(
                            symbols[i % symbols.length],
                            style: TextStyle(fontSize: 32),
                          ),
                        );
                      },
                      itemCount: symbols.length * 50, // Arbitrary large number
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: startSpinning,
                  child: Text('START'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => stopSpinning(0),
                  child: Text('STOP 1'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => stopSpinning(1),
                  child: Text('STOP 2'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => stopSpinning(2),
                  child: Text('STOP 3'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
