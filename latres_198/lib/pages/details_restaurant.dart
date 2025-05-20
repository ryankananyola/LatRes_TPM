import 'package:flutter/material.dart';
import '../models/restaurant_detail_model.dart';
import '../services/restaurant_service.dart';
import '../services/favorite_service.dart';
import '../models/restaurant_model.dart'; 


class RestaurantDetailScreen extends StatefulWidget {
  final String restaurantId;

  const RestaurantDetailScreen({super.key, required this.restaurantId});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  late Future<RestaurantDetail> _detailFuture;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _detailFuture = RestaurantService.fetchRestaurantDetail(widget.restaurantId);
    _loadFavoriteStatus(widget.restaurantId);
  }

  void _loadFavoriteStatus(String id) async {
    final status = await FavoriteService.isFavorite(id);
    if (mounted) {
      setState(() {
        isFavorite = status;
      });
    }
  }

  void _toggleFavorite(RestaurantDetail restaurant) async {
    if (isFavorite) {
      await FavoriteService.removeFavorite(restaurant.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dihapus dari favorit'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      // Untuk addFavorite, kamu bisa pakai RestaurantDetail.toJson() jika ada,
      // atau convert ke Restaurant dulu, sesuaikan modelmu.
      await FavoriteService.addFavorite(
        // Asumsi kamu punya Restaurant dari RestaurantDetail,
        // buat objek Restaurant untuk disimpan di favorit:
        Restaurant(
          id: restaurant.id,
          name: restaurant.name,
          description: restaurant.description,
          pictureId: restaurant.pictureId,
          city: restaurant.city,
          rating: restaurant.rating,
        ),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ditambahkan ke favorit'),
          backgroundColor: Colors.green,
        ),
      );
    }
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Restaurants Detail')),
      body: FutureBuilder<RestaurantDetail>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final restaurant = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          restaurant.name,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                        ),
                        onPressed: () => _toggleFavorite(restaurant),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, size: 16),
                      const SizedBox(width: 4),
                      Text(restaurant.city),
                      const SizedBox(width: 12),
                      const Icon(Icons.star, size: 16),
                      const SizedBox(width: 4),
                      Text(restaurant.rating.toString()),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(restaurant.description),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}