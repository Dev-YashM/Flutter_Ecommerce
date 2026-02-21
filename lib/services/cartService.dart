import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CartService {
  static const String cartKey = "cart_items";

  static Future<List<Map<String, dynamic>>> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(cartKey);

    if (data == null) return [];

    return List<Map<String, dynamic>>.from(jsonDecode(data));
  }

  static Future<void> addItem(Map<String, dynamic> item) async {
    final prefs = await SharedPreferences.getInstance();
    final cart = await getCart();

    cart.add(item);

    await prefs.setString(cartKey, jsonEncode(cart));
  }

  static Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(cartKey);
  }

  static Future<void> removeItem(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final cart = await getCart();

    cart.removeAt(index);

    await prefs.setString(cartKey, jsonEncode(cart));
  }
}