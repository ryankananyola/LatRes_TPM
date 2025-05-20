// pages/register_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatelessWidget {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _register(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('username', _usernameController.text);
  await prefs.setString('password', _passwordController.text);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Registrasi Berhasil'),
      content: Text('Silakan login dengan akun yang telah dibuat.'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); 
            Navigator.pop(context);
          },
          child: Text('OK'),
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar Akun')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _nameController, decoration: InputDecoration(labelText: 'Nama')),
            TextField(controller: _usernameController, decoration: InputDecoration(labelText: 'Username')),
            TextField(controller: _passwordController, obscureText: true, decoration: InputDecoration(labelText: 'Password')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () => _register(context), child: Text('Daftar')),
          ],
        ),
      ),
    );
  }
}
