import 'dart:io';
import 'package:hooks_riverpod/hooks_riverpod.dart';

typedef StateGalleryImage = ({
  File? image,
});

final imagesGalleryState = StateProvider<List<StateGalleryImage>>((ref) => []);
