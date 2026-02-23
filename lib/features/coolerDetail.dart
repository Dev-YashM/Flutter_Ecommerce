import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mahalaxmi_coolers/features/cart.dart';
import '../../widgets/cooler_image_slider.dart';
import '../../widgets/cooler_info_section.dart';
import '../../widgets/condition_section.dart';
import '../../widgets/rental_options_section.dart';
import '../../widgets/safety_section.dart';
import '../../widgets/note_section.dart';
import '../core/theme/app_colors.dart';
import '../services/cartService.dart';

class CoolerDetailsScreen extends StatefulWidget {
  final String coolerId;

  const CoolerDetailsScreen({
    super.key,
    required this.coolerId,
  });

  @override
  State<CoolerDetailsScreen> createState() =>
      _CoolerDetailsScreenState();
}

class _CoolerDetailsScreenState
    extends State<CoolerDetailsScreen> {

  bool isLoading = true;
  Map<String, dynamic>? coolerData;

  final String baseUrl =
      "http://10.141.126.128:8080/api";

  @override
  void initState() {
    super.initState();
    fetchCoolerDetails();
  }

  Future<void> fetchCoolerDetails() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/coolers/${widget.coolerId}"),
      );

      if (response.statusCode == 200) {
        setState(() {
          coolerData = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void showRentalSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Text(
                "Select Rental Duration",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              rentalOptionTile(
                label: "Daily",
                price: coolerData?["dailyRent"] ?? 0,
              ),

              rentalOptionTile(
                label: "Monthly",
                price: coolerData?["monthlyRent"] ?? 0,
              ),

              rentalOptionTile(
                label: "Seasonal",
                price: coolerData?["seasonalRent"] ?? 0,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget rentalOptionTile({
    required String label,
    required dynamic price,
  }) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      tileColor: Theme.of(context).colorScheme.surface,
      title: Text(label),
      trailing: Text(
        "₹$price",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      onTap: () async {
        Navigator.pop(context);

        final cartItem = {
          "title": coolerData?["name"] ?? "",
          "duration": label,
          "price": double.tryParse(price.toString()) ?? 0,
          "image": coolerData?["images"] != null &&
              coolerData!["images"].isNotEmpty
              ? coolerData!["images"][0]
              : "",
        };

        await CartService.addItem(cartItem);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const CartScreen(),
          ),
        );
      },
    );
  }


  Future<void> addToCart({
    required String duration,
    required double selectedPrice,
  }) async {

    final cartItem = {
      "coolerId": widget.coolerId,
      "title": coolerData?["name"] ?? "",
      "duration": duration,
      "price": selectedPrice,
      "quantity": 1,
      "type": coolerData?["type"] ?? "",
      "image": coolerData?["images"] != null &&
          coolerData!["images"].isNotEmpty
          ? coolerData!["images"][0]
          : "",
    };

    await CartService.addItem(cartItem);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CartScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.surface,

      appBar: AppBar(
        centerTitle: true,
        backgroundColor:
        Theme.of(context).colorScheme.primary,
        title: Text(
          'Cooler Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context)
                .colorScheme
                .surface,
          ),
        ),
        leading: BackButton(
          color: Theme.of(context)
              .colorScheme
              .surface,
        ),
      ),

      body: isLoading
          ? const Center(
        child:
        CircularProgressIndicator(),
      )
          : coolerData == null
          ? const Center(
        child:
        Text("Failed to load data"),
      )
          : SingleChildScrollView(
        padding:
        const EdgeInsets.all(16),
        child: Column(
          children: [

            CoolerImageSlider(
              images:
              coolerData!["images"] !=
                  null
                  ? List<String>.from(
                  coolerData![
                  "images"])
                  : [],
            ),

            const SizedBox(height: 18),

            CoolerInfoSection(
              title:
              coolerData!["name"] ?? "",
              rentAmount:
              coolerData![
              "priceTag"] ??
                  "",
              model:
              coolerData![
              "model"] ??
                  "",
              type:
              coolerData![
              "type"] ??
                  "",
              fanSpeeds:
              coolerData![
              "fanSpeeds"] ??
                  "",
              waterTank:
              coolerData![
              "waterTank"] ??
                  "",
            ),

            const SizedBox(height: 16),

            const ConditionSection(),

            const SizedBox(height: 16),

            RentalOptionsSection(
              daily:
              "₹${coolerData!["dailyRent"] ?? 0}/D",
              monthly:
              "₹${coolerData!["monthlyRent"] ?? 0}/M",
              seasonal:
              "₹${coolerData!["seasonalRent"] ?? 0}/S",
            ),

            const SizedBox(height: 16),

            const SafetySection(),

            const SizedBox(height: 16),

            const NoteSection(),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [

                FilledButton(
                  onPressed:
                  showRentalSelector,
                  child: const Text(
                      'Add To Cart'),
                ),

                const SizedBox(
                    width: 15),

                FilledButton(
                  onPressed:
                  showRentalSelector,
                  child:
                  const Text('Order Now'),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}