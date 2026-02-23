import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/theme/app_colors.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  final String phone = "+91 9657678961";
  final String email = "mahalaxmi_electricals@gmail.com";
  final String address =
      "Mahalaxmi Electricals, \nDeep Nagar, Wadgaon Road, Yavatmal - 445001";
  final String whatsappNumber = "919657678961";

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,

      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: const Text(
          "Contact Us",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔵 Business Name
            Text(
              "Mahalaxmi Electricals",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "Premium Coolers for Rent & Sale",
              style: TextStyle(color: AppColors.primary.withOpacity(0.8), fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 30),

            /// 📍 Address
            _buildInfoCard(
              icon: Icons.location_on,
              title: "Our Address",
              content: address,
              onTap: () {
                _launchURL(
                    "https://maps.app.goo.gl/uUqoCn2spVvJouhj7");
              },
            ),

            /// 📞 Phone
            _buildInfoCard(
              icon: Icons.phone,
              title: "Call Us",
              content: phone,
              onTap: () {
                _launchURL("tel:$phone");
              },
            ),

            /// 📧 Email
            _buildInfoCard(
              icon: Icons.email,
              title: "Email Us",
              content: email,
              onTap: () {
                _launchURL("mailto:$email");
              },
            ),

            const SizedBox(height: 25),

            /// 🕒 Business Hours
            Text(
              "Business Hours",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 10),

            _buildTimingRow("Monday - Saturday", "9:00 AM - 8:00 PM"),
            _buildTimingRow("Sunday", "10:00 AM - 5:00 PM"),

            const SizedBox(height: 30),

            /// 🟢 WhatsApp Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  _launchURL("https://wa.me/$whatsappNumber");
                },
                icon: const Icon(Icons.chat, color: Colors.white),
                label: const Text(
                  "Chat on WhatsApp",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 35),

          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
    required VoidCallback onTap,
  }) {
    return Card(
      color: AppColors.surface,
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.secondary),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        subtitle: Text(content),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.accent,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildTimingRow(String day, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(day, style: TextStyle(color: AppColors.secondary)),
          Text(
            time,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return CircleAvatar(
      radius: 24,
      backgroundColor: AppColors.accent.withOpacity(0.2),
      child: Icon(icon, color: AppColors.primary),
    );
  }
}