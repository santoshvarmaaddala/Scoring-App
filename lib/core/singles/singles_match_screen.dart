// lib/core/singles/singles_match_screen.dart
import 'package:flutter/material.dart';

class SinglesMatchScreen extends StatefulWidget {
  final List<String> battingOrder;
  final bool isLimitedOvers;
  final int overs;

  const SinglesMatchScreen({
    Key? key,
    required this.battingOrder,
    required this.isLimitedOvers,
    required this.overs,
  }) : super(key: key);

  @override
  State<SinglesMatchScreen> createState() => _SinglesMatchScreenState();
}

class _SinglesMatchScreenState extends State<SinglesMatchScreen> {
  int totalRuns = 0;
  int wickets = 0;
  int balls = 0;

  late String striker;
  late List<String> remainingBatters;
  late List<String> bowlersPool;
  String? currentBowler;

  @override
  void initState() {
    super.initState();
    striker = widget.battingOrder.first;
    remainingBatters = widget.battingOrder.skip(1).toList();
    bowlersPool = List.from(widget.battingOrder)..remove(striker);
    currentBowler = bowlersPool.isNotEmpty ? bowlersPool.first : null;
  }

  void _addRuns(int runs) {
    setState(() {
      totalRuns += runs;
      balls++;
      if (runs.isOdd) {
        _rotateStrike();
      }
      _checkOverCompletion();
    });
  }

  void _wicketFallen() {
    setState(() {
      wickets++;
      balls++;
      if (remainingBatters.isNotEmpty) {
        striker = remainingBatters.removeAt(0);
        bowlersPool = List.from(widget.battingOrder)
          ..removeWhere((p) => p == striker || widget.battingOrder.indexOf(p) < wickets);
        if (bowlersPool.isNotEmpty) {
          currentBowler = bowlersPool.first;
        }
      } else {
        _endInnings();
      }
      _checkOverCompletion();
    });
  }

  void _extraRun(String type) {
    setState(() {
      totalRuns++;
      // Wide/No ball doesn’t count as legal delivery
    });
  }

  void _rotateStrike() {
    // In singles, only one batsman on field.
    // But for realism, we rotate strike with runs.
    // So striker stays same unless wicket falls.
  }

  void _checkOverCompletion() {
    if (balls % 6 == 0) {
      // Rotate bowler
      if (bowlersPool.isNotEmpty) {
        bowlersPool.remove(currentBowler);
        if (bowlersPool.isEmpty) {
          bowlersPool = List.from(widget.battingOrder)..remove(striker);
        }
        currentBowler = bowlersPool.first;
      }
    }

    // End match if limited overs reached
    if (widget.isLimitedOvers &&
        balls >= widget.overs * 6) {
      _endInnings();
    }
  }

  void _endInnings() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Innings Over"),
        content: Text("Final Score: $totalRuns/$wickets"),
        actions: [
          TextButton(
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  String get oversDisplay => "${balls ~/ 6}.${balls % 6}";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Singles Match")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Scoreboard
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text("Score: $totalRuns/$wickets",
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text("Overs: $oversDisplay",
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(height: 8),
                    Text("Batsman: $striker",
                        style: const TextStyle(fontSize: 18)),
                    if (currentBowler != null)
                      Text("Bowler: $currentBowler",
                          style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Action buttons
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  for (var run in [0, 1, 2, 3, 4, 6])
                    ElevatedButton(
                      onPressed: () => _addRuns(run),
                      child: Text("$run"),
                    ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: _wicketFallen,
                    child: const Text("Wicket"),
                  ),
                  ElevatedButton(
                    onPressed: () => _extraRun("Wide"),
                    child: const Text("Wide"),
                  ),
                  ElevatedButton(
                    onPressed: () => _extraRun("No Ball"),
                    child: const Text("No Ball"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
