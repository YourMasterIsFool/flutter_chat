import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_chat/models/group_model.dart';
import 'package:flutter_chat/my_firebase.dart';
import 'package:flutter_chat/preferences/user_pref.dart';
import 'package:flutter_chat/styles.dart';

class SearchGroupScreen extends StatefulWidget {
  const SearchGroupScreen({Key? key}) : super(key: key);

  @override
  _SearchGroupScreenState createState() => _SearchGroupScreenState();
}

class _SearchGroupScreenState extends State<SearchGroupScreen> {
  final TextEditingController _searchController = new TextEditingController();
  final TextEditingController _hobbyController = new TextEditingController();
  final TextEditingController _lokasiController = new TextEditingController();

  var user_id;

  Future<dynamic> get_user_id() async {
    await get_userId().then((data) {
      print(data);
      setState(() {
        user_id = data;
      });
    });
  }

  var getGroups;

  @override
  void initState() {
    getGroups = null;
    get_user_id();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Group",
            style: textTitle.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
        // title: Row(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [
        //     Flexible(
        //         flex: 1,
        //         child: TextField(
        //           controller: _searchController,
        //           style: textSubtitle.copyWith(color: Colors.white),
        //           decoration: InputDecoration(
        //               border: InputBorder.none,
        //               hintText: "Search Group",
        //               hintStyle:
        //                   textSubtitle.copyWith(color: Colors.grey.shade300),
        //               contentPadding:
        //                   EdgeInsets.symmetric(horizontal: 8, vertical: 12)),
        //         )),
        //     SizedBox(
        //       width: 24,
        //     ),
        //     IconButton(
        //         onPressed: () {
        //           setState(() {
        //             var query = firestore.collection('groups').where(
        //                 "category_group",
        //                 isEqualTo: _searchController.text);
        //             getGroups = query.snapshots();
        //           });
        //         },
        //         icon: Icon(
        //           Icons.search,
        //           size: 24,
        //           color: Colors.white,
        //         ))
        //   ],
        // ),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: ListView(
          children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Hobby", style: textTitle.copyWith(color: Colors.black)),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                controller: _hobbyController,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    border:
                        OutlineInputBorder(borderSide: BorderSide(width: 2))),
              )
            ]),
            SizedBox(
              height: 12.0,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Lokasi", style: textTitle.copyWith(color: Colors.black)),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                controller: _lokasiController,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    border:
                        OutlineInputBorder(borderSide: BorderSide(width: 2))),
              )
            ]),
            SizedBox(
              height: 12.0,
            ),
            ElevatedButton(
              onPressed: () {
                // snapshot.where('lokasi', isEqualTo: _lokasiController.text);
                setState(() {
                  print(_hobbyController.text);
                  getGroups = firestore
                      .collection('groups')
                      .where('hobby', isEqualTo: _hobbyController.text.trim())
                      .where('lokasi', isEqualTo: _lokasiController.text.trim())
                      .snapshots();
                });
              },
              child: Text("Search Group"),
              style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.all(12.0))),
            ),
            SizedBox(
              height: 12.0,
            ),
            Text("Result", style: textSubtitle.copyWith(color: Colors.black)),
            SizedBox(
              height: 12.0,
            ),
            StreamBuilder<dynamic>(
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var groups = snapshot.data.docs;
                  if (groups.length == 0) {
                    return TextButton(
                        onPressed: () {
                          GroupModel _groupModel = new GroupModel(
                              hobby: _hobbyController.text.trim().toLowerCase(),
                              members: [],
                              last_message: "",
                              last_message_userId: "",
                              last_message_date: DateTime.now(),
                              group_description:
                                  "Group  ${_hobbyController.text.trim()} di ${_lokasiController.text.trim()}",
                              lokasi: _lokasiController.text.trim().toLowerCase(),
                              createdAt: DateTime.now(),
                              owner_uid: user_id);

                          firestore
                              .collection('groups')
                              .add(_groupModel.toJson())
                              .then((value) {
                            print(value.id);
                          });
                        },
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(vertical: 12.0))),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add),
                            Text(
                              "Create Group ${_hobbyController.text} ${_lokasiController.text}",
                              style: textTitle.copyWith(
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ));
                  } else {
                    var group = groups[0].data();
                    var group_uid = groups[0];
                    print(group);
                    return ElevatedButton(
                        style: ButtonStyle(backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.grey.shade300;
                          }
                          return Colors.grey.shade100;
                        })),
                        onPressed: () {
                          Navigator.pushNamed(context, '/group_message',
                              arguments: {'group_uid': group_uid.id});
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                        'https://media.istockphoto.com/photos/group-multiracial-people-having-fun-outdoor-happy-mixed-race-friends-picture-id1211345565?k=20&m=1211345565&s=612x612&w=0&h=Gg65DvzedP7YDo6XFbB-8-f7U7m5zHm1OPO3uIiVFgo=',
                                        height: 64,
                                        width: 64,
                                        fit: BoxFit.cover)),
                                SizedBox(
                                  width: 8.0,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${group['hobby']}",
                                      style: textTitle.copyWith(
                                          color: Colors.black),
                                    ),
                                    SizedBox(
                                      height: 4.0,
                                    ),
                                    Text(
                                      "${group['lokasi']}",
                                      style: textSubtitle.copyWith(
                                          color: Colors.grey.shade600),
                                    )
                                  ],
                                )
                              ],
                            )));
                  }
                }
                return Container();
              },
              stream: getGroups,
            )
          ],
        ),
      ),
    );
  }

  _groupContainer(BuildContext context, String group_uid, String group_name) {
    _bgButton<Color>(states) {
      if (states.contains(MaterialState.pressed)) {
        return Colors.grey.shade300;
      }
      return Colors.grey.shade50;
    }

    return ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, '/group_message',
              arguments: {'group_uid': group_uid, 'group_name': group_name});
        },
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.resolveWith(_bgButton),
            padding: MaterialStateProperty.all(
                EdgeInsets.symmetric(horizontal: 8.0))),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(
                      'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MXx8cG9ydHJhaXR8ZW58MHx8MHx8&w=1000&q=80',
                      height: 48,
                      width: 48,
                      fit: BoxFit.cover)),
              SizedBox(width: 12.0),
              Text("${group_name}",
                  style: textTitle.copyWith(
                      color: Colors.black, fontWeight: FontWeight.w500))
            ],
          ),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ))),
        ));
  }
}
