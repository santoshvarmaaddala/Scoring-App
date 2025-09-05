// lib/features/home/presentation/home_screen.dart
import 'package:flutter/material.dart';
import 'package:singles_match_scoring/core/home/rules_screen/singles_rules_page.dart';
import '../singles/batting_order.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cricket Scoring App"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        
        child: Column(
          
          children: [
            Center(
              child: _HomeTile(
                width: screenWidth * 0.9,
                title: "Singles",
                banner:"https://placehold.co/400x200/png",
                onStart: () {
                  Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const BattingOrderScreen()
                  )
                );
                },
                onRules: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SinglesRulesPage())
                  );
                },
              ),
            ),
            
            Center(
              child: _HomeTile(
                width: screenWidth * 0.9,
                title: "Match",
                banner: "https://placehold.co/400x200/png",
                onStart: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Start Match clicked")),
                  );
                },
                onRules: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Match Rules clicked")),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeTile extends StatelessWidget {
  final double width;
  final String title;
  final String banner;
  final VoidCallback onStart;
  final VoidCallback onRules;

  const _HomeTile({
    required this.width,
    required this.title,
    required this.banner,
    required this.onStart,
    required this.onRules,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              banner,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: onRules,
                  child: const Text("Rules"),
                ),
                ElevatedButton(
                  onPressed: onStart,
                  child: const Text("Start Match"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
