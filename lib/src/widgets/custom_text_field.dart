import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String? helperText;
  final int minLines;
  final int maxLines;
  final Widget? icon;
  final Widget? suffixIcon;
  final String? initialValue;
  final ValueChanged<String>? onValueChange;
  final String? errorText;
  final TextInputType? textInputType;
  final BoxConstraints? prefixIconConstraint;
  final TextEditingController? controller;
  final bool obscureText;
  final FocusNode? focusNode;
  final FormFieldValidator<String>? validator;
  final TextStyle style;
  final TextAlign textAlign;
  final TextCapitalization textCapitalization;
  final GestureTapCallback? onTap;
  final bool? enabled;
  final CrossAxisAlignment crossAxisAlignment;
  final ValueChanged<String>? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    Key? key,
    this.icon,
    this.suffixIcon,
    this.helperText,
    required this.label,
    this.maxLines = 1,
    this.minLines = 1,
    this.initialValue,
    this.onValueChange,
    this.textInputType,
    this.errorText,
    this.inputFormatters,
    this.controller,
    this.focusNode,
    this.onTap,
    this.validator,
    this.enabled,
    this.onFieldSubmitted,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.style = const TextStyle(fontWeight: FontWeight.w600),
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.textAlign = TextAlign.start,
    this.prefixIconConstraint = const BoxConstraints(minWidth: 40, minHeight: 40),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14, // Reduced font size for smaller screens
            color: Color(0xFF6B7281),
          ),
        ),
        if (helperText != null && helperText!.isNotEmpty)
          Text(
            helperText!,
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.black38,
              fontSize: 10, // Reduced font size for helper text
            ),
          ),
        const SizedBox(
          height: 1,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextFormField(
            autovalidateMode: AutovalidateMode.always,
            validator: validator,
            focusNode: focusNode,
            controller: controller,
            keyboardType: textInputType,
            initialValue: initialValue,
            minLines: minLines,
            maxLines: maxLines,
            onChanged: onValueChange,
            obscureText: obscureText,
            cursorColor: const Color(0xFF008080),
            textAlign: textAlign,
            inputFormatters: inputFormatters,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16, // Reduced font size for text input
            ),
            onTap: onTap,
            onFieldSubmitted: onFieldSubmitted,
            enabled: enabled,
            textCapitalization: textCapitalization,
            decoration: InputDecoration(
              errorStyle: TextStyle(height: 1, overflow: TextOverflow.fade),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFB1B4E6), width: 2.0),
              ),
              prefixIconConstraints: prefixIconConstraint,
              prefixIcon: icon,
              suffixIcon: suffixIcon,
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 8), // Reduced padding
              border: OutlineInputBorder(),
              isDense: true,
              errorText: errorText,
            ),
          ),
        ),
        const SizedBox(
          height: 8, // Reduced vertical spacing
        ),
      ],
    );
  }
}
