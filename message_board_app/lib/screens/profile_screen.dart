import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("User info will be shown here"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save profile changes
              },
              child: Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
