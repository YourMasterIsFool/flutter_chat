import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/models/chat_model.dart';
import 'package:flutter_chat/my_firebase.dart';
import 'package:flutter_chat/preferences/user_pref.dart';
import 'package:flutter_chat/screens/person_profile/person_textfield.dart';
import '../../styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PersonProfileScreen extends StatefulWidget {
  final String partner_uid;
  PersonProfileScreen({required this.partner_uid});
  @override
  _PersonProfileScreenState createState() => _PersonProfileScreenState();
}

class _PersonProfileScreenState extends State<PersonProfileScreen> {
  bool setEdit = false;
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<dynamic>(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = snapshot.data.data();
          return NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerSelectedBox) {
                return [
                  SliverAppBar(
                    expandedHeight: 350.0,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                        title: Text("${data['fullname']}",
                            style: textTitle.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                        background: Image.network(
                          "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cG9ydHJhaXR8ZW58MHx8MHx8&w=1000&q=80",
                          fit: BoxFit.cover,
                        )),
                  ),
                ];
              },
              body: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(color: Colors.grey.shade200),
                  child: Padding(
                      padding: EdgeInsets.only(top: kDefaultPadding),
                      child: Column(children: [
                        _nameContainer(context, '${data["fullname"]}'),
                        SizedBox(
                          height: 24,
                        ),
                        widget.partner_uid != user_id
                            ? _messageContainer(context)
                            : Container(),

                        SizedBox(
                          height: 24,
                        ),
                        // info bio
                        _bioContainer(context, data['bio'])
                      ]))));
        }
        return Container();
      },
      stream: firestore.collection('users').doc(widget.partner_uid).snapshots(),
    ));
  }

  // for bio container
  Widget _bioContainer(BuildContext context, String bio) {
    return Container(
        decoration: BoxDecoration(color: Colors.white),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Info Dan Bio',
                  style: textSubtitle.copyWith(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500)),
              widget.partner_uid == user_id
                  ? IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => PersonTextField(
                                    column: 'bio',
                                    title: "Edit Bio",
                                    user_uid: user_id,
                                    url: 'users',
                                    data_form: bio)));
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.grey.shade500,
                        size: 20,
                      ))
                  : Container()
            ],
          ),
          SizedBox(height: 12.0),
          Text("${bio}", style: textTitle.copyWith(color: Colors.black))
        ]));
  }

  Widget _nameContainer(BuildContext context, String nama) {
    return Container(
        decoration: BoxDecoration(color: Colors.white),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Name',
                  style: textSubtitle.copyWith(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500)),
              widget.partner_uid == user_id
                  ? IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => PersonTextField(
                                    column: 'fullname',
                                    title: "Name",
                                    user_uid: user_id,
                                    url: 'users',
                                    data_form: nama)));
                      },
                      icon: Icon(
                        Icons.edit,
                        color: Colors.grey.shade500,
                        size: 20,
                      ))
                  : Container()
            ],
          ),
          SizedBox(height: 12.0),
          Text("${nama}", style: textTitle.copyWith(color: Colors.black))
        ]));
  }

  // for mesasge button
  Widget _messageContainer(BuildContext context) {
    _color(states) {
      if (states.contains(MaterialState.pressed)) {
        return Colors.grey.shade900;
      }

      return Colors.grey.shade700;
    }

    return Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            spreadRadius: .5,
            blurRadius: 1,
            offset: Offset(0, 2),
          ),
        ]),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Message ',
              style: textTitle.copyWith(
                  color: Colors.black, fontWeight: FontWeight.w500)),
          ElevatedButton(
              onPressed: () {
                ChatModel _chatModel = new ChatModel(
                    has_chat: false, members: [user_id, widget.partner_uid]);
                firestore
                    .collection('chats')
                    .where('members', arrayContainsAny: [user_id])
                    .get()
                    .then((value) {
                      print(value.docs.length);
                      if (value.docs.length > 0) {
                        var chats = value.docs;

                        for (var chat in chats) {
                          var chat_detail = chat.data();
                          List members = chat_detail['members'];
                          if (members.contains(widget.partner_uid)) {
                            Navigator.pushReplacementNamed(
                                context, '/private_message', arguments: {
                              'chat_uid': chat.id,
                              'partner_uid': widget.partner_uid
                            });
                          } else {
                            firestore
                                .collection('chats')
                                .add(_chatModel.toJson())
                                .then((chat) {
                              firestore
                                  .collection('users')
                                  .doc(user_id)
                                  .update({
                                'chats': FieldValue.arrayUnion([chat.id])
                              }).then((value) {
                                firestore
                                    .collection('users')
                                    .doc(widget.partner_uid)
                                    .update({
                                  'chats': FieldValue.arrayUnion([chat.id])
                                }).then((value) {
                                  Navigator.pushNamed(
                                      context, '/private_message', arguments: {
                                    'chat_uid': chat.id,
                                    'partner_uid': widget.partner_uid
                                  });
                                });
                              });
                            });
                          }
                        }
                      } else {
                        firestore
                            .collection('chats')
                            .add(_chatModel.toJson())
                            .then((chat) {
                          firestore.collection('users').doc(user_id).update({
                            'chats': FieldValue.arrayUnion([chat.id])
                          }).then((value) {
                            firestore
                                .collection('users')
                                .doc(widget.partner_uid)
                                .update({
                              'chats': FieldValue.arrayUnion([chat.id])
                            }).then((value) {
                              Navigator.pushNamed(context, '/private_message',
                                  arguments: {
                                    'chat_uid': chat.id,
                                    'partner_uid': widget.partner_uid
                                  });
                            });
                          });
                        });
                      }
                    });
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.resolveWith(_color),
                backgroundColor: MaterialStateProperty.all(Colors.white),
                elevation: MaterialStateProperty.all(0),
              ),
              child: Icon(Icons.message))
        ]));
  }
}
