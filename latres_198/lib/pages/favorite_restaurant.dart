// pages/favorite_restaurant.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteRestaurantPage extends StatelessWidget {
  const FavoriteRestaurantPage({super.key});

  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('favorite_restaurants') ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Restoran Favorit")),
      body: FutureBuilder<List<String>>(
        future: getFavorites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          final data = snapshot.data!;
          if (data.isEmpty) return Center(child: Text("Belum ada favorit"));

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, i) => ListTile(
              leading: Icon(Icons.favorite, color: Colors.red),
              title: Text("ID Restoran: ${data[i]}"),
            ),
          );
        },
      ),
    );
  }
}
