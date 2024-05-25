import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:make_your_travel/models/messages/messages.dart';
import 'package:make_your_travel/models/messages/messages_model.dart';
import 'package:make_your_travel/providers/image_hero_animation.dart';
import 'package:make_your_travel/screens/home/home.dart';
import 'package:make_your_travel/widget/common_text_field/common_text_field.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:uuid/uuid.dart';

//hero animation
//https://api.flutter.dev/flutter/widgets/Hero-class.html
class DetailsImage extends HookConsumerWidget {
  final AssetEntity image;
  final _gemini = Gemini.instance;
  DetailsImage({super.key, required this.image});

  static Route route({required AssetEntity image}) {
    return MaterialPageRoute(builder: (_) => DetailsImage(image: image));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMessage = useState("");
    final isLoadingGemini = useState(false);

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        body: Stack(
          children: [
            Hero(
              tag: ref.read(imageHeroAnimation),
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: AssetEntityImage(
                  image,
                  thumbnailSize: const ThumbnailSize.square(200),
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 30),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Visibility(
                      visible: !isLoadingGemini.value,
                      child: CommonTextField(
                        onChanged: (value) => userMessage.value = value,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                        onTap: () async {
                          final id = Uuid().v4();
                          try {
                            final file = await image.file;
                            isLoadingGemini.value = true;

                            if (file == null) return;
                            final Message newMessage = Message(
                                sendMessages: userMessage.value,
                                receiveMessages: "",
                                id: id,
                                isLoadingResponse: true,
                                file: file,
                                heroAnimation: ref.read(imageHeroAnimation));
                            ref
                                .read(messagesProvider.notifier)
                                .addMessage(newMessage);
                            if (context.mounted) {
                              Navigator.of(context).push(HomeScreen.route());
                            }
                            final responseModel = await _gemini.textAndImage(
                                images: [file.readAsBytesSync()],
                                text: userMessage.value,
                                safetySettings: [
                                  SafetySetting(
                                      category: SafetyCategory.dangerous,
                                      threshold:
                                          SafetyThreshold.blockLowAndAbove),
                                  SafetySetting(
                                      category: SafetyCategory.sexuallyExplicit,
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
                                  file: file,
                                  heroAnimation: ref.read(imageHeroAnimation));
                              ref
                                  .read(messagesProvider.notifier)
                                  .updateMessage(newMessage);
                            }
                          } catch (e) {
                            final Message newMessage = Message(
                                sendMessages: userMessage.value,
                                receiveMessages:
                                    "Seja mais detalhistas nas perguntas.\nExemplo:\nQual melhor destino para Bahia?\nGere images de pássaros.\nTambém pode usar imagens do seu celular  para receber detalhes\n",
                                id: id,
                                isLoadingResponse: false,
                                heroAnimation: ref.read(imageHeroAnimation));

                            ref
                                .read(messagesProvider.notifier)
                                .addMessage(newMessage);
                            EasyLoading.dismiss();
                          }
                        },
                        child: Visibility(
                          visible: !isLoadingGemini.value,
                          child: Image.asset(
                            "assets/images/send_message.png",
                            width: 35,
                            height: 35,
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
