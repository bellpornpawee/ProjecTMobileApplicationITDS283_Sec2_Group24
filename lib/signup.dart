import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late Database _database;
  bool _isDatabaseReady = false;

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    String path = p.join(await getDatabasesPath(), 'user_db.db');
    _database = await openDatabase(path, version: 1);
    setState(() => _isDatabaseReady = true);
  }

  Future<void> _registerUser(String username, String password) async {
    if (!_isDatabaseReady) {
      print("Database is not ready.");
      return;
    }

    // ตรวจสอบว่ามีผู้ใช้นี้อยู่แล้วหรือยัง
    final existingUser = await _database.query(
      'users',
      where: 'username = ?',
      whereArgs: [username.trim()],
    );

    if (existingUser.isNotEmpty) {
      _showDialog('Error', 'Username already exists');
      return;
    }

    await _database.insert('users', {
      'username': username.trim(),
      'password': password.trim(),
    });

    _showDialog('Success', 'User registered successfully!');
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (title == 'Success') {
                Navigator.pop(context); // ย้อนกลับไปหน้า Login
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                _registerUser(
                  _usernameController.text,
                  _passwordController.text,
                );
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
