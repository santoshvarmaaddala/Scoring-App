import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../db/models/player_model.dart';
import 'player_edit_dialog.dart';
import '../ui/toast.dart';
import '../ui/operation_dialog.dart';

class PlayerListPage extends StatefulWidget {
  const PlayerListPage({Key? key}) : super(key: key);

  @override
  State<PlayerListPage> createState() => _PlayerListPageState();
}

class _PlayerListPageState extends State<PlayerListPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  List<Player> _players = [];

  @override
  void initState() {
    super.initState();
    _fetchPlayers();
  }

  Future<void> _fetchPlayers() async {
    final players = await _dbHelper.getPlayers();
    setState(() {
      _players = players;
    });
  }

  Future<void> _addPlayer() async {
    final nameController = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (_) => PlayerEditDialog(
        title: "Add Player",
        controller: nameController,
      ),
    );

    if (result != null && result.isNotEmpty) {
      try {
        await _dbHelper.insertPlayer(Player(name: result));
        showToast("✅ Player added successfully");
        _fetchPlayers();
      } catch (_) {
        showToast("⚠️ Player name already exists");
      }
    }
  }

  Future<void> _editPlayer(Player player) async {
    final nameController = TextEditingController(text: player.name);
    final result = await showDialog<String>(
      context: context,
      builder: (_) => PlayerEditDialog(
        title: "Edit Player",
        controller: nameController,
      ),
    );

    if (result != null && result.isNotEmpty) {
      try {
        await _dbHelper.updatePlayer(
          Player(id: player.id, name: result),
        );
        showToast("✅ Player updated");
        _fetchPlayers();
      } catch (_) {
        showToast("⚠️ Player name already exists");
      }
    }
  }

  Future<void> _deletePlayer(int id) async {
    await _dbHelper.deletePlayer(id);
    _fetchPlayers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Players")),
      body: _players.isEmpty
          ? const Center(child: Text("No players added yet."))
          : ListView.builder(
              itemCount: _players.length,
              itemBuilder: (context, index) {
                final player = _players[index];
                return ListTile(
                  title: Text(player.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _editPlayer(player),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          showConfirmationDialog(
                            context,
                            () {
                              _deletePlayer(player.id!); // Your delete function
                            },
                            'delete',

                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addPlayer,
        child: const Icon(Icons.add),
      ),
    );
  }
}
