import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:make_your_travel/providers/image_hero_animation.dart';
import 'package:make_your_travel/screens/details_image_or_camera/details_image.dart';
import 'package:open_settings_plus/core/open_settings_plus.dart';
import 'package:open_settings_plus/open_settings_plus.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';

class ShowGalleryCamera extends HookConsumerWidget {
  final List<AssetEntity> imagesGallery;
  final List<CameraDescription> cameras;
  final CameraController cameraController;
  const ShowGalleryCamera(
      {super.key,
      required this.imagesGallery,
      required this.cameras,
      required this.cameraController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GridView.builder(
        physics: const ScrollPhysics(parent: ScrollPhysics()),
        shrinkWrap: true,
        itemCount: imagesGallery.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: ((context, index) {
          if (index == 0) {
            return Scaffold(
              body: cameraController.value.isInitialized
                  ? SizedBox(
                      width: double.infinity,
                      child: CameraPreview(cameraController))
                  : InkWell(
                      onTap: () {
                        switch (OpenSettingsPlus.shared) {
                          case OpenSettingsPlusAndroid settings:
                            settings.appSettings();
                          case OpenSettingsPlusIOS settings:
                            settings.appSettings();
                        }
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            "assets/images/camera.png",
                            width: 50,
                            height: 50,
                            fit: BoxFit.contain,
                          ),
                          const Text(
                            "We need access your camera",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                decoration: TextDecoration.underline,
                                decorationColor:
                                    Color.fromARGB(255, 18, 105, 177),
                                color: Color.fromARGB(255, 15, 97, 164)),
                          )
                        ],
                      ),
                    ),
            );
          }
          return GestureDetector(
            onTap: () => {
              ref.read(imageHeroAnimation.notifier).state =
                  imagesGallery[index].id,
              Navigator.of(context)
                  .push(DetailsImage.route(image: imagesGallery[index]))
            },
            child: Hero(
              tag: imagesGallery[index].id,
              child: AssetEntityImage(
                imagesGallery[index],
                thumbnailSize: const ThumbnailSize.square(200),
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
            ),
          );
        }));
  }
}
