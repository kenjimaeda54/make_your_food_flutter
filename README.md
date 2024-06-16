# Make Your Travel

Aplicativo para criar um roteiro para suas próximas viagens, possível: pesquisar viagens a partir de fotos da sua galeria, fotos retiradas no momento pela câmera, sugestões que são viagens pré-definidas ou pesquisar por campos livres.


## Funcionalidades
- Para  usar este repositório, precisa da chave key do [Gemini](https://ai.google.dev/) e da [API de tempo](https://www.weatherapi.com, consultar o arquivo .env.example
- Para lidar com datas e mensagens no aplicativo na língua em portuguesa usei o recurso de locationsDelegates

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

- Para converter imagens do assets em  file pode seguir o algorítimo abaixo.
- Path precisa ser o caminho completo de onde está o assets no meu exemplo, assets/images/estados_unidos.png, para gerar o file preciso pegar o arquivo temporário usando uma função pré-definida do   [Path Provider](https://pub.dev/packages/path_provider) e usar o nome da imagem, no caso estados_unidos.png

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

- Para lidar com scroll usando Sliver usei [Scroll View Observer](https://pub.dev/packages/scrollview_observer) 
- [Consulta interessante para entender observer scroll])(https://github.com/fluttercandies/flutter_scrollview_observer/wiki/2%E3%80%81Scrolling-to-the-specified-index-location)
- [Consulta interessante para entender observer scroll)(https://medium.com/@linxunfeng/flutter-scrolling-to-a-specific-item-in-the-scrollview-b89d3f10eee0(
- Repara que envolvi o CustomScrollView em volta do SliverViewObserver e usei o _scrollCustomController no controller
- Também preciso referenciar os contextos para saber aonde irei scrollar
- Para realizar ação de scroll usei o floatingButton ele surge após o usuário scrollar alguns píxel, para ir até um index específico uso o  sliverObserver.innerAnimateTo apontando o index e o contexto.
- Botao irá aparecer apenas após 600 microssegundos após iniciar o scroll, para criar esta   lógica usei o [pausable_timer](https://pub.dev/packages/pausable_timer)
- Repara que, após maior que 30 píxel, irei fazer com que o timer seja iniciado. Caso ele esteja expirado, será o restado dentro do useffect e quando a posição for menor que 50, irei pausar o timer e esconder o botão.

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
              const ClampingScrollPhysics(), 
          slivers: [
            SliverPadding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 30,
                    left: 13,
                    right: 0),
                sliver: SliverToBoxAdapter(
                  child: SizedBox(
                    height: 50, 
                    child: ListView.builder(
                        physics:
                            const ClampingScrollPhysics(), 
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

##

- Para scrollar num ListViewBuilder é mais simples.
- Crio o _scrollControllerList e coloco  controller do ListViewBuilder, para evitar bounce na animação tenho que usar o ClampingScrollPhysics, isto vale tanto para ListViewBuilder como CusotmScrollView
- Para scrollar simplesmente, uso um cálculo no parâmetro Offeset no caso será o index * largura do item, no meu caso era 120.
- Para realizar uma lista horizontal dentro do CustommScrollView tenho que usar ListViewBuilder com SliverToBoxAdapter, para não quebrar árvore, preciso determinar o tamanho do componente.

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

- Abrir as configurações do celular no IOS e Androi pode usar o [open_settings_plus](https://pub.dev/packages/open_settings_plus ), pacote mais completo que encontrei para atender bem IOS e Android
- Pegar as fotos da galeria, melhor pacote que atende IOS é Android e o [photo_manager](https://pub.dev/packages/photo_manager)
- Dica quando ira cortar a imagem: evitar usar cover no resize melhor contain
- Trabalhar com requisições em paralelo, usei Future.wait, irá retornar um array, a melhor maneira que encontrei para lidar com erros e usar where e comparando se o data e null em qualquer uma dos retornos das requisições.

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


- Operações com datas que facilitaram o processo de desenvolvimento.
- Comparar se as datas são iguais pode usar isAtSameMomentAs, possivelmente se retornar falso, sendo que mesmo o dia, poderá ser a diferença de horas.
- Comparar as diferenças entre os dias pode usar difference. Foi útil no meu caso porque preciso saber se está menor que 14 dias.
- Existem outros clássicos como isAfter  e  isBefore que servem para comparar se antes ou depois da data comparada.
- Trabalhar com calendário, usei o [syncfution_flutter_calendar](https://pub.dev/packages/syncfusion_flutter_calendar)
- Abrir uma URL externa pode usar [liinkify](https://pub.dev/packages/flutter_linkify) com [url_lancher]([https://pub.dev/packages/flutter_linkify](https://pub.dev/packages/url_launcher)
- Compartilhar com aplicativos externos usei o [share_plus](https://pub.dev/packages/share_plus)


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

- Quando trabalho com serviços externos, gosto de criar uma classe BaseClientServiice nela que configuro o Dio

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


//serviço
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


