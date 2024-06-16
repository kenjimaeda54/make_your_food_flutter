# Make Your Travel

Aplicativo para auxiliar nas suas proximas viagens, possivel pesquisar viagens a partir de fotos da sua galeria,fotos retiradas no momento pelo camera,  sugestoes que sao viagens pre defindas ou pesquisar atraves dum formularo

## Funcionalidades
- Para app funconar precisa da chave key do [Gemini](https://ai.google.dev/) e da [API de tempo](https://www.weatherapi.com, consultar o arquivo .env.example
- Para lidar com datas e mensagens no app na lingua em portugues useii o recurso de locationsDelegates


```dart

//no main

localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

supportedLocales: const [
        Locale('en'),
        Locale('pt', 'pt_BR'),
      ],
locale: const Locale('pt', 'pt_BR'),


```

##

- Para converter imagens do assets em umm arquivo do tipo file pode seguir o alogartmo abaixo
- Path precisa ser o caminho completo de onde esta o arquivo no meu exemplo assets/images/estados_unidos.png, para gerar o file preciso de pegar o arquivo temmporaro usando uma funcao pre defiiinda do flutter [Path Provider](https://pub.dev/packages/path_provider) e usar o nome da imagem no caso estados_unidos.png

```dart


  Future<File> _getImageFileFromAssets(String path) async {
    final pathSplit = path.split("/");
    final byteData = await rootBundle.load(
        path); 

    final file = File(
        '${(await getTemporaryDirectory()).path}/${pathSplit[2]}'); 
    await file.create(recursive: true);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }


final file = await _getImageFileFromAssets(
                                cardSuggestions[index].image);



```

##

- Para lidar com scroll usando sliver usei [Scroll View Observer](https://pub.dev/packages/scrollview_observer) 
- [Consulta interessante para entender observer scroll])(https://github.com/fluttercandies/flutter_scrollview_observer/wiki/2%E3%80%81Scrolling-to-the-specified-index-location)
- [Consulta interessante para entender observer scroll)(https://medium.com/@linxunfeng/flutter-scrolling-to-a-specific-item-in-the-scrollview-b89d3f10eee0(
- Repara que envolvi o customScrollView em volta do SliverViewObserver e usei o _scrollCustomController no controller
- Tambem preciso referenciar os contexto para saber onde irei scrollar
- Para relizar acao de scroll usei o floatingButton ele aparece apos usuariio scrollar alguns pixel , para fazer isto uso o  sliverObserver.innerAnimateTo apontando o iindex e o contexto.
- Botao ira aparecer apenas apos 600 milesseconds que inciiou scroll para realiizar essa logiica useii o [pausable_timer](https://pub.dev/packages/pausable_timer)
- Repara qeu apos maior qeu 30 pixel irei fazer com que o timer seja iniciado e caso ele fo expirado darie o reset dentro do useffect e quando a posicao for menor que 50 irei pauser o timer e esconder o botao

```dart
final ScrollController _scrollCustomController = ScrollController();
final SliverObserverController sliverObserver =
        SliverObserverController(controller: _scrollCustomController);
BuildContext? _contextSliverList;
BuildContext? _contextSliverGrid;
 PausableTimer timer = PausableTimer(const Duration(milliseconds: 600), () {
      showFloatingButton.value = true;
    });

useEffect(() {
     
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          PhotoManager.addChangeCallback(handleNotifierAssets);
          PhotoManager.startChangeNotify();

          _scrollCustomController.position.isScrollingNotifier.addListener(() {
          
            if (_scrollCustomController.position.pixels < 50) {
              showFloatingButton.value = false;
              timer.pause();
            }

            r
            if (!_scrollCustomController.position.isScrollingNotifier.value &&
                _scrollCustomController.position.pixels > 30) {
              timer.isExpired ? timer.reset() : timer.start();
            }
          });
        },
      );


CustomScaffold(
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
```

#
- Para scrollar dentro de um ListViewBuilder e mais simples
- Criio o _scrollControllerList e coloco no controller do ListViewBuilder, para evitar bounce na animcao tenho que usar o ClampingScrollPhysics
- Para navegar simplesemtne uso um calculo ele pede o Offeset no caso sera o index * largura do item no meu caso era 120
- Para realizar uma lista horizontal dentro do custommScrollView tenho que usra ListViewBuilder com SliverToBoxAdapter, para nao quebrar arvore preciso determinar o tamnho do componente

```dart
final ScrollController _scrollControllerList = ScrollController();

SliverToBoxAdapter(
                  child: SizedBox(
                    height: 50, 
                    child: ListView.builder(
                        physics:
                            const ClampingScrollPhysics(), //para evitar o bounce na aniamacao
                        scrollDirection: Axis.horizontal,
                        itemCount: optionsTripPlan.length,
                        controller: _scrollControllerList,
                        itemBuilder: ((context, index) {
                          _contextSliverList ??=
                              context; 

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


```

##

- Abrir as configuracoes do celular no IOS e Androi pode usar o [open_settings_plus](https://pub.dev/packages/open_settings_plus ),pacote mais completo que encontrei para atender bem IOS e Android
- Pegar as fotos da galeria melhor pacote que atende bem IOS e Android  e o [photo_manager](https://pub.dev/packages/photo_manager)
- Dica quando ira cropar a imagem evitar usar cover no resized  melhor contain
- Trabalhar com requisicoes em parelo melhor uso e com Future.wait, ira retornar um array melhor maneira que encontrei para lidar com erros e usar where e comparando se o data e null em qualquer uma dos retornos das requestes

```dart

//para abrir  as configuracoes
 switch (OpenSettingsPlus.shared) {
                              case OpenSettingsPlusAndroid settings:
                                settings.sendCustomMessage(
                                  'android.settings.APPLICATION_DETAILS_SETTINGS',
                                );
                              case OpenSettingsPlusIOS settings:
                                settings.appSettings();
                            }
                            Future.delayed(const Duration(seconds: 2), () {
                              Navigator.of(context).push(SplashScreen.route());
                            });
                          },



//requisicao paralelo
 await Future.wait([
          serviceFutureWeather.fetchForecastWeather(
              city: state.destiny, date: dateApiWhenStartTravel),
          ...listDate.map((it) => serviceFutureWeather.fetchForecastWeather(
              city: state.destiny, date: formatDateApi.format(it)))
        ]);


//comparando o erro


final fetchTemperatureState = await handleListFuturesWeather();
final lengthsErros = fetchTemperatureState.where((element) => element.data == null);


```

##

- Operacoes com datas que facilitaram o processo desenvolvimento.
- Comparar se as datas sao iguais pode usar isAtSameMomentAs, possivelmente se reotnar falso mesmo sendo mesmo dia poderia ser a diferenca de horas
- Comparar a diferncas entre os dias pode usar difference foi util no meu caso porque precisa saber se esta menor que 14 dias
- Existem outros classicos como isAfter and isBefore que sao pare comparar se sao antes ou depois da data comparada
- Trabalhr com calendario useu [syncfution_flutter_calendar](https://pub.dev/packages/syncfusion_flutter_calendar)
- Abrir uma url externa pode usar [liinkify](https://pub.dev/packages/flutter_linkify) com [url_lancher]([https://pub.dev/packages/flutter_linkify](https://pub.dev/packages/url_launcher)
- Compartilhar com apps externos usei o [share_plus](https://pub.dev/packages/share_plus)


```dart

if (!isDateStart && details.date.isBefore(handleMinDate())) {
        return Container(
            width: 25,
            height: 25,
            alignment: Alignment.center,
            child: Text(
              details.date.day.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  fontSize: 15,
                  fontWeight: FontWeight.w300),
            ));


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

```

##

- Para usar um gradiente no background do Scaffold criei um customizado

```dart
const gradientBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [
      0,
      0.4,
      1
    ], //tipo opacidade das cores
    colors: [
      Color(0xFF150B0A),
      Color(0xFF1D120E),
      Color(0xFF433613),
    ]);


class CustomScaffold extends HookWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final bool? extendBodyBehindAppBar;
  final bool? resizeToAvoidBottomInset;
  const CustomScaffold(
      {super.key,
      required this.body,
      this.floatingActionButton,
      this.extendBodyBehindAppBar,
      this.resizeToAvoidBottomInset,
      this.appBar}); // and maybe other Scaffold properties

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      floatingActionButton: floatingActionButton,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBodyBehindAppBar: extendBodyBehindAppBar ?? false,
      body: Container(
          decoration: const BoxDecoration(gradient: gradientBackground),
          child: body),
    );
  }
}

//uso

CustomScaffold(
body: content

)


```
##
- Quando trabalho com servicos externos gosto de crair uma classe BaseClientServiice nela que configo o Dio


```dart

//interface
import 'package:make_your_travel/data/data_or_expection.dart';
import 'package:make_your_travel/models/weather/weather_model.dart';

abstract class IForecastWeather {
  Future<DataOrException<ForecastWeather>> fetchFutureForecastWeather(
      {required String date, required String city});

  Future<DataOrException<ForecastWeather>> fetchForecastWeather(
      {required String city, required String date});
}


//base_clent
import 'package:dio/dio.dart';

abstract class BaseClientService {
  Dio customDio() {
    Dio dio = Dio();
    dio.options = BaseOptions(
        baseUrl: 'http://api.weatherapi.com/v1',
        connectTimeout: const Duration(seconds: 36000),
        receiveTimeout: const Duration(seconds: 36000));
    return dio;
  }
}


//servico
import 'package:make_your_travel/client/base_client.dart';
import 'package:make_your_travel/client/interfaces/i_future_weather.dart';
import 'package:make_your_travel/data/data_or_expection.dart';
import 'package:make_your_travel/models/weather/weather_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:make_your_travel/old_chat/utils/constants_environment.dart';

class ForecastWeatherService extends BaseClientService
    implements IForecastWeather {
  @override
  Future<DataOrException<ForecastWeather>> fetchFutureForecastWeather(
      {required String date, required String city}) async {
    try {
      final apiKey = dotenv.env[environmentApiKeyWeather];
      final response = await customDio().get(
          "/future.json?key=$apiKey&q=$city&dt=$date&lang=pt&hour=10&days=5");
      return DataOrException(
          data: ForecastWeather.fromJson(response.data),
          exception: null,
          isSuccess: true);
    } catch (e) {
      return DataOrException(
          data: null, exception: e.toString(), isSuccess: false);
    }
  }

  @override
  Future<DataOrException<ForecastWeather>> fetchForecastWeather(
      {required String city, required String date}) async {
    try {
      final apiKey = dotenv.env[environmentApiKeyWeather];
      final response = await customDio().get(
          "http://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$city&hour=10&lang=pt&dt=$date");
      return DataOrException(
          data: ForecastWeather.fromJson(response.data),
          exception: null,
          isSuccess: true);
    } catch (e) {
      return DataOrException(
          data: null, exception: e.toString(), isSuccess: false);
    }
  }
}


```


