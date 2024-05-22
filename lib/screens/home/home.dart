import 'dart:math';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:make_your_travel/constants/constants_environment.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:make_your_travel/screens/home/widget/row_messages.dart';
import 'package:make_your_travel/screens/home/widget/show_gallery_camera.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:photo_manager/photo_manager.dart';

typedef Messages = ({String sendMessages, String receiveMessages});

class HomeScreen extends HookWidget {
  late CameraController _cameraController;
  final _gemini = Gemini.instance;
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //deixar todas variaveis possiveis fora do metodo build, so os hooks, exempo cameraController aqui sera sera rebuildado
    //dando nullo no final
    final focusTextMessage = useFocusNode();
    var imagesGallery = useState<List<AssetEntity>>([]);
    var cameras = useState<List<CameraDescription>>([]);
    final userMessage = useState("");
    final messages = useState<List<Messages>>([]);
    final useControllerMessage = useTextEditingController();
    final useControllerScrollMessage = useScrollController();

    useEffect(() {
      Future.delayed(Duration.zero, () async {
        final permissionPhoto = await PhotoManager.requestPermissionExtend();
        if (permissionPhoto.isAuth) {
          final List<AssetPathEntity> paths =
              await PhotoManager.getAssetPathList(
            type: RequestType.image,
          );

          for (var it in paths) {
            final countAssets = await it.assetCountAsync;
            final listAssets =
                await it.getAssetListRange(start: 0, end: countAssets);

            for (var asset in listAssets) {
              if (!imagesGallery.value.contains(asset)) {
                imagesGallery.value = [...imagesGallery.value, asset];
              }
            }
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
                    Expanded(
                        flex: 1,
                        child: ListView.builder(
                            padding: EdgeInsets.all(0),
                            reverse: true,
                            controller: useControllerScrollMessage,
                            itemCount: messages.value.length,
                            itemBuilder: (context, index) => RowMessages(
                                receiveMessages:
                                    messages.value[index].receiveMessages,
                                sendMessages:
                                    messages.value[index].sendMessages))),
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
                                child: imagesGallery.value.isNotEmpty
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
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.75,
                                child: TextField(
                                  onChanged: (value) =>
                                      userMessage.value = value,
                                  focusNode: focusTextMessage,
                                  controller: useControllerMessage,
                                  // textInputAction: TextInputAction.done, //quando desejo que seja done
                                  maxLines: null,
                                  cursorColor:
                                      Theme.of(context).colorScheme.primary,
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 17),
                                  decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 20),
                                      hintText: "Message",
                                      hintStyle: TextStyle(
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.3),
                                          fontWeight: FontWeight.w300,
                                          fontSize: 17),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(40)),
                                      filled: true,
                                      fillColor: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                              ),
                              userMessage.value.isNotEmpty
                                  ? InkWell(
                                      onTap: () async {
                                        final responseModel = await _gemini
                                            .text(userMessage.value);
                                        if (responseModel != null) {
                                          final Messages currentMessage = (
                                            receiveMessages: userMessage.value,
                                            sendMessages: responseModel.content
                                                    ?.parts?.last.text ??
                                                ""
                                          );
                                          messages.value = [
                                            currentMessage,
                                            ...messages.value
                                          ];
                                          userMessage.value = "";
                                          useControllerMessage.text = "";
                                          useControllerScrollMessage.animateTo(
                                              useControllerScrollMessage
                                                  .position.minScrollExtent,
                                              duration:
                                                  const Duration(seconds: 2),
                                              curve: Curves.fastOutSlowIn);
                                        }
                                      },
                                      child: Image.asset(
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
