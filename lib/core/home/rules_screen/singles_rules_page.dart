import 'package:flutter/material.dart';

class SinglesRulesPage extends StatelessWidget {
  const SinglesRulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Singles Rules"),
      ),
      body: const SingleChildScrollView(
        padding:  EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Singles Match Rules",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text("📌 Basic Rules",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(height: 6),
            Text("1. One batsman bats while all others do bowling and fielding."),
            Text("2. Batting order is decided before match begins."),
            Text("3. If a batsman gets out, the next in order comes in."),
            Text("4. Out batsmen continue as fielders."),
            SizedBox(height: 16),
            Text("🎯 Scoring",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(height: 6),
            Text("1. Runs are tracked for each batsman individually."),
            Text("2. Total runs are calculated at the end of the innings."),
            SizedBox(height: 16),
            Text("⚡ Gameplay",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            SizedBox(height: 6),
            Text("1. Overs can be unlimited or limited, based on match settings."),
            Text("2. Bowling is rotated among fielders."),
            Text("3. The game continues until all batsmen are out."),
          ],
        ),
      ),
    );
  }
}
