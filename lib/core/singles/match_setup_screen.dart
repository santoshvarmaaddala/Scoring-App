import 'package:flutter/material.dart';
import './singles_match_screen.dart';

class MatchSetupScreen extends StatefulWidget {
  final List<String> order;

  const MatchSetupScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<MatchSetupScreen> createState() => _MatchSetupScreenState();
}

class _MatchSetupScreenState extends State<MatchSetupScreen> {
  bool isLimitedOvers = true;
  int overs = 5;

  void startMatch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SinglesMatchScreen(
          battingOrder: widget.order,
          isLimitedOvers: isLimitedOvers,
          overs: overs,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Match Setup")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Select Match Type",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text("Limited Overs"),
                    value: true,
                    groupValue: isLimitedOvers,
                    onChanged: (val) => setState(() => isLimitedOvers = val!),
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text("Unlimited Overs"),
                    value: false,
                    groupValue: isLimitedOvers,
                    onChanged: (val) => setState(() => isLimitedOvers = val!),
                  ),
                ),
              ],
            ),
            if (isLimitedOvers)
              Row(
                children: [
                  const Text("Overs:"),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Slider(
                      value: overs.toDouble(),
                      min: 1,
                      max: 20,
                      divisions: 19,
                      label: "$overs",
                      onChanged: (val) =>
                          setState(() => overs = val.toInt()),
                    ),
                  ),
                  Text("$overs"),
                ],
              ),
            const Spacer(),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: startMatch,
              icon: const Icon(Icons.sports_cricket),
              label: const Text("Start Match"),
            ),
          ],
        ),
      ),
    );
  }
}
