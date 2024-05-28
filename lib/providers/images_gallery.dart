import 'dart:io';

import 'package:camera/camera.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum TypeImageGallery { imagem, controller }

typedef StateGalleryImage = ({
  TypeImageGallery type,
  CameraController? cameraController,
  File? image,
});

final imagesGalleryState = StateProvider<List<StateGalleryImage>>((ref) => []);
