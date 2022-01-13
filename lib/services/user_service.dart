import '../my_firebase.dart';

class UserService {
  var users = firestore.collection("users");

  create_user(user) async {
    var snapshot = await users.add(user);

    return snapshot;
  }

  login_user(user) async {
    var snapshot = await users
        .where('email', isEqualTo: user['email'])
        .where('password', isEqualTo: user['password'])
        .get();

    return snapshot;
  }
}
