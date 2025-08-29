import 'package:flutter/material.dart';


void main() {
    runApp(SinglesMatchApp());
}

class SinglesMatchApp extends StatelessWidget {
  const SinglesMatchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Singles Match Scoring',
      theme: ThemeData(primarySwatch: Colors.green),
      home: PlayerRegistrationScreen(),
    );
  }
}

class PlayerRegistrationScreen extends StatelessWidget {
  const PlayerRegistrationScreen({super.key});

    @override
    Widget build (BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: const Text("Player Registration")),
            body: Center(
                child: ElevatedButton(
                    onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => BattingOrderScreen()),
                        );
                    }, 
                    child: const Text("Next: Batting Order"), 
                ),
            ),
        );
    }
}

class BattingOrderScreen extends StatelessWidget {
  const BattingOrderScreen({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: const Text("Batting Order")),
            body: Center(
                child: ElevatedButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => MatchScreen()),
                    );
                }, child: const Text("Next: Start Match")),
            ),
        );
    }
}

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key});

    @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Match DashBoard")),
        body: const Center( child: Text("Match in Progress")),
    );
  }
}