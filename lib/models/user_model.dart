class UserModel {
  String email;
  String password;
  String fullname;
  String? bio;
  List? groups = [];
  List? chats = [];
  List? friends = [];
  String? answer;
  String? question;
  UserModel(
      {required this.email,
        this.friends,
      this.bio,
      required this.password,
      this.answer,
      required this.question,
      required this.fullname});

  toJson() {
    return {
      'email': this.email,
      'friends': this.friends ?? [],
      'bio': this.bio ?? "",
      'fullname': this.fullname,
      'password': this.password,
      'chats': this.chats,
      'groups': this.groups,
      "question": this.question,
      "answer": this.answer ?? "",

    };
  }
}
