import 'package:flutter/material.dart';
import 'package:mahalaxmi_coolers/services/wishlistService.dart';

import 'coolerDetail.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {

  List<Map<String, dynamic>> wishlist = [];

  @override
  void initState() {
    super.initState();
    loadWishlist();
  }

  Future<void> loadWishlist() async {
    final items = await WishlistService.getWishlist();
    setState(() {
      wishlist = items;
    });
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.inversePrimary,
      appBar: AppBar(
        title: const Text("My Wishlist"),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: wishlist.isEmpty
          ? const Center(
        child: Text(
          "No Items in Wishlist",
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: wishlist.length,
        itemBuilder: (context, index) {

          final item = wishlist[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CoolerDetailsScreen(
                      coolerId: item["coolerId"],
                    ),
                  ),
                );
              },
              child: ListTile(
                leading: Image.network(
                  item["image"],
                  width: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(item["title"]),
                subtitle: Text("₹${item["price"]}"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await WishlistService.removeItem(index);
                    await loadWishlist();
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}