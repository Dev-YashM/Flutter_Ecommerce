import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mahalaxmi_coolers/core/theme/app_colors.dart';
import 'package:mahalaxmi_coolers/features/widgetTree.dart';
import 'package:mahalaxmi_coolers/widgets/full_name_logo.dart';

class RegisterScreen extends StatefulWidget {
  final String mobileNumber;

  const RegisterScreen({super.key, required this.mobileNumber});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final pinController= TextEditingController();
  final plotController = TextEditingController();
  final laneController = TextEditingController();
  final pinCodeController = TextEditingController();

  String selectedCity = "Yavatmal";
  String selectedState = "Maharashtra";

  final String baseUrl = "http://10.141.126.128:8080";

  bool isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
    pinController.dispose();
    plotController.dispose();
    laneController.dispose();
    pinCodeController.dispose();
    super.dispose();
  }

  Future<void> submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/api/auth/complete-profile/${widget.mobileNumber}"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": usernameController.text.trim(),
          "pin": pinController.text.trim(),
          "plotNo": plotController.text.trim(),
          "laneArea": laneController.text.trim(),
          "city": selectedCity,
          "state": selectedState,
          "pinCode": pinCodeController.text.trim(),
        }),
      );

      setState(() => isLoading = false);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String mobileNumber = data["mobileNumber"];

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile Completed Successfully")),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => WidgetTree(
              title: "Mahalaxmi Coolers",
              mobileNumber: mobileNumber,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: ${response.body}")));
      }
    } catch (e) {
      setState(() => isLoading = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Something went wrong")));
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Complete Profile",
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                const Text(
                  "Let’s get you started",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 6),

                const Text(
                  "Fill in your details to complete registration",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),

                const SizedBox(height: 30),

                Center(
                    child: FullNameLogoWidget()
                ),

                const SizedBox(height: 40),

                TextFormField(
                  initialValue: widget.mobileNumber,
                  readOnly: true,
                  decoration: _inputDecoration("Mobile Number"),
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: usernameController,
                  decoration: _inputDecoration("Username"),
                  validator: (value) => value == null || value.isEmpty
                      ? "Username is required"
                      : null,
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: pinController,
                  decoration: _inputDecoration("Pin"),
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: plotController,
                  decoration: _inputDecoration("Plot No"),
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: laneController,
                  decoration: _inputDecoration("Lane / Area"),
                ),

                const SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  initialValue: selectedCity,
                  decoration: _inputDecoration("City"),
                  items: const [
                    DropdownMenuItem(
                      value: "Yavatmal",
                      child: Text("Yavatmal"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => selectedCity = value!);
                  },
                ),

                const SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  initialValue: selectedState,
                  decoration: _inputDecoration("State"),
                  items: const [
                    DropdownMenuItem(
                      value: "Maharashtra",
                      child: Text("Maharashtra"),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() => selectedState = value!);
                  },
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: pinCodeController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration("PIN Code"),
                  validator: (value) => value == null || value.length != 6
                      ? "Enter valid 6-digit PIN"
                      : null,
                ),

                const SizedBox(height: 30),

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
                    onPressed: isLoading ? null : submitForm,
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Complete Registration",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
