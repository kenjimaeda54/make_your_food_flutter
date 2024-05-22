import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RowMessages extends HookWidget {
  final String sendMessages;
  final String receiveMessages;
  const RowMessages(
      {super.key, required this.receiveMessages, required this.sendMessages});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _handleContainerMessages(context, receiveMessages, true),
          _handleContainerMessages(context, sendMessages, false),
        ],
      ),
    );
  }
}

Widget _handleContainerMessages(
    BuildContext context, String message, bool isUser) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 30),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
            padding: const EdgeInsets.only(top: 30, right: 10),
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
        Expanded(
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
      ],
    ),
  );
}
