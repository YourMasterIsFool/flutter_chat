import 'package:flutter_chat/models/mesage_model.dart';
import 'package:flutter_chat/my_firebase.dart';

var message_col = firestore.collection('private_message');

class MessageService {
  send_message(MessageModel schema, String chat_uid) async {
    var snapshot = await message_col
        .doc(chat_uid)
        .collection('messages')
        .add(schema.toJson());

    return snapshot;
  }
}
