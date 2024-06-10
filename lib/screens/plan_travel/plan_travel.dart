import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:make_your_travel/states/trip_search.dart';
import 'package:make_your_travel/utils/route_bottom_to_top_animated.dart';
import 'package:make_your_travel/utils/typedef.dart';
import 'package:make_your_travel/widget/custom_scaffold/custom_scaffold.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

typedef LatitudeAndLongitude = ({String latitude, String longitude});

class PlanTravel extends HookConsumerWidget {
  final ResponseGemini responseGemini;
  const PlanTravel({super.key, required this.responseGemini});

  static Route route({required ResponseGemini responseGemini}) =>
      RouteBottomToTopAnimated(
          widget: PlanTravel(
        responseGemini: responseGemini,
      ));

  _returnTitleAndSubtitle(BuildContext context, String title, String subTitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.primary,
                fontSize: 21)),
        const SizedBox(
          height: 35,
        ),
        SelectableLinkify(
          onOpen: (link) async {
            try {
              final uri = Uri.parse(link.url);
              launchUrl(uri);
            } catch (e) {
              print(e);
            }
          },
          text: subTitle,
          style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.primary,
              height: 1.4,
              fontSize: 17),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 25),
          child: Divider(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final whatDoCity = useState("");
    final hotels = useState("");
    final bestRoute = useState('');
    final documentTravel = useState<String?>(null);

    useEffect(() {
      Future.delayed(Duration.zero, () {
        for (var part in responseGemini.whatDoCity.parts!) {
          whatDoCity.value = "${part.text} ";
        }
        for (var part in responseGemini.hotels.parts!) {
          hotels.value = "${part.text} ";
        }

        for (var part in responseGemini.bestRoute.parts!) {
          bestRoute.value = "${part.text} ";
        }

        if (responseGemini.documentNeedTravel?.parts != null) {
          for (var part in responseGemini.documentNeedTravel!.parts!) {
            documentTravel.value = "${part.text} ";
          }
        }
      });
    }, const []);

    String returnContentIfInternational() {
      return documentTravel.value != null
          ? "Moeda local: \n\n ${responseGemini.countryCurrency} \n\n\n  ------------- \n\n\n Documents para viagem internacional:  \n\n $documentTravel"
          : "";
    }

    return CustomScaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          title: Text(
            "Resumo para viagem",
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20,
                fontWeight: FontWeight.w700),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 33),
              child: InkWell(
                  onTap: () {
                    final shareContent =
                        "Hospedagem: \n\n ${hotels.value} \n\n\n -------------  \n\n\n Oque fazer na cidade: \n\n ${whatDoCity.value} \n\n\n ------------- \n\n\n Melhor trajeto: \n\n ${bestRoute.value} \n\n\n -------------  \n\n\n ${returnContentIfInternational()}";
                    Share.share(shareContent,
                        subject:
                            "Viagem de ${ref.read(tripSearch).origin.split(",")[0]} para ${ref.read(tripSearch).destiny.split(",")[0]}");
                  },
                  child: const Icon(Icons.share_rounded)),
            )
          ],
          backgroundColor: Colors.transparent,
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 15,
                    bottom: MediaQuery.of(context).padding.bottom + 25,
                    left: 13,
                    right: 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _returnTitleAndSubtitle(
                        context, "Hospedagem", hotels.value),
                    _returnTitleAndSubtitle(
                        context,
                        "Oque fazer na cidade ${ref.read(tripSearch).destiny.split(",")[0]}",
                        whatDoCity.value),
                    _returnTitleAndSubtitle(
                        context,
                        "Melhor trajeto partindo de ${ref.read(tripSearch).origin.split(",")[0]} ate  ${ref.read(tripSearch).destiny.split(",")[0]}'",
                        bestRoute.value),
                    documentTravel.value != null
                        ? _returnTitleAndSubtitle(context, "Moeda local",
                            responseGemini.countryCurrency)
                        : const SizedBox(),
                    documentTravel.value != null
                        ? _returnTitleAndSubtitle(
                            context,
                            "Documentos obrigatórios para viagem internacional",
                            documentTravel.value!)
                        : SizedBox()
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
