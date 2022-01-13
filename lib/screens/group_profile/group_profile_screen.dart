import 'package:flutter/material.dart';
import 'package:flutter_chat/my_firebase.dart';
import 'package:flutter_chat/preferences/user_pref.dart';
import '../../styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GroupProfileScreen extends StatefulWidget {
  String group_uid;
  GroupProfileScreen({required this.group_uid});
  @override
  _GroupProfileScreenState createState() => _GroupProfileScreenState();
}

class _GroupProfileScreenState extends State<GroupProfileScreen> {
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

  void exitGroup() {
    firestore.collection('groups').doc(widget.group_uid).update({
      'members': FieldValue.arrayRemove([user_id])
    });

    firestore.collection('users').doc(user_id).update({
      'groups': FieldValue.arrayRemove([widget.group_uid])
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<dynamic>(
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var group = snapshot.data.data();
                List members = group['members'];
                bool userExit = members.contains(user_id);
                return NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerSelectedBox) {
                      return [
                        SliverAppBar(
                          expandedHeight: 350.0,
                          floating: false,
                          pinned: true,
                          flexibleSpace: FlexibleSpaceBar(
                              title: Text(
                                  "${group['hobby']} ${group['lokasi']}",
                                  style: textTitle.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700)),
                              background: Image.network(
                                "https://media.istockphoto.com/photos/group-multiracial-people-having-fun-outdoor-happy-mixed-race-friends-picture-id1211345565?k=20&m=1211345565&s=612x612&w=0&h=Gg65DvzedP7YDo6XFbB-8-f7U7m5zHm1OPO3uIiVFgo=",
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
                            padding: EdgeInsets.only(top: 0),
                            child: ListView(children: [
                              SizedBox(
                                height: 24,
                              ),
                              // info bio
                              _descContainer(
                                  context, group['group_description']),

                              SizedBox(
                                height: 24,
                              ),

                              _categoryContainer(context, group['hobby']),

                              SizedBox(
                                height: 24,
                              ),

                              _memberContainer(context, group['members']),

                              SizedBox(
                                height: 24,
                              ),

                              userExit
                                  ? _exitGroupContainer(context)
                                  : _joinGroupContainer(context)
                            ]))));
              }
              return CircularProgressIndicator(
                color: kPrimaryColor,
                strokeWidth: 2,
              );
            },
            stream: firestore
                .collection('groups')
                .doc(widget.group_uid)
                .snapshots()));
  }

  Widget _memberComponent(String member_uid) {
    _backgroundColor(states) {
      if (states.contains(MaterialState.pressed)) {
        return Colors.grey.shade200;
      }

      return Colors.white;
    }

    return StreamBuilder<dynamic>(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var user = snapshot.data.data();
          var your_uid = snapshot.data;
          // print(user_uid);
          print(your_uid.id);
          return ElevatedButton(
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                            'https://media.istockphoto.com/photos/group-multiracial-people-having-fun-outdoor-happy-mixed-race-friends-picture-id1211345565?k=20&m=1211345565&s=612x612&w=0&h=Gg65DvzedP7YDo6XFbB-8-f7U7m5zHm1OPO3uIiVFgo=',
                            height: 56,
                            width: 56,
                            fit: BoxFit.cover)),
                    SizedBox(
                      width: 12.0,
                    ),
                    Text("${user['fullname']}",
                        style: textTitle.copyWith(
                            color: Colors.black, fontWeight: FontWeight.w500))
                  ]),
              onPressed: () {
                if (your_uid.id != user_id) {
                  Navigator.pushNamed(context, "/person_profile",
                      arguments: {'partner_uid': member_uid});
                }
              },
              style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor:
                      MaterialStateProperty.resolveWith(_backgroundColor),
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(
                      horizontal: kDefaultPadding / 2, vertical: 4.0))));
        }
        return CircularProgressIndicator(
          color: kPrimaryColor,
          strokeWidth: 2,
        );
      },
      stream: firestore.collection('users').doc(member_uid).snapshots(),
    );
  }

  Widget _exitGroupContainer(BuildContext context) {
    _backgroundColor(states) {
      if (states.contains(MaterialState.pressed)) {
        return Colors.grey.shade200;
      }
      return Colors.white;
    }

    return ElevatedButton(
        onPressed: () => exitGroup(),
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(vertical: 24, horizontal: 16.0)),
          backgroundColor: MaterialStateProperty.resolveWith(_backgroundColor),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Icon(Icons.exit_to_app_outlined,
              color: Colors.red.shade600, size: 32),
          SizedBox(
            width: kDefaultPadding,
          ),
          Text("Keluar Grup",
              style: textTitle.copyWith(
                  color: Colors.red.shade500, fontWeight: FontWeight.w600))
        ]));
  }

  Widget _joinGroupContainer(BuildContext context) {
    _backgroundColor(states) {
      if (states.contains(MaterialState.pressed)) {
        return Colors.grey.shade200;
      }
      return Colors.white;
    }

    return ElevatedButton(
        onPressed: () => joinGroup(),
        style: ButtonStyle(
          padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(vertical: 24, horizontal: 16.0)),
          backgroundColor: MaterialStateProperty.resolveWith(_backgroundColor),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Icon(Icons.exit_to_app_outlined,
              color: Colors.green.shade600, size: 32),
          SizedBox(
            width: kDefaultPadding,
          ),
          Text("Masuk Group",
              style: textTitle.copyWith(
                  color: Colors.green.shade700, fontWeight: FontWeight.w600))
        ]));
  }

  // member container
  Widget _memberContainer(BuildContext context, var members) {
    return Container(
        decoration: BoxDecoration(color: Colors.white),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text('Member',
                style: textSubtitle.copyWith(
                    color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
          ),
          SizedBox(height: 12.0),
          Column(children: [
            for (var index = 0; index < members.length; index++)
              _memberComponent("${members[index]}"),
          ])
        ]));
  }

  // for bio container
  Widget _descContainer(BuildContext context, String desc) {
    return Container(
        decoration: BoxDecoration(color: Colors.white),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Group Description',
              style: textSubtitle.copyWith(
                  color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
          SizedBox(height: 12.0),
          Text("${desc}", style: textTitle.copyWith(color: Colors.black))
        ]));
  }

  // category container
  Widget _categoryContainer(BuildContext context, String category) {
    return Container(
        decoration: BoxDecoration(color: Colors.white),
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Category Group',
              style: textSubtitle.copyWith(
                  color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
          SizedBox(height: 12.0),
          Text("${category}", style: textTitle.copyWith(color: Colors.black))
        ]));
  }

  // for mesasge button
  // Widget _messageContainer(BuildContext context) {
  //   _color(states) {
  //     if (states.contains(MaterialState.pressed)) {
  //       return Colors.grey.shade900;
  //     }

  //     return Colors.grey.shade700;
  //   }

  //   return Container(
  //       decoration: BoxDecoration(color: Colors.white, boxShadow: [
  //         BoxShadow(
  //           color: Colors.grey.shade300,
  //           spreadRadius: .5,
  //           blurRadius: 1,
  //           offset: Offset(0, 2),
  //         ),
  //       ]),
  //       width: double.infinity,
  //       padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
  //       child:
  //           Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
  //         Text('Message ',
  //             style: textTitle.copyWith(
  //                 color: Colors.black, fontWeight: FontWeight.w500)),
  //         ElevatedButton(
  //             onPressed: () {
  //               Navigator.pushNamed(context, '/private_message');
  //             },
  //             style: ButtonStyle(
  //               foregroundColor: MaterialStateProperty.resolveWith(_color),
  //               backgroundColor: MaterialStateProperty.all(Colors.white),
  //               elevation: MaterialStateProperty.all(0),
  //             ),
  //             child: Icon(Icons.message))
  //       ]));
  // }
}
