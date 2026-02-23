import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:mahalaxmi_coolers/services/cartService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  List<Map<String, dynamic>> cartItems = [];
  late Razorpay _razorpay;

  final String baseUrl = "http://10.141.126.128:8080/api";

  String mobileNumber = "";
  String currentBookingId = "";

  @override
  void initState() {
    super.initState();
    loadCart();
    loadMobileNumber();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> loadMobileNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      mobileNumber = prefs.getString("mobileNumber") ?? "";
    });
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

  Future<String?> createBooking(Map<String, dynamic> item) async {

    final response = await http.post(
      Uri.parse("$baseUrl/bookings/create"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "mobile": mobileNumber,
        "coolerTitle": item["title"],
        "rentalDuration": item["duration"],
        "price": item["price"],
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data["id"];
    }

    return null;
  }

  Future<Map<String, dynamic>?> createRazorpayOrder(String bookingId) async {
    final response = await http.post(
      Uri.parse("$baseUrl/payment/create-order/$bookingId"),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    }

    return null;
  }

  void openRazorpay(String razorpayOrderId, int price) {
    var options = {
      'key': 'rzp_test_SJC89k7q16xRy1',
      'amount': price * 100,
      'order_id': razorpayOrderId,
      'name': 'Mahalaxmi Rentals',
      'prefill': {
        'contact': mobileNumber,
      }
    };

    _razorpay.open(options);
  }

  Future<void> verifyPayment(
      String bookingId,
      String paymentId,
      String signature) async {

    final response = await http.post(
      Uri.parse(
          "$baseUrl/payment/verify/$bookingId?paymentId=$paymentId&signature=$signature"),
    );

    final data = jsonDecode(response.body);

    if (data["paymentStatus"] == "SUCCESS") {
      await CartService.clearCart();
      await loadCart();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Payment Successful 🎉"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Payment Verification Failed"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    if (currentBookingId.isEmpty) return;

    verifyPayment(
      currentBookingId,
      response.paymentId ?? "",
      response.signature ?? "",
    );
  }

  void handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Payment Failed ❌"),
        backgroundColor: Colors.red,
      ),
    );
  }

  void handleExternalWallet(ExternalWalletResponse response) {}

  Future<void> startPaymentFlow() async {

    if (cartItems.isEmpty || mobileNumber.isEmpty) {
      return;
    }

    final item = cartItems.first;

    final bookingId = await createBooking(item);

    if (bookingId == null) {
      print("Booking creation failed");
      return;
    }

    currentBookingId = bookingId;

    final razorpayData = await createRazorpayOrder(bookingId);

    if (razorpayData == null) {
      print("Razorpay order failed");
      return;
    }

    openRazorpay(
      razorpayData["razorpayOrderId"],
      razorpayData["price"],
    );
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
                    title: Text(item["title"]),
                    subtitle: Text("${item["duration"]} • ₹${item["price"]}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirm = await showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Remove Item"),
                            content: const Text("Are you sure you want to remove this item?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text("Remove"),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await CartService.removeItem(index);
                          await loadCart();
                        }
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
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "₹${total.toStringAsFixed(0)}",
                      style: TextStyle(
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
                    onPressed: startPaymentFlow,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      theme.colorScheme.primary,
                      padding:
                      const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "Pay Now",
                      style: TextStyle(color: Colors.white),
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