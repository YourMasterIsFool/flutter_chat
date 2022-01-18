import 'package:flutter/material.dart';
import 'package:flutter_chat/my_firebase.dart';
import 'package:flutter_chat/preferences/user_pref.dart';
import 'package:flutter_chat/utils/parse_date.dart';
import '../../../styles.dart';
import 'package:basic_utils/basic_utils.dart';

class PrivateChatScreen extends StatefulWidget {
  @override
  _PrivateChatScreenState createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends State<PrivateChatScreen> {
  var user_id;

  Future<dynamic> get_user_id() async {
    await get_userId().then((data) {
      print(data);
      setState(() {
        user_id = data;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    get_user_id();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        child: StreamBuilder<dynamic>(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List chats = snapshot.data.data()['chats'] as List;
              print(chats);
              // return Text("${chats}");
              return ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    return _chat(context, "${chats[index]}");
                  });
            }

            return Text("${user_id}");
          },
          stream: firestore.collection('users').doc(user_id).snapshots(),
        ));
  }

  Widget _chat(BuildContext context, String chat_uid) {
    _photoProfile(String partner_uid) {
      return Padding(
          padding: EdgeInsets.only(right: 12.0),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                  'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cG9ydHJhaXR8ZW58MHx8MHx8&w=1000&q=80',
                  height: 64,
                  width: 64,
                  fit: BoxFit.cover)));
    }

    _descChat(String lastMessage, int lastMessageDate, String partner_uid) {
      return Expanded(
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              StreamBuilder<dynamic>(
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var partner = snapshot.data.data();
                    return Text(
                        "${StringUtils.capitalize(partner['fullname'])}",
                        style: textTitle.copyWith(
                            color: kPrimaryColor, fontWeight: FontWeight.w700));
                  }
                  return Container();
                },
                stream:
                    firestore.collection('users').doc(partner_uid).snapshots(),
              ),
              SizedBox(height: 4.0),
              Text('${lastMessage}',
                  style: textSubtitle.copyWith(
                      color: kPrimaryColor, fontWeight: FontWeight.w500)),
            ]),
            Text("${chatDate(lastMessageDate)}",
                style:
                    textSubtitle.copyWith(color: kPrimaryColor, fontSize: 11.0))
          ]));
    }

    _backgroundColor(states) {
      if (states.contains(MaterialState.pressed)) {
        return Colors.grey.shade300;
      }

      return Colors.white;
    }

    _unReadedBackground(states){
      if(states.contains(MaterialState.pressed)) {
        return Colors.blue.shade300;
      }

      return Colors.blue.shade100;
    } 

    return StreamBuilder<dynamic>(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data.data();
          List members_chat = data['members'];
          String partner_uid = members_chat.firstWhere((i) => i != user_id);
          return ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/private_message', arguments: {
                  'chat_uid': chat_uid,
                  'partner_uid': partner_uid
                });
              },
              style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor:
                      MaterialStateProperty.resolveWith(
                        data['last_message_userID'] == user_id ? _backgroundColor : _unReadedBackground
                      ),
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12.0))),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _photoProfile(partner_uid),
                    _descChat(data['last_message'],
                        data['last_message_date'].seconds, partner_uid),
                  ]));
        }
        return Container(
          child: Text("${chat_uid}"),
        );
      },
      stream: firestore.collection('chats').doc(chat_uid).snapshots(),
    );
  }
}
