import 'package:flutter/material.dart';
import 'package:mahalaxmi_coolers/core/theme/app_colors.dart';

class ConditionSection extends StatelessWidget {
  const ConditionSection({super.key});

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18,0,18,18),
      decoration: _decoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 30,
            width: 120,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10)
            ),
            child: const Text(
              "Condition",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.surface),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            height: 100,
            width: 350,
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: [
                _chip("Refurbished / Used"),
                _chip("Fully Functional"),
                _chip("Tested OK"),
              ],
            ),
          )
        ],
      ),
    );
  }

  BoxDecoration _decoration() => BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(0),
    boxShadow: [
      BoxShadow(
        blurRadius: 10,
        color: Colors.black.withOpacity(0.05),
        offset: const Offset(0, 4),
      )
    ],
  );
}

