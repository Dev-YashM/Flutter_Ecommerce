import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class CoolerInfoSection extends StatelessWidget {
  final String title;
  final String rentAmount;
  final String model;
  final String type;
  final String fanSpeeds;
  final String waterTank;

  const CoolerInfoSection({
    super.key,
    required this.title,
    required this.rentAmount,
    required this.model,
    required this.type,
    required this.fanSpeeds,
    required this.waterTank,
  });

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _decoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            rentAmount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const Divider(height: 25),

          _infoRow("Model:", model),
          _infoRow("Type:", type),
          _infoRow("Fan Speeds:", fanSpeeds),
          _infoRow("Water Tank:", waterTank),
        ],
      ),
    );
  }

  BoxDecoration _decoration() => BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.circular(18),
    boxShadow: [
      BoxShadow(
        blurRadius: 10,
        color: Colors.black.withOpacity(0.05),
        offset: const Offset(0, 4),
      )
    ],
  );
}
