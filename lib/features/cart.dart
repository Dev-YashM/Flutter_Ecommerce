import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mahalaxmi_coolers/services/cartService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  List<Map<String, dynamic>> cartItems = [];
  bool isPlacingOrder = false;

  final String bookingUrl =
      "http://10.18.46.128:8080/api/bookings/create";

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  Future<void> loadCart() async {
    final items = await CartService.getCart();
    setState(() {
      cartItems = items;
    });
  }

  double get total {
    double sum = 0;
    for (var item in cartItems) {
      sum += item["price"];
    }
    return sum;
  }

  /// 🔥 ORDER API CALL
  Future<void> placeOrder() async {
    if (cartItems.isEmpty) return;

    setState(() {
      isPlacingOrder = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? mobileNumber = prefs.getString("mobileNumber");

    try {
      for (var item in cartItems) {
        final response = await http.post(
          Uri.parse(bookingUrl),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "mobile": mobileNumber, // You can replace with logged user mobile
            "coolerTitle": item["title"],
            "rentalDuration": item["duration"],
            "price": item["price"],
          }),
        );

        if (response.statusCode != 200 &&
            response.statusCode != 201) {
          throw Exception("Order Failed");
        }
      }

      await CartService.clearCart();
      await loadCart();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Order placed successfully"),
          backgroundColor: Colors.green,
        ),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to place order"),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      isPlacingOrder = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.inversePrimary,
      appBar: AppBar(
        title: const Text("My Cart"),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: cartItems.isEmpty
          ? const Center(child: Text("Cart is empty"))
          : Column(
        children: [

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: item["image"] != ""
                        ? Image.network(
                      item["image"],
                      width: 60,
                      fit: BoxFit.cover,
                    )
                        : const Icon(Icons.image),

                    title: Text(item["title"]),

                    subtitle: Text(
                        "${item["duration"]} • ₹${item["price"]}"),

                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await CartService.removeItem(index);
                        loadCart();
                      },
                    ),
                  ),
                );
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            color: theme.colorScheme.surface,
            child: Column(
              children: [

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total:",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "₹${total.toStringAsFixed(0)}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isPlacingOrder
                        ? null
                        : placeOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      theme.colorScheme.primary,
                      padding:
                      const EdgeInsets.symmetric(
                          vertical: 14),
                    ),
                    child: isPlacingOrder
                        ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                        : const Text(
                      "Order Now",
                      style:
                      TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}