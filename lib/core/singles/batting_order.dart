// batting_order.dart
import 'dart:math';
import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../db/models/player_model.dart';
import 'match_setup_screen.dart';

class BattingOrderScreen extends StatefulWidget {
  const BattingOrderScreen({Key? key}) : super(key: key);

  @override
  State<BattingOrderScreen> createState() => _BattingOrderScreenState();
}

class _BattingOrderScreenState extends State<BattingOrderScreen> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<String> allPlayers = [];
  List<String> selectedPlayers = [];
  bool selectAll = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPlayers();
  }

  Future<void> _fetchPlayers() async {
    final playersFromDb = await _dbHelper.getPlayers(); // Assuming this returns List<Player>
    setState(() {
      allPlayers = playersFromDb.map((p) => p.name).toList();
      isLoading = false;
    });
  }

  void toggleSelectAll(bool? value) {
    setState(() {
      selectAll = value ?? false;
      if (selectAll) {
        selectedPlayers = List.from(allPlayers);
      } else {
        selectedPlayers.clear();
      }
    });
  }

  void togglePlayerSelection(String player, bool selected) {
    setState(() {
      if (selected) {
        selectedPlayers.add(player);
      } else {
        selectedPlayers.remove(player);
      }
      selectAll = selectedPlayers.length == allPlayers.length;
    });
  }

  void addNewPlayer(String newPlayer) async {
    if (newPlayer.trim().isEmpty) return;
    await _dbHelper.insertPlayer(Player(name: newPlayer)); // Persist to DB
    await _fetchPlayers();
    setState(() {
      selectedPlayers.add(newPlayer);
      selectAll = selectedPlayers.length == allPlayers.length;
    });
  }

  void startMatch() {
    if (selectedPlayers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one player!")),
      );
      return;
    }

    List<String> randomizedOrder = List.from(selectedPlayers)..shuffle(Random());
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BattingOrderResultScreen(order: randomizedOrder),
      ),
    );
  }

  void showAddPlayerDialog() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Player"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Enter player name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              addNewPlayer(controller.text);
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Batting Order"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: showAddPlayerDialog,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : allPlayers.isEmpty
              ? const Center(child: Text("No players found. Add some!"))
              : Column(
                  children: [
                    CheckboxListTile(
                      title: const Text("Select All"),
                      value: selectAll,
                      onChanged: toggleSelectAll,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: allPlayers.length,
                        itemBuilder: (context, index) {
                          final player = allPlayers[index];
                          return CheckboxListTile(
                            title: Text(player),
                            value: selectedPlayers.contains(player),
                            onChanged: (bool? selected) {
                              togglePlayerSelection(player, selected ?? false);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: startMatch,
        icon: const Icon(Icons.sports_cricket),
        label: const Text("Start Match"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class BattingOrderResultScreen extends StatelessWidget {
  final List<String> order;

  const BattingOrderResultScreen({Key? key, required this.order})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Batting Order")),
      body: ListView.builder(
        itemCount: order.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(child: Text("${index + 1}")),
            title: Text(order[index]),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>  MatchSetupScreen(order: order),
              ),
            );
          },
          icon: const Icon(Icons.arrow_forward),
          label: const Text("Continue to Match Setup"),
        ),
      ),
    );
  }
}
