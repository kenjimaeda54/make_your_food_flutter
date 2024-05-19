import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';

class ShowGalleryCamera extends HookWidget {
  final List<XFile> imagesGallery;
  const ShowGalleryCamera({super.key, required this.imagesGallery});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
        shrinkWrap: true,
        itemCount: imagesGallery.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: ((context, index) {
          return Image.file(
            File(imagesGallery[index].path),
            width: 300,
            height: 400,
            fit: BoxFit.cover,
          );
        }));
  }
}
