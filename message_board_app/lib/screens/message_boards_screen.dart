import 'package:flutter/material.dart';

class MessageBoardsScreen extends StatelessWidget {
  final List<Map<String, String>> boards = [
    {'name': 'Games', 'image': 'assets/games.png'},
    {'name': 'Business', 'image': 'assets/business.png'},
    {'name': 'Public Health', 'image': 'assets/publichealth.png'},
    {'name': 'Study', 'image': 'assets/study.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select A Room"),
        actions: [
          Builder(
            builder:
                (context) => IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Color(0xFF1E293B),
        child: ListView(
          children: [
            DrawerHeader(
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              title: Text("Profile", style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pushNamed(context, '/profile'),
            ),
            ListTile(
              title: Text("Settings", style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),
          ],
        ),
      ),

      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: boards.length,
        itemBuilder: (context, index) {
          final board = boards[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: GestureDetector(
              onTap:
                  () => Navigator.pushNamed(
                    context,
                    '/chat',
                    arguments: board['name'],
                  ),
              child: SizedBox(
                height: 130,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(board['image']!, fit: BoxFit.contain),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.5),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        bottom: 16,
                        child: Text(
                          board['name']!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                blurRadius: 6.0,
                                color: Colors.black,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
