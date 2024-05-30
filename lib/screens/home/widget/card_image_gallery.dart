import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CardImageGallery extends HookWidget {
  final File file;
  const CardImageGallery({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Image.file(
      file,
      cacheHeight: 500,
      cacheWidth: 500,
      height: 300,
      width: 200,
    );
  }
}
