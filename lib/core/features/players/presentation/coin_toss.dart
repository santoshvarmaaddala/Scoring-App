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
  late Animation<double> _flipAnimation;
  late Animation<double> _scaleAnimation;
  String result = "Tap the coin!";
  bool isFlipping = false;
  bool showHeads = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3), // longer spin duration
      vsync: this,
    );

    // Flip rotation
    _flipAnimation = Tween<double>(begin: 0, end: 4 * pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Scaling (zoom in/out while flipping)
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 50),
    ]).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  void tossCoin() async {
    if (isFlipping) return;

    setState(() {
      isFlipping = true;
      result = "Flipping...";
    });

    await _controller.forward();

    bool heads = Random().nextBool();
    bool fakeCall = !heads; // opposite shown first

    // Show the fake call
    setState(() {
      showHeads = heads;
      result = fakeCall ? "Heads" : "Tails";
    });

    // Pause for suspense
    await Future.delayed(const Duration(milliseconds: 800));

    // Reveal the actual result
    setState(() {
      result = heads ? "Heads" : "Tails";
      isFlipping = false;
    });

    _controller.reset();
  }

  Widget _buildCoinSide(bool isHeads) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: isHeads
              ? [Colors.amber.shade700, Colors.orangeAccent]
              : [Colors.blueAccent, Colors.lightBlueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(4, 6),
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
                animation: _controller,
                builder: (context, child) {
                  double angle = _flipAnimation.value;
                  bool isFront = (angle % (2 * pi)) < pi;

                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..rotateY(angle)
                      ..scale(_scaleAnimation.value),
                    child: _buildCoinSide(isFront ? showHeads : !showHeads),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            AnimatedOpacity(
              opacity: isFlipping ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 400),
              child: Text(
                result,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
