import 'package:flutter/material.dart';
import 'package:flutter_chat/models/mesage_model.dart';
import 'package:flutter_chat/my_firebase.dart';
import 'package:flutter_chat/preferences/user_pref.dart';
import 'package:flutter_chat/services/group_chat_service.dart';
import 'package:flutter_chat/utils/parse_date.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../styles.dart';

class GroupMessageScreen extends StatefulWidget {
  final String group_uid;

  GroupMessageScreen({required this.group_uid});
  @override
  _GroupMessageScreenState createState() => _GroupMessageScreenState();
}

class _GroupMessageScreenState extends State<GroupMessageScreen> {
  TextEditingController _messageController = new TextEditingController();

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
    get_user_id();
    _messageController = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void sendMessage() {
    GroupChatService groupChatService = new GroupChatService();
    MessageModel messageModel = new MessageModel(
        message: _messageController.text,
        sender_uid: user_id,
        message_date: DateTime.now());

    groupChatService.add_message(messageModel, widget.group_uid).then((resp) {
      setState(() {
        firestore.collection('groups').doc(widget.group_uid).update({
          'last_message': messageModel.message,
          'last_message_date': messageModel.message_date,
          'last_message_userID': messageModel.sender_uid
        });
        _messageController.clear();
      });
    });
  }

  void joinGroup() {
    firestore.collection('users').doc(user_id).update({
      'groups': FieldValue.arrayUnion([widget.group_uid])
    }).then((res) {});
    firestore.collection('groups').doc((widget.group_uid)).update({
      'members': FieldValue.arrayUnion([user_id])
    });
  }

  bgJoinButton(states) {
    if (states.contains(MaterialState.pressed)) {
      return Colors.grey.shade200;
    }

    return Colors.grey.shade300;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/group_profile',
                      arguments: {'group_uid': widget.group_uid});
                },
                child: Row(children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                          'https://media.istockphoto.com/photos/group-multiracial-people-having-fun-outdoor-happy-mixed-race-friends-picture-id1211345565?k=20&m=1211345565&s=612x612&w=0&h=Gg65DvzedP7YDo6XFbB-8-f7U7m5zHm1OPO3uIiVFgo=',
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover)),
                  SizedBox(width: 12),
                  StreamBuilder<dynamic>(
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var group = snapshot.data.data();
                        return Text("${group['hobby']} ${group['lokasi']}",
                            style: textTitle.copyWith(color: Colors.white));
                      }
                      return Container();
                    },
                    stream: firestore
                        .collection('groups')
                        .doc(widget.group_uid)
                        .snapshots(),
                  )
                ]))),
        body: Column(children: [
          Expanded(
              child: Padding(
                  padding:
                      EdgeInsets.only(top: 8, bottom: 10, left: 8, right: 8),
                  child: StreamBuilder<dynamic>(
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var messages = snapshot.data.docs;
                        print(messages.length);
                        print(widget.group_uid);
                        return ListView.builder(
                            reverse: true,
                            itemBuilder: (context, index) {
                              print(messages[index]['message_date']);
                              return _message(
                                  context,
                                  messages[index]['message'],
                                  messages[index]['sender_uid'],
                                  messages[index]['message_date']);
                            },
                            itemCount: messages.length);
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          color: kPrimaryColor,
                          strokeWidth: 2,
                        ),
                      );
                    },
                    stream: firestore
                        .collection('group_message')
                        .doc(widget.group_uid)
                        .collection('messages')
                        .orderBy('message_date', descending: true)
                        .snapshots(),
                  ))),
          Container(
              width: double.infinity,
              height: 56,
              padding: EdgeInsets.all(12),
              child: StreamBuilder<dynamic>(
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List members = snapshot.data.data()['members'];

                    var join_members = members.contains(user_id);
                    if (join_members) {
                      return Row(children: [
                        // Text(
                        //   "${_messageController.text}",
                        // ),

                        Expanded(
                            child: TextField(
                                onChanged: (value) {
                                  // setState(() {
                                  //   _messageController.text = value;
                                  // });
                                },
                                controller: _messageController,
                                style: textSubtitle.copyWith(
                                    color: kPrimaryColor, fontSize: 16),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Kirim Pesan",
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 4.0),
                                ))),
                        SizedBox(
                          width: 4.0,
                        ),
                        IconButton(
                            icon: Icon(Icons.send, color: kPrimaryColor),
                            onPressed: () => sendMessage())
                      ]);
                    } else {
                      return Row(children: [
                        Expanded(
                            child: Container(
                                height: 100,
                                child: ElevatedButton(
                                  style: ButtonStyle(backgroundColor:
                                      MaterialStateProperty.resolveWith(
                                          (states) {
                                    if (states
                                        .contains(MaterialState.pressed)) {
                                      return Colors.grey.shade100;
                                    }
                                    return Colors.grey.shade200;
                                  })),
                                  child: Text(
                                    "Join",
                                    style: textSubtitle.copyWith(
                                        color: kPrimaryColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  onPressed: () => joinGroup(),
                                )))
                      ]);
                    }
                  }
                  return Container();
                },
                stream: firestore
                    .collection('groups')
                    .doc(widget.group_uid)
                    .snapshots(),
              ))
        ]));
  }

  Widget _message(BuildContext context, String message, String sender_uid,
      dynamic message_date) {
    print(sender_uid);
    return Padding(
      padding: EdgeInsets.only(top: sender_uid == user_id ? 4.0 : 16.0),
      child: Row(
          mainAxisAlignment: user_id == sender_uid
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/person_profile",
                      arguments: {'partner_uid': sender_uid});
                },
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: sender_uid == user_id
                        ? null
                        : Image.network(
                            'https://media.istockphoto.com/photos/group-multiracial-people-having-fun-outdoor-happy-mixed-race-friends-picture-id1211345565?k=20&m=1211345565&s=612x612&w=0&h=Gg65DvzedP7YDo6XFbB-8-f7U7m5zHm1OPO3uIiVFgo=',
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover))),
            SizedBox(
              width: 12,
            ),
            Container(
                width: 300,
                decoration: BoxDecoration(
                  color: user_id == sender_uid
                      ? kPrimaryColor
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StreamBuilder<dynamic>(
                        builder: (context, snapshot) {
                          var partner = snapshot.data?.data();
                          if (snapshot.hasData) {
                            return user_id != sender_uid
                                ? Text("${partner['fullname']}",
                                    style: textTitle.copyWith(
                                        color: user_id == sender_uid
                                            ? Colors.transparent
                                            : kPrimaryColor,
                                        fontWeight: FontWeight.w800))
                                : SizedBox(
                                    height: 0,
                                  );
                          }
                          return Container();
                        },
                        stream: firestore
                            .collection('users')
                            .doc(sender_uid)
                            .snapshots(),
                      ),
                      SizedBox(
                        height: sender_uid == user_id ? 0 : 6.0,
                      ),

                      Text("${message}",
                          style: textTitle.copyWith(
                              color: user_id == sender_uid
                                  ? Colors.white
                                  : Colors.black)),
                      SizedBox(
                        height: 4.0,
                      ),

                      // for date
                      Row(
                          mainAxisAlignment: user_id == sender_uid
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Text("${chatDate(message_date.seconds)}",
                                style: textSubtitle.copyWith(
                                    fontSize: 11,
                                    color: user_id == sender_uid
                                        ? Colors.grey.shade400
                                        : Colors.grey.shade700))
                          ])
                    ])),
          ]),
    );
  }
}
