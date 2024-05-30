import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:make_your_travel/screens/home/widget/button_type_travel.dart';
import 'package:make_your_travel/screens/home/widget/card_image_suggestions.dart';
import 'package:make_your_travel/utils/gradient_color.dart';
import 'package:make_your_travel/widget/custom_scaffold/custom_scaffold.dart';

typedef OptionsTripPlan = ({
  String id,
  String title,
  String imagePath,
  double size
});

typedef CardImagesSuggestions = ({String title, String image});

class HomeScreen extends HookWidget {
  HomeScreen({super.key});
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
  Widget build(BuildContext context) {
    final idSelected = useState(optionsTripPlan[0].id);
    return CustomScaffold(
      gradient: gradientBackground,
      body: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 30, left: 13, right: 0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 50, //precisa do height para nao quebrar
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: optionsTripPlan.length,
                  itemBuilder: ((context, index) => ButtonTypeTravel(
                        tripPlan: optionsTripPlan[index],
                        idSelected: idSelected.value,
                      )),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
            ),
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                  (_, index) => Padding(
                        padding: const EdgeInsets.only(right: 13),
                        child: CardIImageSuggestions(
                            cardSuggestions: cardSuggestions[index]),
                      ),
                  childCount: cardSuggestions.length),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 25,
                  mainAxisSpacing: 25,
                  mainAxisExtent: 300),
            )
          ],
        ),
      ),
    );
  }
}
