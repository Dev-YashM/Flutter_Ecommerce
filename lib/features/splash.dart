import 'package:flutter/material.dart';
import 'package:mahalaxmi_coolers/features/login.dart';
import 'package:mahalaxmi_coolers/features/verify.dart';

import '../widgets/hero.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigationToHome();
  }

  void _navigationToHome() {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginMobileScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginMobileScreen(),));
      },
      child: Scaffold(
        body: Container(
          color: Theme.of(context).colorScheme.inversePrimary,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HeroWidget(),
              Text(
                'MAHALAXMI ELECTRICALS',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 28,
                ),
              ),
              Text(
                'Cooling Comfort. Made Affordable.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}