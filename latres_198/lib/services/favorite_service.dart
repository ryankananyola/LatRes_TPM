import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/restaurant_model.dart';

class FavoriteService {
  static const _key = 'favorite_restaurants';

  static Future<void> addFavorite(Restaurant restaurant) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favorites = prefs.getStringList(_key) ?? [];

    // Hindari duplikat
    if (!favorites.any((item) => json.decode(item)['id'] == restaurant.id)) {
      favorites.add(json.encode(restaurant.toJson()));
      await prefs.setStringList(_key, favorites);
    }
  }

  static Future<void> removeFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favorites = prefs.getStringList(_key) ?? [];

    favorites.removeWhere((item) => json.decode(item)['id'] == id);
    await prefs.setStringList(_key, favorites);
  }

  static Future<List<Restaurant>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favorites = prefs.getStringList(_key) ?? [];

    return favorites
        .map((item) => Restaurant.fromJson(json.decode(item)))
        .toList();
  }

  static Future<bool> isFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favorites = prefs.getStringList(_key) ?? [];

    return favorites.any((item) => json.decode(item)['id'] == id);
  }
}