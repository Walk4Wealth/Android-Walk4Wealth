import 'package:flutter/material.dart';

class WTextField extends StatelessWidget {
  const WTextField({
    super.key,
    this.hint,
    this.label,
    this.suffix,
    this.isDense,
    this.enabled,
    this.onChanged,
    this.validator,
    this.focusNode,
    this.controller,
    this.initialValue,
    this.keyboardType,
    this.contentPadding,
    this.textInputAction,
    this.onFieldSubmitted,
    this.isError = false,
    this.readOnly = false,
    this.obscureText = false,
    this.floatingLabelBehavior = FloatingLabelBehavior.always,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final String? hint;
  final String? label;
  final Widget? suffix;
  final bool obscureText;
  final bool isError;
  final bool? isDense;
  final bool readOnly;
  final bool? enabled;
  final String? initialValue;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final EdgeInsetsGeometry? contentPadding;
  final AutovalidateMode? autovalidateMode;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;
  final FloatingLabelBehavior? floatingLabelBehavior;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      readOnly: readOnly,
      autocorrect: false,
      focusNode: focusNode,
      onChanged: onChanged,
      validator: validator,
      controller: controller,
      enableSuggestions: false,
      obscureText: obscureText,
      keyboardType: keyboardType,
      initialValue: initialValue,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      autovalidateMode: autovalidateMode,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        isDense: isDense,
        contentPadding: contentPadding,
        labelText: label,
        errorMaxLines: 2,
        suffixIcon: suffix,
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
            color: Colors.red,
          ),
        ),
        errorStyle: const TextStyle(
          fontSize: 11,
          color: Colors.red,
        ),
        error: isError ? const SizedBox.shrink() : null,
        border: const OutlineInputBorder(),
        floatingLabelBehavior: floatingLabelBehavior,
      ),
    );
  }
}
