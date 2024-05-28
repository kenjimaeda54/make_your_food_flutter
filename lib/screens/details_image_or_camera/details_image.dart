import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:make_your_travel/models/messages/messages.dart';
import 'package:make_your_travel/models/messages/messages_model.dart';
import 'package:make_your_travel/screens/home/home.dart';
import 'package:make_your_travel/widget/common_text_field/common_text_field.dart';
import 'package:uuid/uuid.dart';

//hero animation
//https://api.flutter.dev/flutter/widgets/Hero-class.html
class DetailsImage extends HookConsumerWidget {
  final File image;
  final _gemini = Gemini.instance;

  DetailsImage({super.key, required this.image});

  static Route route({required File image}) {
    return MaterialPageRoute(
      builder: (_) => DetailsImage(image: image),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userMessage = useState("");
    // final isLoadingGemini = useState(false);

    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Theme.of(context).colorScheme.secondary,
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
                tag: image.path,
                child: Image.file(
                  image,
                  fit: BoxFit.contain,
                  gaplessPlayback: true,
                  filterQuality: FilterQuality.high,
                  cacheHeight: 2000,
                  cacheWidth: 2000,
                  height: double.infinity,
                  width: double.infinity,
                )),
            Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 30),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CommonTextField(
                      onChanged: (value) => userMessage.value = value,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () async {
                        final id = const Uuid().v4();
                        try {
                          final Message newMessage = Message(
                            sendMessages: userMessage.value,
                            receiveMessages: "",
                            id: id,
                            isLoadingResponse: true,
                            file: image,
                          );
                          ref
                              .read(messagesProvider.notifier)
                              .addMessage(newMessage);

                          if (context.mounted) {
                            Navigator.of(context).push(HomeScreen.route());
                          }

                          final responseModel = await _gemini.textAndImage(
                              images: [image.readAsBytesSync()],
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
                                  responseModel.content?.parts?.last.text ?? "",
                              id: id,
                              isLoadingResponse: false,
                              file: image,
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
            ),
          ],
        ));
  }
}
