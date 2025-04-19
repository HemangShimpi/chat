import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  DateTime? selectedDOB;

  @override
  void initState() {
    super.initState();
    _loadDOB();
  }

  Future<void> _loadDOB() async {
    try {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      final data = doc.data() as Map<String, dynamic>;
      if (data['dob'] != null) {
        setState(() {
          selectedDOB = DateTime.parse(data['dob']);
        });
      }
    } catch (e) {
      print('Error loading DOB: $e');
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDOB ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime(now.year, now.month, now.day),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.white),
            ),
            dialogTheme: DialogThemeData(backgroundColor: Color(0xFF1E293B)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDOB = picked;
      });

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update(
        {'dob': DateFormat('yyyy-MM-dd').format(picked)},
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('DOB updated!')));
    }
  }

  void _showChangeEmailDialog() {
    final TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Color(0xFF1E293B),
            title: Text("Change Email", style: TextStyle(color: Colors.white)),
            content: TextField(
              controller: emailController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "New Email",
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Color(0xFF334155),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel", style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await user.updateEmail(emailController.text.trim());
                    Navigator.pop(context);
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Email updated!")));
                  } catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Error: $e")));
                  }
                },
                child: Text("Update"),
              ),
            ],
          ),
    );
  }

  void _showChangePasswordDialog() {
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            backgroundColor: Color(0xFF1E293B),
            title: Text(
              "Change Password",
              style: TextStyle(color: Colors.white),
            ),
            content: TextField(
              controller: passwordController,
              obscureText: true,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "New Password",
                labelStyle: TextStyle(color: Colors.white),
                fillColor: Color(0xFF334155),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Cancel", style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await user.updatePassword(passwordController.text.trim());
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Password updated!")),
                    );
                  } catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text("Error: $e")));
                  }
                },
                child: Text("Update"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dobText =
        selectedDOB != null
            ? DateFormat('MMMM dd, yyyy').format(selectedDOB!)
            : 'Not Set';

    return Scaffold(
      backgroundColor: Color(0xFF0F172A),
      appBar: AppBar(
        title: Text("Settings", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF1E293B),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(
              "Change Login Email",
              style: TextStyle(color: Colors.white),
            ),
            trailing: Icon(Icons.email, color: Colors.white),
            onTap: _showChangeEmailDialog,
          ),
          ListTile(
            title: Text(
              "Change Password",
              style: TextStyle(color: Colors.white),
            ),
            trailing: Icon(Icons.lock, color: Colors.white),
            onTap: _showChangePasswordDialog,
          ),
          Divider(color: Colors.white24),
          ListTile(
            title: Text("Change DOB", style: TextStyle(color: Colors.white)),
            subtitle: Text(dobText, style: TextStyle(color: Colors.white70)),
            trailing: Icon(Icons.cake, color: Colors.white),
            onTap: _pickDate,
          ),
          Divider(color: Colors.white24),
          ListTile(
            title: Text("Log Out", style: TextStyle(color: Colors.white)),
            trailing: Icon(Icons.logout, color: Colors.white),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
