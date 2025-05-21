import 'package:flutter/material.dart';
import '../models/restaurant_model.dart';
import '../services/favorite_service.dart';
import '../widgets/favoriteRestaurant_card.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> with RouteAware {
  late Future<List<Restaurant>> _favorites;

  @override
  void initState() {
    super.initState();
    _favorites = FavoriteService.getFavorites();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _favorites = FavoriteService.getFavorites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Restoran Favorit')),
      body: FutureBuilder<List<Restaurant>>(
        future: _favorites,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada restoran favorit.'));
          }

          final restaurants = snapshot.data!;
          return ListView.builder(
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              return FavoriteRestaurantCard(
                restaurant: restaurants[index],
              );
            },
          );

        },
      ),
    );
  }
}