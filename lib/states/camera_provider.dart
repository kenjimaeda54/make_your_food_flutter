import 'package:camera/camera.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

typedef CameraControllerAndCamerasAvailable = ({
  CameraController cameraController,
  List<CameraDescription> cameras
});

final cameraControllerState =
    StateProvider<CameraControllerAndCamerasAvailable?>((ref) => null);
