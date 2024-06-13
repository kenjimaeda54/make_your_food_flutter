import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:make_your_travel/providers/images_gallery.dart';
import 'package:make_your_travel/screens/details_image/details_image.dart';
import 'package:make_your_travel/screens/home/widget/button_type_travel.dart';
import 'package:make_your_travel/screens/home/widget/card_image_gallery.dart';
import 'package:make_your_travel/screens/home/widget/card_image_suggestions.dart';
import 'package:make_your_travel/screens/search_trip_travel/search_trip_travel.dart';
import 'package:make_your_travel/states/camera_provider.dart';
import 'package:make_your_travel/states/images_gallery.dart';
import 'package:make_your_travel/states/trip_search.dart';
import 'package:make_your_travel/utils/route_bottom_to_top_animated.dart';
import 'package:make_your_travel/utils/typedef.dart';
import 'package:make_your_travel/widget/custom_scaffold/custom_scaffold.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pausable_timer/pausable_timer.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

class HomeScreen extends HookConsumerWidget {
  HomeScreen({super.key});
  final ScrollController _scrollCustomController = ScrollController();
  final ScrollController _scrollControllerList = ScrollController();

  BuildContext? _contextSliverList;
  BuildContext? _contextSliverGrid;

  final List<OptionsTripPlan> optionsTripPlan = [
    (
      id: "fosno",
      imagePath: "assets/icons/bulb.svg",
      title: "Sugestões",
      size: 17
    ),
    (
      id: "fosno343",
      imagePath: "assets/icons/gallery.svg",
      title: "Galeria",
      size: 25
    ),
    (
      id: "fosnof234",
      imagePath: "assets/icons/photo.svg",
      title: "Foto",
      size: 35
    ),
    (
      id: "fosno234232",
      imagePath: "assets/icons/map.svg",
      title: "Viagem",
      size: 30
    ),
  ];

  final List<CardImagesSuggestions> cardSuggestions = [
    (
      image: "assets/images/deserto_sal.jpg",
      title: "Deserto de sal",
      location: 'Uyuni,Bolivia'
    ),
    (
      image: "assets/images/plaza.jpg",
      title: 'Plaza de Espanha',
      location: 'Servilha,Espanha'
    ),
    (
      image: "assets/images/catedral.jpg",
      title: "Catedral Notre Dame",
      location: 'Paris,França'
    ),
    (
      image: "assets/images/estados_unidos.jpg",
      title: "Estátua da Liberdade",
      location: 'Nova Iorque,Estados Unidos'
    )
  ];

  static Route route() {
    return RouteBottomToTopAnimated(widget: HomeScreen());
  }

