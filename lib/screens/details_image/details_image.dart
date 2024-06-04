import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:make_your_travel/screens/search_trip_travel/search_trip_travel.dart';
import 'package:make_your_travel/utils/route_bottom_to_top_animated.dart';
import 'package:make_your_travel/widget/custom_scaffold/custom_scaffold.dart';
import 'package:image_cropper/image_cropper.dart';

class DetailsImage extends HookWidget {
  final File file;
  final String hero;
  const DetailsImage({super.key, required this.file, required this.hero});

  static Route route({required File file, required String hero}) =>
      RouteBottomToTopAnimated(
          widget: DetailsImage(
        file: file,
        hero: hero,
      ));

  @override
  Widget build(BuildContext context) {
    final image = useState<File>(file);

    handleImageCropper() async {
      try {
        final croppedFile = await ImageCropper()
            .cropImage(sourcePath: image.value.path, uiSettings: [
          AndroidUiSettings(
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false)
        ]);
        if (croppedFile != null) {
          image.value = File(croppedFile.path);
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }

    return CustomScaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 50,
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Hero(
                tag: hero,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    image.value,
                    fit: BoxFit.fill,
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: MediaQuery.of(context).size.width * 0.7,
                    cacheHeight: MediaQuery.of(context).size.height.toInt(),
                    cacheWidth: MediaQuery.of(context).size.width.toInt(),
                  ),
                ),
              ),
              Container(
                height: 130,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 13, right: 13),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onBackground,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                child: Row(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => handleImageCropper(),
                      child: Image.asset(
                        "assets/images/trim.png",
                        width: 35,
                        height: 35,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context)
                          .push(SearchTripTravel.route(file)),
                      child: Image.asset(
                        "assets/images/send_message.png",
                        width: 35,
                        height: 35,
                      ),
                    )
                  ],
                ),
              )
            ]),
      ),
    );
  }
}
