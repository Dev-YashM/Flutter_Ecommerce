import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/banner_slider.dart';
import '../widgets/category_section.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> coolers = [];
  bool isLoading = true;

  final String baseUrl = "http://10.18.46.128:8080/api";

  @override
  void initState() {
    super.initState();
    fetchCoolers();
  }

  Future<void> fetchCoolers() async {
    try {
      final response =
      await http.get(Uri.parse("$baseUrl/coolers"));

      if (response.statusCode == 200) {
        setState(() {
          coolers = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),

          const BannerSlider(
            images: [
              'assets/images/banner/banner1.png',
              'assets/images/banner/banner2.png',
              'assets/images/banner/banner3.png',
            ],
          ),

          const SizedBox(height: 20),

          const CategorySection(),

          const SizedBox(height: 25),

          /// 🔥 Dynamic Product List
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: coolers.map((item) {
                // Safely extract values
                final id = item["id"]?.toString() ?? "";
                final name = item["name"] ?? "No Name";

                // Take first image from images list
                String image = "";
                if (item["images"] != null &&
                    item["images"] is List &&
                    item["images"].isNotEmpty) {
                  image = item["images"][0];
                }

                final price =
                (item["dailyRent"] ?? 0).toDouble();

                return ProductCard(
                  id: id,
                  image: image,
                  name: name,
                  price: price,
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
