class GroupModel {
  String hobby;
  String lokasi;
  DateTime createdAt;
  String owner_uid;
  List? members = [];
  String? last_message;
  String? group_description;
  DateTime? last_message_date;
  String? last_message_userId;

  GroupModel({
    required this.hobby,
    required this.lokasi,
    required this.createdAt,
    required this.owner_uid,
    this.members,
    this.group_description,
    this.last_message,
    this.last_message_date,
    this.last_message_userId,
  });

  toJson() {
    return {
      'hobby': this.hobby,
      'lokasi': this.lokasi,
      'group_description': this.group_description,
      'createdAt': this.createdAt,
      'owner_uid': this.owner_uid,
      'members': this.members,
      'last_message': this.last_message,
      'last_message_date': this.last_message_date,
      'last_message_userId': this.last_message_userId
    };
  }
}
