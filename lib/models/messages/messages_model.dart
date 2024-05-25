import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:make_your_travel/models/messages/messages.dart';

class MessagesModel extends StateNotifier<List<Message>> {
  MessagesModel() : super([]);

  void addMessage(Message message) {
    state = [message, ...state];
  }

  void updateMessage(Message message) {
    state = state.map((oldMessage) {
      if (oldMessage.id == message.id) {
        return message;
      }
      return oldMessage;
    }).toList();
  }
}

final messagesProvider =
    StateNotifierProvider<MessagesModel, List<Message>>((_) => MessagesModel());
