import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

typedef Questions = ({int type, String title});

class OptionsTravel extends HookWidget {
  final List<Questions> options = [
    (
      title:
          "Plano de viagem completo da cidade onde se localiza até a cidade de destino",
      type: 1
    ),
    (title: "Sugestões do que fazer na cidade de sua preferência", type: 2),
    (
      title:
          "Plano de viagem completo da cidade que voce deseja partir ate cidade de destino",
      type: 3
    )
  ];
  OptionsTravel({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...options.map((it) => Padding(
              padding: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
              child: Row(
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                          text: "${it.type.toString()} ",
                          style: TextStyle(
                              decorationColor:
                                  Theme.of(context).colorScheme.secondary,
                              color: Theme.of(context).colorScheme.secondary,
                              fontWeight: FontWeight.w400,
                              height: 1.3,
                              fontSize: 17),
                          children: [TextSpan(text: it.title)]),
                    ),
                  ),
                ],
              ),
            ))
      ],
    );
  }
}
