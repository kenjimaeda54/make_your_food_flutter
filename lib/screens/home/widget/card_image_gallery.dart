import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CardImageGallery extends HookWidget {
  final File file;
  final Function() actionTapCard;
  const CardImageGallery(
      {super.key, required this.file, required this.actionTapCard});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: actionTapCard,
      child: Image.file(
        file,
        cacheHeight: 500,
        cacheWidth: 500,
        height: 300,
        width: 200,
      ),
    );
  }
}
