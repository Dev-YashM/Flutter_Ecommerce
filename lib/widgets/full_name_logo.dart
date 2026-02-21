import 'package:flutter/material.dart';

class FullNameLogoWidget extends StatelessWidget {
  const FullNameLogoWidget ({super.key});

  @override
  Widget build(BuildContext context) {
    return Hero(tag: 'heroWidget', child: Image.asset('assets/images/fullNameLogo.png'));
  }
}
