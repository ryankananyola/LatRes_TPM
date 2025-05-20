import 'package:flutter/material.dart';
import '../config/database_helper.dart';
import '../model/model_user.dart';

class UserListPage extends StatelessWidget {
  final dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar User Terdaftar')),
      body: FutureBuilder<List<User>>(
        future: dbHelper.getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          if (!snapshot.hasData || snapshot.data!.isEmpty)
            return Center(child: Text('Belum ada user terdaftar.'));

          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(child: Text(user.username[0].toUpperCase())),
                title: Text(user.username),
                subtitle: Text('Password: ${user.password}'),
              );
            },
          );
        },
      ),
    );
  }
}
