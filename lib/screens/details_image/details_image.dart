import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:make_your_travel/screens/search_trip_travel/search_trip_travel.dart';
import 'package:make_your_travel/states/trip_search.dart';
import 'package:make_your_travel/utils/route_bottom_to_top_animated.dart';
import 'package:make_your_travel/widget/custom_scaffold/custom_scaffold.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class DetailsImage extends HookConsumerWidget {
  final File file;
  final String hero;

  DetailsImage({super.key, required this.file, required this.hero});
  final _gemini = Gemini.instance;
  late AnimationController localAnimationController;

  static Route route({required File file, required String hero}) =>
      RouteBottomToTopAnimated(
          widget: DetailsImage(
        file: file,
        hero: hero,
      ));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final image = useState<File>(file);
    final isLoading = useState(false);

    useEffect(() {
      Future.delayed(Duration.zero, () {
        ref.read(tripSearch.notifier).state.file = file;
      });
    }, const []);

    showSnackBar() {
      showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
              message: 'Foto  ruim,tente apos cortar ou escolha outra'),
          persistent: true,
          onAnimationControllerInit: (value) =>
              localAnimationController = value,
          onTap: () => localAnimationController.reverse());
    }

    handleImageCropper() async {
      try {
        final croppedFile = await ImageCropper()
            .cropImage(sourcePath: image.value.absolute.path, uiSettings: [
          AndroidUiSettings(
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false)
        ]);
        if (croppedFile != null) {
          image.value = File(croppedFile.path);
          ref.read(tripSearch.notifier).state.file = File(croppedFile.path);
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
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.11,
          ),
          Align(
            alignment: Alignment.center,
            child: Hero(
              tag: hero,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  image.value,
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                  gaplessPlayback: true,
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.9,
                  cacheHeight: MediaQuery.of(context).size.height.toInt(),
                  cacheWidth: MediaQuery.of(context).size.width.toInt(),
                ),
              ),
            ),
          ),
          Spacer(),
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
                  onTap: isLoading.value
                      ? null
                      : () {
                          isLoading.value = true;
                          EasyLoading.show(status: "Aguarde");

                          _gemini.textAndImage(
                            text:
                                "Onde fica esta imagem, apenas a cidade,pais?",
                            images: [
                              ref.read(tripSearch).file!.readAsBytesSync()
                            ],
                          ).then((value) {
                            ref.read(tripSearch.notifier).state.destiny =
                                value!.content!.parts?.last.text ?? "";
                            Navigator.of(context)
                                .push(SearchTripTravel.route());
                            EasyLoading.dismiss();
                            isLoading.value = false;
                          }).catchError((error) {
                            EasyLoading.dismiss();
                            showSnackBar();
                            isLoading.value = false;
                          });
                        },
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
