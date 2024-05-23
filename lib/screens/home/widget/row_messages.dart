import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rive/rive.dart';

class RowMessages extends HookWidget {
  final String sendMessages;
  final String receiveMessages;
  final bool isLoadingResponse;
  const RowMessages(
      {super.key,
      required this.receiveMessages,
      required this.sendMessages,
      required this.isLoadingResponse});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _handleContainerMessages(
              context, sendMessages, true, isLoadingResponse),
          _handleContainerMessages(
              context, receiveMessages, false, isLoadingResponse),
        ],
      ),
    );
  }
}

Widget _handleContainerMessages(
    BuildContext context, String message, bool isUser, bool isLoadingResponse) {
  final Widget returnResponseTypeView = GeminiResponseTypeView(
    builder: (context, child, response, loading) {
      if (response != null || !isLoadingResponse || isUser) {
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
