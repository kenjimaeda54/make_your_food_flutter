import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:make_your_travel/client/forecast_weather.dart';
import 'package:make_your_travel/data/data_or_expection.dart';
import 'package:make_your_travel/models/weather/weather_model.dart';
import 'package:make_your_travel/screens/plan_travel/plan_travel.dart';
import 'package:make_your_travel/screens/search_trip_travel/widget/text_field_common.dart';
import 'package:make_your_travel/screens/selection_date/selection_date.dart';
import 'package:make_your_travel/states/trip_search.dart';
import 'package:make_your_travel/utils/route_bottom_to_top_animated.dart';
import 'package:make_your_travel/utils/typedef.dart';
import 'package:make_your_travel/widget/custom_scaffold/custom_scaffold.dart';

class SearchTripTravel extends HookConsumerWidget {
  final _gemini = Gemini.instance;

  SearchTripTravel({super.key});

  static Route route([File? file]) =>
      RouteBottomToTopAnimated(widget: SearchTripTravel());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatDate = DateFormat("d MMMM  'de'   y, EEEE", 'pt_BR');
    final stateTrip = ref.watch(tripSearch);
    final dateStart = useState<String>("");
    final dateEnd = useState<String>("");
    final isLoading = useState<bool>(false);

    Future<List<DataOrException<ForecastWeather>>>
        handleListFuturesWeather() async {
      final state = ref.read(tripSearch);
      final formatDateApi = DateFormat("yyyy-MM-dd");
      var temporalDay = 1;
      final listSixDay =
          List.generate(6, (index) => index * index, growable: false);
      final listDate = listSixDay.map((e) {
        final date = state.dayStart!.add(Duration(days: temporalDay));
        temporalDay += 1;
        return date;
      }).toList();

      final serviceFutureWeather = ForecastWeatherService();
      //https://stackoverflow.com/questions/55502528/flutter-multiple-async-methods-for-parrallel-execution
      final dateApiWhenStartTravel = formatDateApi.format(state.dayStart!);

      if (state.dayStart!.isAtSameMomentAs(DateTime.now())) {
        await Future.wait([
          serviceFutureWeather.fetchForecastWeather(
              city: state.destiny, date: dateApiWhenStartTravel),
          ...listDate.map((it) => serviceFutureWeather.fetchForecastWeather(
              city: state.destiny, date: formatDateApi.format(it)))
        ]);
      }

      if (DateTime.now().difference(state.dayStart!).inDays < 14) {
        return await Future.wait([
          serviceFutureWeather.fetchForecastWeather(
              city: state.destiny, date: dateApiWhenStartTravel),
          ...listDate.map((it) {
            if (it.difference(DateTime.now()).inDays < 14) {
              return serviceFutureWeather.fetchForecastWeather(
                  city: state.destiny, date: formatDateApi.format(it));
            }
            return serviceFutureWeather.fetchFutureForecastWeather(
                city: state.destiny, date: formatDateApi.format(it));
          })
        ]);
      }

      return Future.wait([
        serviceFutureWeather.fetchFutureForecastWeather(
            city: state.destiny, date: dateApiWhenStartTravel),
        ...listDate.map((it) => serviceFutureWeather.fetchFutureForecastWeather(
            city: state.destiny, date: formatDateApi.format(it)))
      ]);
    }

