import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TextFieldCommon extends HookWidget {
  final String hintText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool? enabled;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  const TextFieldCommon(
      {super.key,
      required this.hintText,
      this.keyboardType,
      this.inputFormatters,
      this.focusNode,
      this.enabled,
      this.textInputAction,
      this.onSubmitted,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        focusNode: focusNode,
        inputFormatters: inputFormatters,
        enabled: enabled,
        textInputAction: textInputAction,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        cursorColor: Theme.of(context).colorScheme.primary,
        cursorHeight: 15,
        maxLength: 27,
        keyboardType: keyboardType,
        style: TextStyle(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
            fontSize: 16,
            fontWeight: FontWeight.w300),
        decoration: InputDecoration(
            counterText: "",
            hintText: hintText,
            hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                fontSize: 16,
                fontWeight: FontWeight.w300),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 5, horizontal: 13),
            border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).primaryColor.withOpacity(0.8))),
            disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).primaryColor.withOpacity(0.5)))),
      ),
    );
  }
}
