import 'package:flutter/material.dart';

class MessageBoardsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> boards = [
    {'name': 'General', 'icon': Icons.chat},
    {'name': 'Tech', 'icon': Icons.computer},
    {'name': 'Sports', 'icon': Icons.sports_soccer},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Message Boards')),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text("Menu")),
            ListTile(
              title: Text("Message Boards"),
              onTap: () => Navigator.pushNamed(context, '/home'),
            ),
            ListTile(
              title: Text("Profile"),
              onTap: () => Navigator.pushNamed(context, '/profile'),
            ),
            ListTile(
              title: Text("Settings"),
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: boards.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(boards[index]['icon']),
            title: Text(boards[index]['name']),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/chat',
                arguments: boards[index]['name'],
              );
            },
          );
        },
      ),
    );
  }
}