  Future<File> _getImageFileFromAssets(String path) async {
    final pathSplit = path.split("/");
    final byteData = await rootBundle.load(
        path); //caminho  completo onde esta a imagem exemplo  assets/images/estados_unidos.jpg

    final file = File(
        '${(await getTemporaryDirectory()).path}/${pathSplit[2]}'); //nome do arquivo exemplo estados_unidos.jpg
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idSelected = useState(optionsTripPlan[0].id);
    final imageGalleryProvider = ref.watch(galleryImageNotifierProvider);
    final cameraControllerAndCameraAvailable = ref.watch(cameraControllerState);
    final SliverObserverController sliverObserver =
        SliverObserverController(controller: _scrollCustomController);
    final showFloatingButton = useState(false);
    PausableTimer timer = PausableTimer(const Duration(milliseconds: 600), () {
      showFloatingButton.value = true;
    });
    final isTurnOnFlash = useState(false);
    final isBackCameraDescription = useState(true);

    handleNotifierAssets(MethodCall call) {
      ref.read(galleryImageNotifierProvider.notifier).fetchImagesGallery();
    }

    useEffect(() {
      //entendendo observer scroll
      //https://github.com/fluttercandies/flutter_scrollview_observer/wiki/2%E3%80%81Scrolling-to-the-specified-index-location
      //https://medium.com/@linxunfeng/flutter-scrolling-to-a-specific-item-in-the-scrollview-b89d3f10eee0
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          PhotoManager.addChangeCallback(handleNotifierAssets);
          PhotoManager.startChangeNotify();

          _scrollCustomController.position.isScrollingNotifier.addListener(() {
            //para saber se esta no inicio da lista https://stackoverflow.com/questions/46377779/how-to-check-if-scroll-position-is-at-top-or-bottom-in-listview
            if (_scrollCustomController.position.pixels < 50) {
              showFloatingButton.value = false;
              timer.pause();
            }

            //abaixo para saber quando iniciou ou parou de scrollar
            if (!_scrollCustomController.position.isScrollingNotifier.value &&
                _scrollCustomController.position.pixels > 30) {
              timer.isExpired ? timer.reset() : timer.start();
            }
          });
        },
      );

      return () {
        timer.cancel();

        PhotoManager.removeChangeCallback(handleNotifierAssets);
        PhotoManager.stopChangeNotify();
      };
    }, []);

    Widget returnCardImage(File file) {
      return Hero(
        tag: file.absolute.path,
        child: CardImageGallery(
          file: file,
          actionTapCard: () {
            Navigator.of(context)
                .push(DetailsImage.route(file: file, hero: file.path));
          },
        ),
      );
    }

    shouldReturnWidgetIfClickedButtonType() {
      switch (idSelected.value) {
        case "fosno":
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                  (_, index) => GestureDetector(
                        onTap: () async {
                          try {
                            EasyLoading.show(status: "Aguarde");
                            final file = await _getImageFileFromAssets(
                                cardSuggestions[index].image);
                            ref.read(tripSearch.notifier).state.destiny =
                                cardSuggestions[index].location;
                            ref.read(tripSearch.notifier).state.file = file;
                            if (context.mounted) {
                              Navigator.of(context)
                                  .push(SearchTripTravel.route());
                            }
                            EasyLoading.dismiss();
                          } catch (e) {
                            print(e);
                            EasyLoading.dismiss();
                          }
                        },
                        child: CardIImageSuggestions(
                            cardSuggestions: cardSuggestions[index]),
                      ),
                  childCount: cardSuggestions.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 25,
                  mainAxisSpacing: 25,
                  mainAxisExtent: 300),
            ),
          );

        case "fosnof234":
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
            sliver: SliverToBoxAdapter(
              child: cameraControllerAndCameraAvailable != null
                  ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CameraPreview(
                              cameraControllerAndCameraAvailable
                                  .cameraController),
                        ),
                        Positioned.fill(
                          bottom: 0,
                          top: MediaQuery.of(context).size.height * 0.62,
                          child: Hero(
                            tag: cameraControllerAndCameraAvailable
                                .cameraController.cameraId
                                .toString(),
                            child: Container(
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 13),
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      isTurnOnFlash.value =
                                          !isTurnOnFlash.value;

                                      isTurnOnFlash.value
                                          ? cameraControllerAndCameraAvailable
                                              .cameraController
                                              .setFlashMode(FlashMode.always)
                                          : cameraControllerAndCameraAvailable
                                              .cameraController
                                              .setFlashMode(FlashMode.off);
                                    },
                                    child: isTurnOnFlash.value
                                        ? Image.asset(
                                            "assets/images/flash_off.png",
                                            width: 20,
                                            height: 20,
                                            filterQuality: FilterQuality.high,
                                          )
                                        : Image.asset(
                                            "assets/images/flash_on.png",
                                            width: 20,
                                            height: 20,
                                            filterQuality: FilterQuality.high,
                                          ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      try {
                                        final picture =
                                            await cameraControllerAndCameraAvailable
                                                .cameraController
                                                .takePicture();
                                        final file = File(picture.path);
                                        if (context.mounted) {
                                          Navigator.of(context).push(
                                              DetailsImage.route(
                                                  file: file,
                                                  hero:
                                                      cameraControllerAndCameraAvailable
                                                          .cameraController
                                                          .cameraId
                                                          .toString()));
                                        }
                                      } catch (e) {
                                        print(e);
                                      }
                                    },
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      isBackCameraDescription.value =
                                          !isBackCameraDescription.value;
                                      final frontCamera =
                                          cameraControllerAndCameraAvailable
                                              .cameras
                                              .firstWhere((description) =>
                                                  description.lensDirection ==
                                                  CameraLensDirection.front);
                                      final backCamera =
                                          cameraControllerAndCameraAvailable
                                              .cameras
                                              .firstWhere((description) =>
                                                  description.lensDirection ==
                                                  CameraLensDirection.back);

                                      isBackCameraDescription.value
                                          ? cameraControllerAndCameraAvailable
                                              .cameraController
                                              .setDescription(backCamera)
                                          : cameraControllerAndCameraAvailable
                                              .cameraController
                                              .setDescription(frontCamera);
                                    },
                                    child: Image.asset(
                                      "assets/images/turn.png",
                                      width: 20,
                                      height: 20,
                                      filterQuality: FilterQuality.high,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(),
            ),
          );

        case 'fosno343':
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                _contextSliverGrid ??= context;

                if (index == 0) {
                  return ClipRRect(
                      borderRadius:
                          const BorderRadius.only(topLeft: Radius.circular(10)),
                      child:
                          returnCardImage(imageGalleryProvider[index].image!));
                }

                if (index == 2) {
                  return ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(10)),
                      child:
                          returnCardImage(imageGalleryProvider[index].image!));
                }

                return returnCardImage(imageGalleryProvider[index].image!);
              }, childCount: imageGalleryProvider.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
            ),
          );

        default:
          return const SliverToBoxAdapter();
      }
    }

    return CustomScaffold(
      floatingActionButton: showFloatingButton.value
          ? ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(
                      Theme.of(context).colorScheme.primary),
                  shape: const MaterialStatePropertyAll<CircleBorder>(
                      CircleBorder())),
              child: Icon(
                Icons.keyboard_arrow_up_outlined,
                size: 20,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              onPressed: () => sliverObserver.innerAnimateTo(
                sliverContext: _contextSliverList,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                index: 0,
              ),
            )
          : null,
      body: SliverViewObserver(
        controller: sliverObserver,
        sliverContexts: () {
          return [
            if (_contextSliverList != null) _contextSliverList!,
            if (_contextSliverGrid != null) _contextSliverGrid!,
          ];
        },
        child: CustomScrollView(
          controller: _scrollCustomController,
          physics:
              const ClampingScrollPhysics(), //para evitar o bounce no scroll
          slivers: [
            SliverPadding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 30,
                    left: 13,
                    right: 0),
                sliver: SliverToBoxAdapter(
                  child: SizedBox(
                    height: 50, //precisa do height para nao quebrar
                    child: ListView.builder(
                        physics:
                            const ClampingScrollPhysics(), //para evitar o bounce na aniamacao
                        scrollDirection: Axis.horizontal,
                        itemCount: optionsTripPlan.length,
                        controller: _scrollControllerList,
                        itemBuilder: ((context, index) {
                          _contextSliverList ??=
                              context; //Assign value to b if b is null; otherwise, b stays the same , ou seja se _contextSliverList for nullo assume ele se nao o direito
                          //cursorColor ??= selectionTheme.cursorColor ?? cupertinoTheme.primaryColor;
                          //https://stackoverflow.com/questions/72207475/what-do-these-symbols-mean-in-flutter
                          //nao possui sliver horizontal

                          return ButtonTypeTravel(
                            tripPlan: optionsTripPlan[index],
                            idSelected: idSelected.value,
                            actionTapTypeTravel: () {
                              switch (index) {
                                case 3:
                                  Navigator.of(context)
                                      .push(SearchTripTravel.route())
                                      .then((value) {
                                    if (index == 3) {
                                      idSelected.value = optionsTripPlan[0].id;
                                      _scrollControllerList.animateTo(
                                        0, //largura do item vezes o index
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  });
                              }

                              _scrollControllerList.animateTo(
                                index * 120, //largura do item vezes o index
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                              idSelected.value = optionsTripPlan[index].id;
                            },
                          );
                        })),
                  ),
                )),
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
            ),
            shouldReturnWidgetIfClickedButtonType()
          ],
        ),
      ),
    );
  }
}
