import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:make_your_travel/models/messages/messages.dart';
import 'package:rive/rive.dart';

class RowMessages extends HookWidget {
  final Message messages;
  const RowMessages({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _handleContainerMessages(context, messages.sendMessages, true,
              messages.isLoadingResponse, messages.file),
          _handleContainerMessages(context, messages.receiveMessages, false,
              messages.isLoadingResponse, messages.file)
        ],
      ),
    );
  }
}

Widget _handleContainerMessages(BuildContext context, String message,
    bool isUser, bool isLoadingResponse, File? file) {
  Widget widgetMessage() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Align(
        alignment: Alignment.topLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 13,
            vertical: 7,
          ),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(3),
                  bottomRight: Radius.circular(20))),
          child: Text(
            message,
            style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w300,
                fontSize: 15),
          ),
        ),
      ),
    );
  }

  final Widget returnResponseTypeView = GeminiResponseTypeView(
    builder: (context, child, response, loading) {
      if (response != null || !isLoadingResponse || isUser) {
        return file == null
            ? widgetMessage()
            : isUser
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 3, vertical: 5),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomLeft: Radius.circular(1),
                              bottomRight: Radius.circular(20))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(file.path),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 300,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 13,
                              vertical: 7,
                            ),
                            child: Text(
                              message,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : message.isEmpty
                    ? SizedBox(
                        height: 30,
                        width: 100,
                        child: RiveAnimation.asset(
                          "assets/rive/gemini_rive.riv",
                          artboard: "Write Loading",
                          fit: BoxFit.fitWidth,
                          controllers: [OneShotAnimation("Loop")],
                          stateMachines: ['State'],
                        ),
                      )
                    : widgetMessage();
      }
      return Align(
        alignment: Alignment.topLeft,
        child: SizedBox(
          height: 30,
          width: 100,
          child: RiveAnimation.asset(
            "assets/rive/gemini_rive.riv",
            artboard: "Write Loading",
            fit: BoxFit.fitWidth,
            controllers: [OneShotAnimation("Loop")],
            stateMachines: ['State'],
          ),
        ),
      );
    },
  );

  return Padding(
    padding: const EdgeInsets.only(bottom: 30),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 35, right: 10),
            child: Container(
              width: 35,
              height: 35,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: isUser
                        ? const AssetImage("assets/images/avatar_one.jpg")
                        : const AssetImage("assets/images/gemini.png")),
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.secondary,
              ),
            )),
        Expanded(flex: 1, child: returnResponseTypeView)
      ],
    ),
  );
}
