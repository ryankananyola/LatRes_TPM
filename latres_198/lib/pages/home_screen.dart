import 'package:flutter/material.dart';
import '../services/restaurant_service.dart';
import '../models/restaurant_model.dart';
import '../widgets/restaurant_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Restaurant>> _restaurantFuture;

  @override
  void initState() {
    super.initState();
    _restaurantFuture = RestaurantService.fetchRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, 
        title: const Text(
          'Daftar Restoran',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true, 
        leading: IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'Logout',
          onPressed: () {
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