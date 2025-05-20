// pages/details_restaurant.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RestaurantDetailPage extends StatefulWidget {
  final String restaurantId;

  const RestaurantDetailPage({required this.restaurantId});

  @override
  _RestaurantDetailPageState createState() => _RestaurantDetailPageState();
}

class _RestaurantDetailPageState extends State<RestaurantDetailPage> {
  Map<String, dynamic>? detail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    final response = await http.get(
      Uri.parse("https://restaurant-api.dicoding.dev/detail/${widget.restaurantId}"),
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      setState(() {
        detail = result['restaurant'];
        isLoading = false;
      });
    } else {
      throw Exception("Gagal memuat detail restoran");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail Restoran")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      'https://restaurant-api.dicoding.dev/images/small/${detail!['pictureId']}',
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 10),
                    Text(detail!['name'], style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    Text("Kota: ${detail!['city']}"),
                    SizedBox(height: 10),
                    IconButton(
                    icon: Icon(Icons.favorite_border),
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        final list = prefs.getStringList('favorite_restaurants') ?? [];
                        if (!list.contains(widget.restaurantId)) {
                          list.add(widget.restaurantId);
                          await prefs.setStringList('favorite_restaurants', list);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ditambahkan ke favorit')));
                        }
                      },
                    ),
                    Text(detail!['description']),
                  ],
                ),
              ),
            ),
    );
  }
}
