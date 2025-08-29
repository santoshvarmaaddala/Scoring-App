import 'package:flutter/material.dart';
import '../../../db/database_helper.dart';
import '../data/player_model.dart';


class PlayerListPage extends StatefulWidget {
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
    }

  
    Future<void> addPlayerDialog() async {
      final nameController = TextEditingController();
      // final ageController = TextEditingController();

      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Add Player"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: InputDecoration(labelText: "Name")),
              // TextField(controller: ageController, decoration: InputDecoration(labelText: "Age"), keyboardType: TextInputType.number),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final player = Player(name: nameController.text, /* age: int.parse(ageController.text) */ );
                await DatabaseHelper.instance.insertPlayer(player);
                Navigator.of(ctx).pop();
                fetchPlayers();
              },
              child: Text("Save"),
            ),
          ],
        ),
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text("Players")),
        body: ListView.builder(
          itemCount: players.length,
          itemBuilder: (context, index) {
            final player = players[index];
            return ListTile(
              title: Text(player.name),
              // subtitle: Text("Age: ${player.age}"),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  await DatabaseHelper.instance.deletePlayer(player.id!);
                  fetchPlayers();
                },
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: addPlayerDialog,
          child: Icon(Icons.add),
        ),
      );
    }
}