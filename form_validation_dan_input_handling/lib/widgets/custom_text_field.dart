import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final TextInputType keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final Function(String)? onFieldSubmitted;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.hint,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.validator,
    this.suffixIcon,
    this.onTap,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      enabled: enabled,
      readOnly: readOnly,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      onTap: onTap,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: suffixIcon,
        enabled: enabled,
      ),
    );
  }
}
