import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:make_your_travel/old_chat/providers/images_gallery.dart';
import 'package:make_your_travel/old_chat/screens/details_image_or_camera/details_image.dart';
import 'package:make_your_travel/old_chat/screens/take_photo/thake_photo.dart';
import 'package:open_settings_plus/core/open_settings_plus.dart';
import 'package:open_settings_plus/open_settings_plus.dart';

class ShowGalleryCamera extends HookConsumerWidget {
  final List<CameraDescription> cameras;

  const ShowGalleryCamera({super.key, required this.cameras});

//slivers sao muito mais performaticos, se estiver problemas com GridView.builder tentar usar ele
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stateGallery = ref.watch(imagesGalleryState);

    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverGrid(
            delegate: SliverChildBuilderDelegate((context, index) {
              if (stateGallery[index].type == TypeImageGallery.controller) {
                return stateGallery[index].cameraController != null
                    ? GestureDetector(
                        onTap: () => Navigator.of(context).push(TakePhoto.route(
                            cameraController:
                                stateGallery[index].cameraController!,
                            cameras: cameras)),
                        child: Hero(
                          tag: stateGallery[index]
                              .cameraController!
                              .description
                              .name,
                          child: SizedBox(
                              width: double.infinity,
                              height: 150,
                              child: CameraPreview(
                                  stateGallery[index].cameraController!)),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          switch (OpenSettingsPlus.shared) {
                            case OpenSettingsPlusAndroid settings:
                              settings.appSettings();
                            case OpenSettingsPlusIOS settings:
                              settings.appSettings();
                          }
                        },
                        child: Image.asset(
                          "assets/images/camera.png",
                          width: double.infinity,
                          height: 150,
                          fit: BoxFit.contain,
                        ),
                      );
              }
              if (stateGallery[index].type == TypeImageGallery.imagem) {
                return GestureDetector(
                  onTap: () => Navigator.of(context).push(
                      DetailsImage.route(image: stateGallery[index].image!)),
                  child: Hero(
                    tag: stateGallery[index].image!.path,
                    child: Image.file(
                      stateGallery[index].image!,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.low,
                      gaplessPlayback: false,
                      width: 200,
                      height: 250,
                      cacheHeight: 500,
                      cacheWidth: 500,
                    ),
                  ),
                );
              }
              return Container();
            }, childCount: stateGallery.length),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 3 / 4,
            ))
      ],
    );
  }
}


// Image(
//                       width: 100,
//                       height: 150,
//                       fit: BoxFit.cover,
//                       filterQuality: FilterQuality.high,
//                       image: ResizeImage(
//                           FileImage(
//                             File(stateGallery[index].image!.path),
//                           ),
//                           width: 500,
//                           height: 500),
//                     ),