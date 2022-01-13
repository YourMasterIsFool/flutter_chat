import 'package:flutter_chat/models/mesage_model.dart';
import 'package:flutter_chat/my_firebase.dart';

var group_chat_col = firestore.collection('group_message');

class GroupChatService {
  add_message(MessageModel messageModel, String group_uid) {
    var snapshot = group_chat_col
        .doc(group_uid)
        .collection('messages')
        .add(messageModel.toJson());

    return snapshot;
  }
}
