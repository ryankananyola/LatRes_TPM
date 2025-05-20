// pages/restaurant_list.dart
import 'package:flutter/material.dart';
import 'package:latres_198/model/model_restaurant.dart';
import 'package:latres_198/services/base_network.dart';
import 'package:latres_198/pages/details_restaurant.dart';
import 'package:latres_198/pages/favorite_restaurant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantListPage extends StatefulWidget {
  const RestaurantListPage({super.key});

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  List<Restaurant> restaurantList = [];
  String username = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUsername();
    loadRestaurants();
  }

  Future<void> loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
    });
  }

  Future<void> loadRestaurants() async {
    try {
      final rawData = await BaseNetwork.getAll("list");
      final dataList = rawData['restaurants'] as List;
      setState(() {
        restaurantList = dataList.map((e) => Restaurant.fromJson(e)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hai, $username"),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => FavoriteRestaurantPage()),
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: restaurantList.length,
              itemBuilder: (context, index) {
                final resto = restaurantList[index];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RestaurantDetailPage(restaurantId: resto.id),
                    ),
                  ),
                  child: Card(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Image.network(
                          'https://restaurant-api.dicoding.dev/images/small/${resto.pictureId}',
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(resto.name, style: TextStyle(fontWeight: FontWeight.bold)),
                              Text(resto.city),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
