import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class NoteSection extends StatelessWidget {
  const NoteSection({super.key});

  Widget _note(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 18),
          const SizedBox(width: 6),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
      decoration: _decoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 30,
            width: 130,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10)
            ),
            child: const Text(
              "Please Note",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.surface),
            ),
          ),
          const SizedBox(height: 12),

          _note("Deposit/Security: Not Applicable. Entire rent to be paid beforehand"),
          _note("Delivery & Pickup Charges: If Applicable"),
          _note("Damage Policy: If Fan Motor burns due to water leakage charges applicable"),
          _note("Rental Duration & Extension: Depends at time of extension"),
          _note("Cancellation & Refund: Non Refundable"),
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
