import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/restaurant_model.dart';
import 'auth_preferences.dart';

class FavoriteService {
  static Future<String> _getUserKey() async {
    final username = await AuthPreferences.getUsername();
    return 'favorite_restaurants_$username';
  }

  static Future<void> addFavorite(Restaurant restaurant) async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _getUserKey();
    final List<String> favorites = prefs.getStringList(key) ?? [];

    if (!favorites.any((item) => json.decode(item)['id'] == restaurant.id)) {
      favorites.add(json.encode(restaurant.toJson()));
      await prefs.setStringList(key, favorites);
    }
  }

  static Future<void> removeFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _getUserKey();
    final List<String> favorites = prefs.getStringList(key) ?? [];

    favorites.removeWhere((item) => json.decode(item)['id'] == id);
    await prefs.setStringList(key, favorites);
  }

  static Future<List<Restaurant>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _getUserKey();
    final List<String> favorites = prefs.getStringList(key) ?? [];

    return favorites
        .map((item) => Restaurant.fromJson(json.decode(item)))
        .toList();
  }

  static Future<bool> isFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final key = await _getUserKey();
    final List<String> favorites = prefs.getStringList(key) ?? [];

    return favorites.any((item) => json.decode(item)['id'] == id);
  }
}
