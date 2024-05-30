import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:make_your_travel/screens/home/widget/button_type_travel.dart';
import 'package:make_your_travel/screens/home/widget/card_image_gallery.dart';
import 'package:make_your_travel/screens/home/widget/card_image_suggestions.dart';
import 'package:make_your_travel/states/camera_provider.dart';
import 'package:make_your_travel/states/images_gallery.dart';
import 'package:make_your_travel/utils/gradient_color.dart';
import 'package:make_your_travel/widget/custom_scaffold/custom_scaffold.dart';
import 'package:pausable_timer/pausable_timer.dart';
import 'package:rive/rive.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

typedef OptionsTripPlan = ({
  String id,
  String title,
  String imagePath,
  double size
});

typedef CardImagesSuggestions = ({String title, String image});

class HomeScreen extends HookConsumerWidget {
  HomeScreen({super.key});
  final ScrollController _scrollController = ScrollController();
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
    (image: "assets/images/deserto_sal.jpg", title: "Deserto de sal"),
    (image: "assets/images/plaza.jpg", title: 'Plaza de Espanha'),
    (image: "assets/images/catedral.jpg", title: "Catedral Notre Dame"),
    (image: "assets/images/estados_unidos.jpg", title: "Estátua da Liberdade")
  ];

  static Route route() {
    return PageRouteBuilder(
        pageBuilder: (_, __, ___) => HomeScreen(),
        transitionsBuilder: (_, animation, __, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idSelected = useState(optionsTripPlan[0].id);
    final imageGallery = ref.watch(imagesGalleryState);
    final cameraController = ref.watch(cameraControllerState);
    final SliverObserverController sliverObserver =
        SliverObserverController(controller: _scrollController);
    final showFloatingButton = useState(false);
    PausableTimer timer = PausableTimer(const Duration(milliseconds: 600), () {
      showFloatingButton.value = true;
    });

    useEffect(() {
      //entendendo observer scroll
      //https://github.com/fluttercandies/flutter_scrollview_observer/wiki/2%E3%80%81Scrolling-to-the-specified-index-location
      //https://medium.com/@linxunfeng/flutter-scrolling-to-a-specific-item-in-the-scrollview-b89d3f10eee0
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          _scrollController.position.isScrollingNotifier.addListener(() {
            //para saber se esta no inicio da lista https://stackoverflow.com/questions/46377779/how-to-check-if-scroll-position-is-at-top-or-bottom-in-listview
            if (_scrollController.position.pixels < 50) {
              showFloatingButton.value = false;
              timer.pause();
            }

            //abaixo para saber quando iniciou ou parou de scrollar
            if (!_scrollController.position.isScrollingNotifier.value &&
                _scrollController.position.pixels > 30) {
              timer.isExpired ? timer.reset() : timer.start();
            }
          });
        },
      );
      return () {
        timer.cancel();
      };
    }, []);

    shouldReturnWidgetIfClickedButtonType() {
      switch (idSelected.value) {
        case "fosno":
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                  (_, index) => CardIImageSuggestions(
                      cardSuggestions: cardSuggestions[index]),
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
              child: Expanded(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: CameraPreview(cameraController!),
                    )
                  ],
                ),
              ),
            ),
          );
        default:
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                _contextSliverGrid ??= context;
                if (index == 0) {
                  return ClipRRect(
                    borderRadius:
                        const BorderRadius.only(topLeft: Radius.circular(10)),
                    child: CardImageGallery(file: imageGallery[index].image!),
                  );
                }
                ;
                if (index == 2) {
                  return ClipRRect(
                    borderRadius:
                        const BorderRadius.only(topRight: Radius.circular(10)),
                    child: CardImageGallery(file: imageGallery[index].image!),
                  );
                }
                ;
                return CardImageGallery(file: imageGallery[index].image!);
              }, childCount: imageGallery.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
            ),
          );
      }
    }

    return CustomScaffold(
      gradient: gradientBackground,
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
          controller: _scrollController,
          physics: const ClampingScrollPhysics(),
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
                        scrollDirection: Axis.horizontal,
                        itemCount: optionsTripPlan.length,
                        itemBuilder: ((context, index) {
                          _contextSliverList ??=
                              context; //Assign value to b if b is null; otherwise, b stays the same , ou seja se _contextSliverList for nullo assume ele se nao o direito
                          //cursorColor ??= selectionTheme.cursorColor ?? cupertinoTheme.primaryColor;
//https://stackoverflow.com/questions/72207475/what-do-these-symbols-mean-in-flutter

                          return ButtonTypeTravel(
                            tripPlan: optionsTripPlan[index],
                            idSelected: idSelected.value,
                            actionTapTypeTravel: () {
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