    bool shouldReturnTrueIfDisableButton() {
      return ref.read(tripSearch).file == null
          ? dateStart.value.isEmpty ||
              dateEnd.value.isEmpty ||
              stateTrip.origin.isEmpty ||
              stateTrip.destiny.isEmpty ||
              stateTrip.quantityPeople == 0 ||
              stateTrip.dayEnd == null ||
              stateTrip.dayStart == null
          : dateStart.value.isEmpty ||
              dateEnd.value.isEmpty ||
              stateTrip.destiny.isEmpty ||
              stateTrip.quantityPeople == 0 ||
              stateTrip.dayEnd == null ||
              stateTrip.dayStart == null;
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
      Future.delayed(Duration.zero, () {
        if (stateTrip.dayStart == null) {
          ref.read(tripSearch.notifier).state.dayStart = DateTime.now();
        }
        if (stateTrip.dayEnd == null) {
          ref.read(tripSearch.notifier).state.dayEnd =
              DateTime.now().add(const Duration(days: 1));
        }
      });
    }, []);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(), //limpar qualquer foco
      child: CustomScaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              if (ref.read(tripSearch).file != null) {
                ref.read(tripSearch.notifier).state.file = null;
              }
              Navigator.of(context).popUntil(ModalRoute.withName("/home"));
            },
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
                  ref.read(tripSearch).file != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Destino",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.file(
                                ref.read(tripSearch).file!,
                                height: 150,
                                width: double.infinity,
                                cacheHeight:
                                    MediaQuery.of(context).size.height.toInt(),
                                cacheWidth:
                                    MediaQuery.of(context).size.width.toInt(),
                                fit: BoxFit.fill,
                                filterQuality: FilterQuality.high,
                              ),
                            )
                          ],
                        )
                      : TextFieldCommon(
                          label: 'Origem',
                          hintText: 'Sao Paulo,Brasil',
                          textInputAction: TextInputAction.next,
                          onChanged: (value) => ref
                              .read(tripSearch.notifier)
                              .state
                              .origin = value,
                        ),
                  TextFieldCommon(
                    label: ref.read(tripSearch).file != null
                        ? 'Origem'
                        : 'Destino',
                    hintText: 'Rio de Janeiro,Brasil',
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      ref.read(tripSearch).file == null
                          ? ref.read(tripSearch.notifier).state.destiny = value
                          : ref.read(tripSearch.notifier).state.origin = value;
                    },
                  ),
                  TextFieldCommon(
                    label: 'Quantidade de pessoas',
                    hintText: '1',
                    textInputAction: TextInputAction.done,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) => ref
                        .read(tripSearch.notifier)
                        .state
                        .quantityPeople = int.parse(value),
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true, signed: true),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context)
                        .push(SelectionDate.route(isDateStart: true))
                        .then((value) {
                      if (ref.read(tripSearch).dayEnd != null &&
                          ref
                              .read(tripSearch)
                              .dayEnd!
                              .isBefore(ref.read(tripSearch).dayStart!)) {
                        final currentDayEnd = ref
                            .read(tripSearch)
                            .dayStart!
                            .add(const Duration(days: 1));
                        ref.read(tripSearch.notifier).state.dayEnd =
                            currentDayEnd;
                      }
                      dateStart.value = shouldReturnDateStart();
                      dateEnd.value = shouldReturnDateEnd();
                    }),
                    child: TextFieldCommon(
                        label: 'Data de partida',
                        enabled: false,
                        hintText: dateStart.value),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context)
                        .push(SelectionDate.route(isDateStart: false))
                        .then((value) {
                      dateStart.value = shouldReturnDateStart();
                      dateEnd.value = shouldReturnDateEnd();
                    }),
                    child: TextFieldCommon(
                        label: 'Data de retorno',
                        enabled: false,
                        hintText: dateEnd.value),
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
                        onPressed: shouldReturnTrueIfDisableButton() ||
                                isLoading.value
                            ? null
                            : () async {
                                isLoading.value = true;
                                EasyLoading.show(status: 'Aguarde');
                                final state = ref.read(tripSearch);
                                var countryCurrency = "";
                                Content? documentNeedTravel;

                                final fetchTemperatureState =
                                    await handleListFuturesWeather();
                                final lengthsErros = fetchTemperatureState
                                    .where((element) => element.data == null);

                                if (lengthsErros.isEmpty) {
                                  final List<TemperatureOnTravel>
                                      temperaturesTravel =
                                      fetchTemperatureState.map((e) {
                                    final dateConverted = DateTime.parse(e
                                        .data!.forecast.forecastDay.first.date);

                                    final TemperatureOnTravel temperature = (
                                      date: dateConverted,
                                      temperatureMaximum:
                                          "${e.data!.forecast.forecastDay.first.day.maxTemperature} ºC",
                                      temperatureMinimum:
                                          "${e.data!.forecast.forecastDay.first.day.minTemperature} ºC",
                                      icon: e.data!.forecast.forecastDay.first
                                          .day.condition.icon,
                                      chanceOfRain:
                                          "${e.data!.forecast.forecastDay.first.hour.first.chanceOfRain} %",
                                      condition: e.data!.forecast.forecastDay
                                          .first.day.condition.text
                                    );
                                    return temperature;
                                  }).toList();

                                  final hotels = await _gemini.text(
                                      "Me traga informações como telefone, endereço,link para navegar na internet, valores de  lugares para hospedar em ${state.destiny} do dia ${dateStart} ate ${dateEnd} para ${state.quantityPeople} pessoas.");

                                  final isInternational = await _gemini.text(
                                      "Partindo da cidade ${state.origin} ate ${state.destiny}, me retorna 1 para viagem internacional ou 0");

                                  if (int.parse(isInternational!
                                          .content!.parts!.last.text!) ==
                                      1) {
                                    final currency = await _gemini.text(
                                        "Qual e a moeda da cidade ${state.destiny}");
                                    final documentTravel = await _gemini.text(
                                        "Quais documentos preciso para viajar da cidade ${state.origin} ate ${state.destiny}. Exemplo visto,vacina,bagagens");
                                    countryCurrency =
                                        currency!.content?.parts?.last.text ??
                                            "";
                                    documentNeedTravel =
                                        documentTravel!.content!;
                                  }

                                  final whatDoCity = await _gemini.text(
                                      "Oque fazer na cidade ${state.destiny} entre os dias ${dateStart} ate ${dateEnd} ?");

                                  final bestRoute = await _gemini.text(
                                      "Me traga informações completa saindo da cidade ${state.origin} ate ${state.destiny}, quero saber possíveis linhas de ônibus,avião ou carro particular. Se possível me envia link com o trajeto preenchido no google maps apenas para carros particulares");
                                  final ResponseGemini responseGemini = (
                                    countryCurrency: countryCurrency,
                                    hotels: hotels!.content!,
                                    bestRoute: bestRoute!.content!,
                                    isInternational: false,
                                    whatDoCity: whatDoCity!.content!,
                                    documentNeedTravel: documentNeedTravel,
                                    temperatures: [...temperaturesTravel]
                                  );
                                  Navigator.of(context).push(PlanTravel.route(
                                      responseGemini: responseGemini));
                                  EasyLoading.dismiss();
                                  isLoading.value = false;
                                  return;
                                }
                                if (lengthsErros.isNotEmpty) {
                                  EasyLoading.dismiss();
                                  isLoading.value = false;
                                }
                              },
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
