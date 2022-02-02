import 'package:flutter/material.dart';
import 'package:flutter_chat/models/mesage_model.dart';
import 'package:flutter_chat/my_firebase.dart';
import 'package:flutter_chat/preferences/user_pref.dart';
import 'package:flutter_chat/services/chat_service.dart';
import 'package:flutter_chat/services/message_service.dart';
import 'package:flutter_chat/utils/parse_date.dart';
import '../../../styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PrivateMessageScreen extends StatefulWidget {
  final String chat_uid;
  final String partner_uid;

  PrivateMessageScreen({required this.chat_uid, required this.partner_uid});
  @override
  _PrivateMessageScreenState createState() => _PrivateMessageScreenState();
}

class _PrivateMessageScreenState extends State<PrivateMessageScreen> {
  TextEditingController _messageController = new TextEditingController();

  var user_id;

  Future<dynamic> getUserId() async {
    get_userId().then((data) {
      setState(() {
        print(data);
        user_id = data;
      });
    });
  }

  @override
  void initState() {
    _messageController = new TextEditingController();
    getUserId();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                firestore
                    .collection('chats')
                    .where('has_chat', isEqualTo: false)
                    .get()
                    .then((snapshot) {
                  for (var chat in snapshot.docs) {
                    if (chat.data()['has_chat'] == false &&
                        chat.id == widget.chat_uid) {
                      firestore.collection('users').doc(user_id).update({
                        'chats': FieldValue.arrayRemove([chat.id])
                      }).then((value) {
                        firestore
                            .collection('users')
                            .doc(widget.partner_uid)
                            .update({
                          'chats': FieldValue.arrayRemove([chat.id])
                        });
                        firestore
                            .collection('chats')
                            .doc(widget.chat_uid)
                            .delete()
                            .then((resp) {
                           Navigator.of(context)
                          .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                        });
                      });
                    } else {}
                  }
                });

                Navigator.pushReplacementNamed(context, "/");
              },
              icon: Icon(Icons.arrow_back),
            ),
            title: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/person_profile',
                      arguments: {'partner_uid': widget.partner_uid});
                },
                child: Row(children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                          'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cG9ydHJhaXR8ZW58MHx8MHx8&w=1000&q=80',
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover)),
                  SizedBox(width: 12),
                  StreamBuilder<dynamic>(
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text("${snapshot.data.data()['fullname']}",
                            style: textTitle.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700));
                      }
                      return Container();
                    },
                    stream: firestore
                        .collection('users')
                        .doc(widget.partner_uid)
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

                        return ListView.builder(
                            reverse: true,
                            itemBuilder: (context, index) {
                              return _message(
                                  messages[index]['sender_uid'],
                                  messages[index]['message'],
                                  "${chatDate(messages[index]['message_date'].seconds)}");
                            },
                            itemCount: messages.length);
                      }
                      return Container();
                    },
                    stream: firestore
                        .collection('private_message')
                        .doc(widget.chat_uid)
                        .collection('messages')
                        .orderBy('message_date', descending: true)
                        .snapshots(),
                  ))),
          Container(
              width: double.infinity,
              height: 56,
              padding: EdgeInsets.all(12),
              child: Row(children: [
                Expanded(
                    child: TextField(
                        controller: _messageController,
                        style: textSubtitle.copyWith(
                            color: kPrimaryColor, fontSize: 16),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Send Message",
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 4.0),
                        ))),
                SizedBox(
                  width: 4.0,
                ),
                IconButton(
                  icon: Icon(Icons.send, color: kPrimaryColor),
                  onPressed: () {
                    MessageModel messageModel = new MessageModel(
                        message: _messageController.text,
                        sender_uid: user_id,
                        message_date: DateTime.now());
                    MessageService messageService = new MessageService();
                    ChatService chatService = new ChatService();

                    messageService
                        .send_message(messageModel, widget.chat_uid)
                        .then((resp) {
                      print(resp);
                    });
                    chatService
                        .updateLastMessage(messageModel, true, widget.chat_uid)
                        .then(() {});
                    setState(() {
                      _messageController.clear();
                    });
                  },
                )
              ]))
        ]));
  }

  Widget _message(String? sender_uid, String? message, String? date) {
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: sender_uid == user_id ? 4.0 : 16.0),
      child: Row(
          mainAxisAlignment: user_id == sender_uid
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
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
                            Text("${date}",
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
