import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:make_your_travel/models/messages/messages.dart';
import 'package:make_your_travel/models/messages/messages_model.dart';
import 'package:make_your_travel/screens/home/home.dart';
import 'package:make_your_travel/widget/common_text_field/common_text_field.dart';
import 'package:uuid/uuid.dart';

class TakePhoto extends HookConsumerWidget {
  final _gemini = Gemini.instance;
  final CameraController cameraController;
  final List<CameraDescription> cameras;
  TakePhoto({super.key, required this.cameraController, required this.cameras});

  static Route route({
    required CameraController cameraController,
    required List<CameraDescription> cameras,
  }) {
    return MaterialPageRoute(
      builder: (_) => TakePhoto(
        cameraController: cameraController,
        cameras: cameras,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBackCameraDescription = useState(true);
    final isTurnOnFlash = useState(false);
    final pathAssetImage = useState("assets/images/flash_on.png");
    final image = useState<File?>(null);
    final userMessage = useState("");

    return Scaffold(
      appBar: CupertinoNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        trailing: IconButton(
            onPressed: () {
              isTurnOnFlash.value = !isTurnOnFlash.value;
              isTurnOnFlash.value
                  ? cameraController.setFlashMode(FlashMode.always)
                  : cameraController.setFlashMode(FlashMode.off);
              final currentPath = isTurnOnFlash.value
                  ? "assets/images/flash_off.png"
                  : "assets/images/flash_on.png";
              pathAssetImage.value = currentPath;
            },
            icon: Image.asset(
              pathAssetImage.value,
              width: 30,
              height: 30,
            )),
      ),
      body: Stack(
        children: [
          image.value != null
              ? Hero(
                  tag: cameraController.description.name,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        image: DecorationImage(
                            image: FileImage(File(image.value!.path)),
                            fit: BoxFit.contain)),
                  ),
                )
              : Hero(
                  tag: cameraController.description.name,
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: CameraPreview(cameraController),
                  )),
          image.value != null
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: double.infinity,
                    height: 150,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            try {
                              final croppedFile =
                                  await ImageCropper().cropImage(
                                sourcePath: image.value!.path,
                              );

                              image.value = File(croppedFile!.path);
                            } catch (e) {
                              print(e);
                            }
                          },
                          child: Image.asset(
                            "assets/images/trim.png",
                            width: 35,
                            height: 35,
                          ),
                        ),
                        CommonTextField(
                          onChanged: (value) => userMessage.value = value,
                        ),
                        GestureDetector(
                          onTap: () async {
                            final id = const Uuid().v4();
                            try {
                              if (image.value == null) return;
                              final Message newMessage = Message(
                                sendMessages: userMessage.value,
                                receiveMessages: "",
                                id: id,
                                isLoadingResponse: true,
                                file: image.value,
                              );
                              ref
                                  .read(messagesProvider.notifier)
                                  .addMessage(newMessage);
                              if (context.mounted) {
                                Navigator.of(context).push(HomeScreen.route());
                              }

                              final responseModel = await _gemini.textAndImage(
                                  images: [image.value!.readAsBytesSync()],
                                  text: userMessage.value,
                                  safetySettings: [
                                    SafetySetting(
                                        category: SafetyCategory.dangerous,
                                        threshold:
                                            SafetyThreshold.blockLowAndAbove),
                                    SafetySetting(
                                        category:
                                            SafetyCategory.sexuallyExplicit,
                                        threshold:
                                            SafetyThreshold.blockLowAndAbove),
                                    SafetySetting(
                                        category: SafetyCategory.harassment,
                                        threshold:
                                            SafetyThreshold.blockLowAndAbove),
                                  ]);

                              if (responseModel != null) {
                                final Message newMessage = Message(
                                  sendMessages: userMessage.value,
                                  receiveMessages:
                                      responseModel.content?.parts?.last.text ??
                                          "",
                                  id: id,
                                  isLoadingResponse: false,
                                  file: image.value,
                                );
                                ref
                                    .read(messagesProvider.notifier)
                                    .updateMessage(newMessage);
                              }
                            } catch (e) {
                              final Message newMessage = Message(
                                sendMessages: userMessage.value,
                                receiveMessages:
                                    "Seja mais detalhistas nas perguntas.\nExemplo:\nQual melhor destino para Bahia?\nCuriosidades de um destino.\nTambém pode usar imagens do seu celular  para receber detalhes\n.Tome cuidado com erros de portugues",
                                id: id,
                                isLoadingResponse: false,
                              );

                              ref
                                  .read(messagesProvider.notifier)
                                  .addMessage(newMessage);
                            }
                          },
                          child: Image.asset(
                            "assets/images/send_message.png",
                            width: 35,
                            height: 35,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        color: Theme.of(context).colorScheme.secondary),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Image.asset(
                                "assets/images/close.png",
                                width: 45,
                                height: 45,
                              )),
                          GestureDetector(
                            onTap: () async {
                              try {
                                final xFile =
                                    await cameraController.takePicture();
                                image.value = File(xFile.path);
                              } catch (e) {
                                print(e);
                              }
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).colorScheme.primary),
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                isBackCameraDescription.value =
                                    !isBackCameraDescription.value;

                                final frontCamera = cameras.firstWhere(
                                    (description) =>
                                        description.lensDirection ==
                                        CameraLensDirection.front);
                                final backCamera = cameras.firstWhere(
                                    (description) =>
                                        description.lensDirection ==
                                        CameraLensDirection.back);

                                final currentCamera =
                                    isBackCameraDescription.value
                                        ? backCamera
                                        : frontCamera;
                                cameraController.setDescription(currentCamera);
                              },
                              child: Image.asset(
                                "assets/images/turn.png",
                                width: 40,
                                height: 40,
                              )),
                        ],
                      ),
                    ),
                  ),
                )
        ],
      ),
    );
  }
}
