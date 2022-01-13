class UserModel {
  String email;
  String password;
  String fullname;
  String? bio;
  List? groups = [];
  List? chats = [];
  UserModel(
      {required this.email,
      this.bio,
      required this.password,
      required this.fullname});

  toJson() {
    return {
      'email': this.email,
      'bio': this.bio ?? "",
      'fullname': this.fullname,
      'password': this.password,
      'chats': this.chats,
      'groups': this.groups
    };
  }
}
