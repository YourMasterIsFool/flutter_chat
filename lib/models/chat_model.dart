class ChatModel {
  final List? members;
  final String? last_message;
  final DateTime? last_message_date;
  final String? last_message_userID;
  final bool? has_chat;

  ChatModel(
      {this.members,
      this.has_chat,
      this.last_message,
      this.last_message_date,
      this.last_message_userID});

  toJson() {
    return {
      'members': this.members,
      'has_chat': this.has_chat,
      'last_message': this.last_message,
      'last_message_date': this.last_message_date,
      'last_message_userID': this.last_message_userID
    };
  }
}
