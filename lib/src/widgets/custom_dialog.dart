
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomDialog extends StatelessWidget {
  final String message;
  final String lottieAssetPath;

  const CustomDialog({
    required this.message,
    required this.lottieAssetPath,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        height: 150,
        child: Column(
          children: [
            Lottie.asset(
              lottieAssetPath,
              width: 100,
              height: 100,
            ),
            Text(message),
          ],
        ),
      ),
    );
  }
}