import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:make_your_travel/screens/home/home.dart';
import 'package:make_your_travel/states/camera_provider.dart';
import 'package:make_your_travel/states/images_gallery.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:rive/rive.dart';

class SplashScreen extends HookConsumerWidget {
  late final StateMachineController _stateMachineController;
  late CameraController _cameraController;

  SplashScreen({super.key});

  static Route route() => MaterialPageRoute(builder: (_) => SplashScreen());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var cameras = useState<List<CameraDescription>>([]);
    final imagesGallery = ref.watch(imagesGalleryState);
    final cameraController = ref.watch(cameraControllerState);

    handleInitRive(Artboard artboard) {
      _stateMachineController =
          StateMachineController.fromArtboard(artboard, "state")!;
      artboard.play();
      artboard.addController(_stateMachineController);

      _stateMachineController.addEventListener((event) {
        if (event.name == "Finished") {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.of(context).push(HomeScreen.route());
          });
        }
      });
    }

    handleProcessPhoto() async {
      if (imagesGallery.isEmpty) {
        final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
            type: RequestType.image,
            filterOption: FilterOptionGroup(
                imageOption: const FilterOption(
                    needTitle: false,
                    sizeConstraint: SizeConstraint(ignoreSize: true))));
        for (var it in paths) {
          final countAssets = await it.assetCountAsync;
          if (countAssets < 1) return;
          final listAssets =
              await it.getAssetListPaged(page: 0, size: countAssets);

          for (var asset in listAssets) {
            final imageFile = await asset.file ?? File("");
            final StateGalleryImage stateGallery = (image: imageFile,);
            ref.read(imagesGalleryState.notifier).state.add(stateGallery);
          }
        }
      }
    }

    useEffect(() {
      Future.delayed(Duration.zero, () async {
        cameras.value = await availableCameras();
        if (cameras.value.isNotEmpty && cameraController == null) {
          _cameraController = CameraController(
              cameras.value.last, ResolutionPreset.high,
              enableAudio: false);
          await _cameraController.initialize();
          final CameraControllerAndCamerasAvailable
              cameraControllerAndCamerasAvailable =
              (cameraController: _cameraController, cameras: cameras.value);
          ref.read(cameraControllerState.notifier).state =
              cameraControllerAndCamerasAvailable;
        }

        final permissionPhoto = await PhotoManager.requestPermissionExtend();
        if (permissionPhoto.isAuth) {
          await handleProcessPhoto();
        }

        if (permissionPhoto.hasAccess) {
          PhotoManager.setIgnorePermissionCheck(true);
        }
      });
    }, [cameras]);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: RiveAnimation.asset(
        "assets/rive/splash_screen.riv",
        artboard: 'Splash Screen',
        onInit: handleInitRive,
        fit: BoxFit.fill,
      ),
    );
  }
}
