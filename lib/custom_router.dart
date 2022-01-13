import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chat/screens/new_chat/new_chat_screen.dart';
import 'package:flutter_chat/screens/search_group/search_group_screen.dart';
import './screens/base_screen.dart';
import './screens/chat/private_chat/private_message_screen.dart';
import './screens/chat/group_chat/group_message_screen.dart';
import './screens/person_profile/person_profile_screen.dart';
import './screens/group_profile/group_profile_screen.dart';
import './screens/login/login_screen.dart';
import './screens/signup/signup_screen.dart';

const String signupRoute = '/signup';
const String loginRoute = '/login';
const String homeRoute = '/';
const String privateMessage = '/private_message';
const String personProfile = '/person_profile';
const String groupMessage = '/group_message';
const String groupProfile = '/group_profile';
const String newChat = '/new_chat';
const String searchGroup = '/search_group';

class CustomRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        return CupertinoPageRoute(builder: (context) => BaseScreen());

      case privateMessage:
        var args = settings.arguments as Map<String, dynamic>;
        return CupertinoPageRoute(
            builder: (context) => PrivateMessageScreen(
                  chat_uid: args['chat_uid'],
                  partner_uid: args['partner_uid'],
                ));

      case personProfile:
        var args = settings.arguments as Map<String, dynamic>;
        return CupertinoPageRoute(
            builder: (context) => PersonProfileScreen(
                  partner_uid: args['partner_uid'],
                ));

      case groupMessage:
        var args = settings.arguments as Map<String, dynamic>;
        print(args['group_uid']);
        return CupertinoPageRoute(
            builder: (context) => GroupMessageScreen(
                  group_uid: args['group_uid'],
                ));

      case groupProfile:
        var args = settings.arguments as Map<String, dynamic>;

        return CupertinoPageRoute(
            builder: (context) => GroupProfileScreen(
                  group_uid: args['group_uid'],
                ));
      case newChat:
        return CupertinoPageRoute(builder: (context) => NewChatScreen());

      case loginRoute:
        return CupertinoPageRoute(builder: (context) => LoginScreen());
      case signupRoute:
        return CupertinoPageRoute(builder: (context) => SignUpScreen());
      case searchGroup:
        return CupertinoPageRoute(builder: (context) => SearchGroupScreen());

      default:
        return CupertinoPageRoute(
            builder: (context) =>
                Scaffold(body: Center(child: Text("No Page"))));
    }
  }
}
