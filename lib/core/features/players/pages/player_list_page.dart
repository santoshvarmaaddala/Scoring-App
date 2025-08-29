// lib/features/players/pages/player_list_page.dart
import 'package:flutter/material.dart';
import '../../../db/database_helper.dart';
import '../data/player_model.dart';

class PlayerListPage extends StatefulWidget {
  const PlayerListPage({super.key});

  @override
  _PlayerListPageState createState() => _PlayerListPageState();
}

class _PlayerListPageState extends State<PlayerListPage> {
  List<Player> players = [];

  @override
  void initState() {
    super.initState();
    fetchPlayers();
  }

  Future<void> fetchPlayers() async {
    final data = await DatabaseHelper.instance.getPlayers();
    setState(() {
      players = data;
    });
    debugPrint('Loaded players: $players');
  }

  Future<void> addPlayerDialog() async {
    final nameController = TextEditingController();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add Player"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: "Name"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isEmpty) {
                // quick feedback
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a name')));
                return;
              }
              await DatabaseHelper.instance.insertPlayer(Player(name: name));
              Navigator.of(ctx).pop();
              await fetchPlayers();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // no controller to dispose here because created per dialog
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Players")),
      body: players.isEmpty
          ? const Center(child: Text('No players added yet'))
          : ListView.builder(
              itemCount: players.length,
              itemBuilder: (context, index) {
                final player = players[index];
                return ListTile(
                  title: Text(player.name),
                  subtitle: player.age != null ? Text('Age: ${player.age}') : null,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      if (player.id != null) {
                        await DatabaseHelper.instance.deletePlayer(player.id!);
                        await fetchPlayers();
                      }
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: addPlayerDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
