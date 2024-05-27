import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:make_your_travel/models/messages/messages.dart';
import 'package:make_your_travel/models/messages/messages_model.dart';
import 'package:make_your_travel/screens/home/widget/row_messages.dart';
import 'package:make_your_travel/screens/home/widget/show_gallery_camera.dart';
import 'package:make_your_travel/widget/common_text_field/common_text_field.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:super_sliver_list/super_sliver_list.dart';
import 'package:uuid/uuid.dart';

//https://labelbox.com/blog/how-to-leverage-googles-gemini-models-in-foundry-for-building-ai/
//https://ai.google.dev/examples?hl=pt-br
//Usar o Geolocator
class HomeScreen extends HookConsumerWidget {
  late CameraController _cameraController;
  final _listController = ListController();
  final _gemini = Gemini.instance;
  HomeScreen({super.key});

  static Route route() {
    return MaterialPageRoute(builder: (_) => HomeScreen());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //deixar todas variaveis possiveis fora do metodo build, so os hooks, exempo cameraController aqui sera sera rebuildado
    //dando nullo no final
    final focusTextMessage = useFocusNode();
    var imagesGallery = useState<List<File>>([]);
    var cameras = useState<List<CameraDescription>>([]);
    final userMessage = useState("");
    final List<Message> messages =
        ref.watch(messagesProvider); //essa sera todas nossas mensagens
    final useControllerMessage = useTextEditingController();
    final useControllerScrollMessage = useScrollController();
    final isLoadingResponseGemini = useState(false);
    final isLoadingAssets = useState(true);

    Future<bool> handleProcessPhoto() async {
      final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
          type: RequestType.image,
          filterOption: FilterOptionGroup(
              imageOption: const FilterOption(
                  needTitle: false,
                  sizeConstraint: SizeConstraint(ignoreSize: true))));
      for (var it in paths) {
        final countAssets = await it.assetCountAsync;
        if (countAssets < 1) return false;
        final listAssets =
            await it.getAssetListRange(start: 0, end: countAssets);

        for (var asset in listAssets) {
          final imageFile = await asset.file ?? File("");
          if (!imagesGallery.value.contains(imageFile)) {
            //transformar em uma classe que retorna
            imagesGallery.value = [...imagesGallery.value, imageFile];
          }
        }
      }
      return false;
    }

    useEffect(() {
      Future.delayed(Duration.zero, () async {
        final permissionPhoto = await PhotoManager.requestPermissionExtend();
        if (permissionPhoto.isAuth) {
          if (imagesGallery.value.isEmpty) {
            isLoadingAssets.value = await handleProcessPhoto();
          }
        }

        if (permissionPhoto.hasAccess) {
          PhotoManager.setIgnorePermissionCheck(true);
        }
      });
    }, const []);

    useEffect(() {
      Future.delayed(Duration.zero, () async {
        try {
          cameras.value = await availableCameras();

          if (cameras.value.isNotEmpty) {
            _cameraController = CameraController(
                cameras.value.last, ResolutionPreset.high,
                enableAudio: false);
            await _cameraController.initialize();
          }
        } catch (e) {
          print(e);
        }
      });
    }, [cameras]);

