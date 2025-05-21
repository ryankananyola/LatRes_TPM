import 'package:flutter/material.dart';
import '../services/restaurant_service.dart';
import '../models/restaurant_model.dart';
import '../widgets/restaurant_card.dart';
import '../services/auth_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Restaurant>> _restaurantFuture;
  String? _loggedInUsername;

  @override
  void initState() {
    super.initState();
    _restaurantFuture = RestaurantService.fetchRestaurants();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final username = await AuthPreferences.getUsername();
    setState(() {
      _loggedInUsername = username;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, 
        title: Text(
          _loggedInUsername != null
              ? 'Hai, $_loggedInUsername'
              : 'Daftar Restoran',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'Logout',
          onPressed: () async {
            await AuthPreferences.logout();
            if (!mounted) return;
            Navigator.pushReplacementNamed(context, '/login'); 
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: 'Lihat Favorit',
            onPressed: () {
              Navigator.pushNamed(context, '/favorites');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Restaurant>>(
        future: _restaurantFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data restoran.'));
          }

          final restaurants = snapshot.data!;
          return ListView.builder(
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              return RestaurantCard(restaurant: restaurants[index]);
            },
          );
        },
      ),
    );
  }
}
