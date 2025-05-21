import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/restaurant_model.dart';
import '../models/restaurant_detail_model.dart';

class RestaurantService {
  static const String baseUrl = 'https://restaurant-api.dicoding.dev';

  static Future<List<Restaurant>> fetchRestaurants() async {
    final response = await http.get(Uri.parse('$baseUrl/list'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final restaurantList = RestaurantList.fromJson(data);
      return restaurantList.restaurants;
    } else {
      throw Exception('Gagal memuat data restoran');
    }
  }

  static Future<RestaurantDetail> fetchRestaurantDetail(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/detail/$id'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final detail = RestaurantDetailResponse.fromJson(data);
      return detail.restaurant;
    } else {
      throw Exception('Gagal memuat detail restoran');
    }
  }
}