    return GestureDetector(
        onTap: () => focusTextMessage.unfocus(),
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              forceMaterialTransparency: true,
              toolbarHeight: 2,
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            body: SafeArea(
                top: false,
                left: false,
                right: false,
                bottom: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //depois tentar implementar o Sliver para melhorar a performance dessa lista
                    //tentar implementar o super_sliver_list
                    Expanded(
                        flex: 1,
                        child: SuperListView.builder(
                          padding: const EdgeInsets.all(0),
                          reverse: true,
                          controller: useControllerScrollMessage,
                          listController: _listController,
                          itemCount: messages.length,
                          itemBuilder: (context, index) =>
                              messages[index].heroAnimation != null
                                  ? Hero(
                                      tag: messages[index].heroAnimation!,
                                      child: RowMessages(
                                        messages: messages[index],
                                      ),
                                    )
                                  : RowMessages(
                                      messages: messages[index],
                                    ),
                        )),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                          width: double.infinity,
                          height: 90,
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: Theme.of(context).colorScheme.primary,
                                offset: const Offset(-1, 0),
                                blurRadius: 20,
                                spreadRadius: 0),
                          ]),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 13, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  showCupertinoModalBottomSheet<void>(
                                      backgroundColor: Colors.white,
                                      animationCurve: Curves.linear,
                                      bounce: false,
                                      elevation: 0,
                                      context: context,
                                      enableDrag: true,
                                      builder: (context) {
                                        return ShowGalleryCamera(
                                          imagesGallery: imagesGallery.value,
                                          cameras: cameras.value,
                                          cameraController: _cameraController,
                                        );
                                      });
                                },
                                child: imagesGallery.value.isNotEmpty &&
                                        !isLoadingAssets.value
                                    ? Image.asset(
                                        "assets/images/clip.png",
                                        width: 25,
                                        height: 25,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      )
                                    : const SizedBox(
                                        width: 25,
                                        height: 25,
                                      ),
                              ),
                              CommonTextField(
                                enabled: !isLoadingResponseGemini.value,
                                onChanged: (value) => userMessage.value = value,
                                focusNode: focusTextMessage,
                                controller: useControllerMessage,
                              ),
                              userMessage.value.isNotEmpty ||
                                      isLoadingResponseGemini.value
                                  ? InkWell(
                                      onTap: isLoadingResponseGemini.value
                                          ? null
                                          : () async {
                                              final id = Uuid().v4();
                                              try {
                                                isLoadingResponseGemini.value =
                                                    true;
                                                focusTextMessage.requestFocus();
                                                final Message currentMessage =
                                                    Message(
                                                        sendMessages:
                                                            userMessage.value,
                                                        receiveMessages: "",
                                                        id: id,
                                                        isLoadingResponse:
                                                            true);

                                                //automaticamente quando adiciono uma reflete a nossa variavel messages qeu esta com ref.watch(messagesModelProvider)
                                                ref
                                                    .read(messagesProvider
                                                        .notifier)
                                                    .addMessage(currentMessage);

                                                final responseModel =
                                                    await _gemini.text(
                                                        userMessage.value,
                                                        safetySettings: [
                                                      SafetySetting(
                                                          category:
                                                              SafetyCategory
                                                                  .dangerous,
                                                          threshold: SafetyThreshold
                                                              .blockLowAndAbove),
                                                      SafetySetting(
                                                          category: SafetyCategory
                                                              .sexuallyExplicit,
                                                          threshold: SafetyThreshold
                                                              .blockLowAndAbove),
                                                      SafetySetting(
                                                          category:
                                                              SafetyCategory
                                                                  .harassment,
                                                          threshold: SafetyThreshold
                                                              .blockLowAndAbove),
                                                    ]);

                                                if (responseModel != null) {
                                                  final Message newMessage =
                                                      Message(
                                                    sendMessages:
                                                        userMessage.value,
                                                    receiveMessages:
                                                        responseModel
                                                                .content
                                                                ?.parts
                                                                ?.last
                                                                .text ??
                                                            "",
                                                    id: id,
                                                    isLoadingResponse: false,
                                                  );
                                                  ref
                                                      .read(messagesProvider
                                                          .notifier)
                                                      .updateMessage(
                                                          newMessage);

                                                  _listController.animateToItem(
                                                    index: messages.length - 1,
                                                    scrollController:
                                                        useControllerScrollMessage,
                                                    alignment: 0.3,
                                                    duration: (_) =>
                                                        const Duration(
                                                            milliseconds: 250),
                                                    curve: (_) =>
                                                        Curves.easeInOut,
                                                  );
                                                  userMessage.value = "";
                                                  useControllerMessage.text =
                                                      "";
                                                  isLoadingResponseGemini
                                                      .value = false;
                                                }
                                              } catch (e) {
                                                print(e);
                                                isLoadingResponseGemini.value =
                                                    false;
                                                final Message newMessage =
                                                    Message(
                                                  sendMessages:
                                                      userMessage.value,
                                                  receiveMessages:
                                                      "Seja mais detalhistas nas perguntas.\nExemplo:\nQual melhor destino para Bahia?\nGere images de pássaros.\nTambém pode usar imagens do seu celular  para receber detalhes\n",
                                                  id: id,
                                                  isLoadingResponse: false,
                                                );

                                                ref
                                                    .read(messagesProvider
                                                        .notifier)
                                                    .updateMessage(newMessage);

                                                userMessage.value = "";
                                                useControllerMessage.text = "";
                                              }
                                            },
                                      child: isLoadingResponseGemini.value
                                          ? const SizedBox(
                                              width: 30,
                                              height: 30,
                                            )
                                          : Image.asset(
                                              "assets/images/send_message.png",
                                              width: 30,
                                              height: 30,
                                            ),
                                    )
                                  : Image.asset(
                                      "assets/images/microphone.png",
                                      width: 25,
                                      height: 25,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                            ],
                          )),
                    )
                  ],
                ))));
  }
}
