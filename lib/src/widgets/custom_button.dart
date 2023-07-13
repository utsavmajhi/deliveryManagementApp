import 'package:flutter/material.dart';

import '../config/theme_settings.dart';


class RejectButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  const RejectButton({Key? key, required this.label, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 20),
        primary: AppColor.buttonColorSecondary,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
      child: Text(
        label,
        style: const TextStyle(color: AppColor.primary),
      ),
    );
  }
}
