import 'dart:math';
import 'package:flutter/material.dart';

class TossScreen extends StatefulWidget {
  const TossScreen({super.key});

  @override
  _TossScreenState createState() => _TossScreenState();
}

class _TossScreenState extends State<TossScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String result = "Tap the coin!";
  bool isFlipping = false;
  bool showHeads = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void tossCoin() async {
    if (isFlipping) return;

    setState(() => isFlipping = true);
    await _controller.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    await _controller.reverse();

    bool heads = Random().nextBool();
    setState(() {
      showHeads = heads;
      result = heads ? "Heads" : "Tails";
      isFlipping = false;
    });
  }

  Widget _buildCoinSide(bool isHeads) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isHeads ? Colors.amber : Colors.blueAccent,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Text(
          isHeads ? "Heads" : "Tails",
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Toss Coin")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: tossCoin,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  double angle = _animation.value;
                  bool isFront = angle < pi / 2;
                  return Transform(
                    transform: Matrix4.rotationY(angle),
                    alignment: Alignment.center,
                    child: _buildCoinSide(isFront ? showHeads : !showHeads),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              result,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
