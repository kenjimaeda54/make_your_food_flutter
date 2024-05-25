import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CommonTextField extends HookWidget {
  final bool? enabled;
  final void Function(String)? onChanged;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  const CommonTextField(
      {super.key,
      this.enabled,
      this.onChanged,
      this.focusNode,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      child: TextField(
        enabled: enabled,
        onChanged: onChanged,
        controller: controller,
        focusNode: focusNode,
        // textInputAction: TextInputAction.done, //quando desejo que seja done
        maxLines: null,
        cursorColor: Theme.of(context).colorScheme.primary,
        style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w400,
            fontSize: 17),
        decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            hintText: "Message",
            hintStyle: TextStyle(
                color: Theme.of(context).primaryColor.withOpacity(0.3),
                fontWeight: FontWeight.w300,
                fontSize: 17),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(40)),
            filled: true,
            fillColor: Theme.of(context).colorScheme.secondary),
      ),
    );
  }
}
