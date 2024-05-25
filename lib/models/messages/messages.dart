import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'messages.freezed.dart';

@freezed
@immutable
class Message with _$Message {
  const factory Message({
    required String sendMessages,
    required String receiveMessages,
    required String id,
    required bool isLoadingResponse,
    File? file,
    String? heroAnimation,
  }) = _Messages;
}
