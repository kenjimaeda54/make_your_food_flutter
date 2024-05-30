import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:make_your_travel/screens/home/home.dart';

class CardIImageSuggestions extends HookWidget {
  final CardImagesSuggestions cardSuggestions;
  const CardIImageSuggestions({super.key, required this.cardSuggestions});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onBackground,
            borderRadius: BorderRadius.circular(20)),
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 230,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onBackground,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(cardSuggestions.image)),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  cardSuggestions.title,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                      color: Theme.of(context).colorScheme.primary),
                )),
          ],
        ));
  }
}
