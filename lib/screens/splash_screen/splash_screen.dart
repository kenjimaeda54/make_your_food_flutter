import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:make_your_travel/providers/images_gallery.dart';
import 'package:make_your_travel/states/camera_provider.dart';
import 'package:rive/rive.dart';

class SplashScreen extends HookConsumerWidget {
  late final StateMachineController _stateMachineController;
  late CameraController _cameraController;

  SplashScreen({super.key});

  static Route route() => MaterialPageRoute(builder: (_) => SplashScreen());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var cameras = useState<List<CameraDescription>>([]);
    final cameraController = ref.watch(cameraControllerState);

    handleInitRive(Artboard artboard) {
      _stateMachineController =
          StateMachineController.fromArtboard(artboard, "state")!;
      artboard.play();
      artboard.addController(_stateMachineController);

      _stateMachineController.addEventListener((event) {
        if (event.name == "Finished") {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            Navigator.of(context).pushNamed("/home");
          });
        }
      });
    }

    useEffect(() {
      Future.delayed(Duration.zero, () {
        ref.read(galleryImageNotifierProvider.notifier).fetchImagesGallery();
      });
    }, const []);

    useEffect(() {
      Future.delayed(Duration.zero, () async {
        try {
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
        } catch (e) {
          print(e);
          ref.read(cameraControllerState.notifier).state = null;
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
