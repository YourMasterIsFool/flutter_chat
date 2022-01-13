import 'package:flutter_chat/models/mesage_model.dart';
import 'package:flutter_chat/my_firebase.dart';

var chats_col = firestore.collection('chats');

class ChatService {
  updateLastMessage(MessageModel messageModel, bool has_chat, String chat_uid) {
    var snapshot = chats_col.doc(chat_uid).update({
      'last_message': messageModel.message,
      'has_chat': has_chat,
      'last_message_date': messageModel.message_date,
      'last_message_userID': messageModel.sender_uid
    });

    return snapshot;
  }
}
