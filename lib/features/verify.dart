import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mahalaxmi_coolers/core/theme/app_colors.dart';
import 'package:mahalaxmi_coolers/features/register.dart';
import 'package:mahalaxmi_coolers/features/widgetTree.dart';
import 'package:mahalaxmi_coolers/widgets/hero.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyMobileScreen extends StatefulWidget {
  const VerifyMobileScreen({super.key});

  @override
  State<VerifyMobileScreen> createState() => _VerifyMobileScreenState();
}

class _VerifyMobileScreenState extends State<VerifyMobileScreen> {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  bool showOtpField = false;
  bool isLoading = false;

  final String baseUrl = "http://10.18.46.128:8080";

  @override
  void dispose() {
    mobileController.dispose();
    otpController.dispose();
    super.dispose();
  }

  // SEND OTP (CALL BACKEND)
  Future<void> submitMobile() async {
    if (mobileController.text.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid 10-digit mobile number")),
      );
      return;
    }

    setState(() => isLoading = true);

    final response = await http.post(
      Uri.parse("$baseUrl/api/auth/send-otp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "mobileNumber": mobileController.text.trim(),
      }),
    );

    setState(() => isLoading = false);

    if (response.statusCode == 200) {
      setState(() {
        showOtpField = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP Sent Successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${response.body}")),
      );
    }
  }

  // VERIFY OTP (CALL BACKEND)
  Future<void> verifyOtp() async {
    setState(() => isLoading = true);

    final response = await http.post(
      Uri.parse("$baseUrl/api/auth/verify-otp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "mobileNumber": mobileController.text.trim(),
        "otp": otpController.text.trim(),
      }),
    );

    setState(() => isLoading = false);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      bool profileComplete = data["profileComplete"];
      String mobileNumber = data["mobileNumber"];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("mobileNumber", mobileNumber);

      if (profileComplete == true) {
        // ✅ User already registered → Go to App
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
            WidgetTree(title: "Mahalaxmi Coolers", mobileNumber: mobileNumber,),
          ),
        );
      } else {
        // ✅ New user → Go to Register Screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                RegisterScreen(mobileNumber: mobileNumber),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid OTP")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface, // Pure white
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Login",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.primary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 10),

              const Text(
                "Welcome back",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                "Enter your mobile number to continue",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 40),

              Center(child: SizedBox(height: 300,child: HeroWidget())),

              const SizedBox(height: 40),

              // Mobile Field
              TextField(
                controller: mobileController,
                keyboardType: TextInputType.number,
                maxLength: 10,
                decoration: InputDecoration(
                  labelText: "Mobile Number",
                  filled: true,
                  fillColor: AppColors.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              if (!showOtpField)
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: isLoading ? null : submitMobile,
                    child: const Text(
                      "Send OTP",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

              if (showOtpField) ...[

                const SizedBox(height: 10),

                TextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: InputDecoration(
                    labelText: "Enter OTP",
                    filled: true,
                    fillColor: AppColors.surface,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: isLoading ? null : verifyOtp,
                    child: const Text(
                      "Verify & Login",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],

              if (isLoading) ...[
                const SizedBox(height: 20),
                const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}