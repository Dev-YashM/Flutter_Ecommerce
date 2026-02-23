import 'package:flutter/material.dart';
import 'package:mahalaxmi_coolers/core/theme/app_colors.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: AppColors.accent.withOpacity(0.50),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text(
                "RENTAL COOLERS",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          )
        ]
      ),
    );
  }
}
