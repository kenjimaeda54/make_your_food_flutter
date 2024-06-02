import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:make_your_travel/utils/gradient_color.dart';

class CustomScaffold extends HookWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final bool? extendBodyBehindAppBar;
  final bool? resizeToAvoidBottomInset;
  const CustomScaffold(
      {super.key,
      required this.body,
      this.floatingActionButton,
      this.extendBodyBehindAppBar,
      this.resizeToAvoidBottomInset,
      this.appBar}); // and maybe other Scaffold properties

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBodyBehindAppBar: extendBodyBehindAppBar ?? false,
      body: Container(
          decoration: const BoxDecoration(gradient: gradientBackground),
          child: body),
    );
  }
}
