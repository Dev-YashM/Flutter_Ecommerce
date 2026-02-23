import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistService {
  static const String wishlistKey = "wishlist_items";

  static Future<List<Map<String, dynamic>>> getWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(wishlistKey);

    if (data == null) return [];

    return List<Map<String, dynamic>>.from(jsonDecode(data));
  }

  static Future<void> addItem(Map<String, dynamic> item) async {
    final prefs = await SharedPreferences.getInstance();
    final wishlist = await getWishlist();

    // Prevent duplicate entries
    final alreadyExists =
    wishlist.any((element) => element["title"] == item["title"]);

    if (!alreadyExists) {
      wishlist.add(item);
      await prefs.setString(wishlistKey, jsonEncode(wishlist));
    }
  }

  static Future<void> removeItem(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final wishlist = await getWishlist();

    wishlist.removeAt(index);

    await prefs.setString(wishlistKey, jsonEncode(wishlist));
  }

  static Future<void> clearWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(wishlistKey);
  }
}