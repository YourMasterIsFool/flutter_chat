class MessageModel {
  final String message;
  final String sender_uid;
  final DateTime message_date;

  MessageModel(
      {required this.message,
      required this.sender_uid,
      required this.message_date});

  toJson() {
    return {
      'message': this.message,
      'sender_uid': this.sender_uid,
      'message_date': this.message_date
    };
  }
}
