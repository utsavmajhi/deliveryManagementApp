import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.orange,
              width: 4.0,
            ),
          ),
          child: const CircleAvatar(
            backgroundColor: Colors.white,
            radius: 100,
            backgroundImage: AssetImage(
              'assets/images/inspection.png',
            ),
          ),
        ),
      ),
    );
  }
}
