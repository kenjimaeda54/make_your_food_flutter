import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:make_your_travel/screens/search_trip_travel/widget/text_field_common.dart';
import 'package:make_your_travel/screens/selection_date/selection_date.dart';
import 'package:make_your_travel/states/trip_search.dart';
import 'package:make_your_travel/utils/route_bottom_to_top_animated.dart';
import 'package:make_your_travel/widget/custom_scaffold/custom_scaffold.dart';

class SearchTripTravel extends HookConsumerWidget {
  const SearchTripTravel({super.key});

  static Route route() =>
      RouteBottomToTopAnimated(widget: const SearchTripTravel());

//aplicar dropdown para quanitdade de pessoas
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatDate = DateFormat("d MMMM  'de'   y, EEEE", 'pt_BR');
    final stateTrip = ref.watch(tripSearch);
    final dateStart = useState<String>("");
    final dateEnd = useState<String>("");

    bool shouldReturnTrueIfDisableButton() {
      return dateStart.value.isEmpty ||
          dateEnd.value.isEmpty ||
          stateTrip.from.isEmpty ||
          stateTrip.to.isEmpty ||
          stateTrip.quantityPeople == 0;
    }

    String shouldReturnDateStart() {
      return stateTrip.dayStart == null
          ? formatDate.format(DateTime.now())
          : formatDate.format(stateTrip.dayStart!);
    }

    String shouldReturnDateEnd() {
      if (stateTrip.dayEnd == null) {
        return stateTrip.dayStart == null
            ? formatDate.format(DateTime.now().add(const Duration(days: 1)))
            : formatDate
                .format(stateTrip.dayStart!.add(const Duration(days: 1)));
      }
      return formatDate.format(stateTrip.dayEnd!);
    }

    useEffect(() {
      dateStart.value = shouldReturnDateStart();
      dateEnd.value = shouldReturnDateEnd();
    }, const []);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), //limpar qualquer foco
      child: CustomScaffold(
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
            "Pesquisa de viagem",
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20,
                fontWeight: FontWeight.w700),
          ),
          // leadingWidth: MediaQuery.of(context).size.width * 0.14,
          backgroundColor: Colors.transparent,
        ),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 100,
                  bottom: MediaQuery.of(context).padding.bottom + 30,
                  left: 13,
                  right: 13),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const TextFieldCommon(
                    hintText: 'De',
                    textInputAction: TextInputAction.next,
                  ),
                  const TextFieldCommon(
                    hintText: 'Para',
                    textInputAction: TextInputAction.next,
                  ),
                  TextFieldCommon(
                    hintText: 'Quantidade de pessoas',
                    textInputAction: TextInputAction.done,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context)
                        .push(SelectionDate.route(isDateStart: true))
                        .then((value) {
                      dateStart.value = shouldReturnDateStart();
                      dateEnd.value = shouldReturnDateEnd();
                    }),
                    child: TextFieldCommon(
                        enabled: false, hintText: "De ${dateStart.value}"),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context)
                        .push(SelectionDate.route(isDateStart: false))
                        .then((value) {
                      dateStart.value = shouldReturnDateStart();
                      dateEnd.value = shouldReturnDateEnd();
                    }),
                    child: TextFieldCommon(
                        enabled: false, hintText: "Ate ${dateEnd.value}"),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: shouldReturnTrueIfDisableButton()
                                ? MaterialStatePropertyAll<Color>(
                                    Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.7))
                                : MaterialStatePropertyAll<Color>(
                                    Theme.of(context).colorScheme.primary),
                            padding: const MaterialStatePropertyAll<
                                    EdgeInsetsGeometry>(
                                EdgeInsets.symmetric(
                                    horizontal: 13, vertical: 10))),
                        onPressed:
                            shouldReturnTrueIfDisableButton() ? null : () {},
                        child: Text(
                          "Pesquisar",
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: shouldReturnTrueIfDisableButton()
                                  ? Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.5)
                                  : Theme.of(context).colorScheme.onBackground,
                              fontSize: 17),
                        )),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
