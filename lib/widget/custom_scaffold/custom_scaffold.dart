import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CustomScaffold extends HookWidget {
  final Widget body;
  final LinearGradient gradient;
  const CustomScaffold(
      {super.key,
      required this.body,
      required this.gradient}); // and maybe other Scaffold properties

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          Container(decoration: BoxDecoration(gradient: gradient), child: body),
    );
  }
}
