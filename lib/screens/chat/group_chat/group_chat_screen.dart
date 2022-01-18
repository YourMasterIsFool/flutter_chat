import 'package:flutter/material.dart';
import 'package:flutter_chat/my_firebase.dart';
import 'package:flutter_chat/preferences/user_pref.dart';
import 'package:flutter_chat/utils/parse_date.dart';
import '../../../styles.dart';
import 'package:basic_utils/basic_utils.dart';

class GroupChatScreen extends StatefulWidget {
  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
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

  var chats = [
    {
      'partner_name': 'verrandy',
      'last_chat': 'aqeqweqwe',
      'date': '12/10/11',
    },
    {
      'partner_name': 'verrandy',
      'last_chat': 'aqeqweqwe',
      'date': '12/10/11',
    },
    {
      'partner_name': 'verrandy',
      'last_chat': 'aqeqweqwe',
      'date': '12/10/11',
    },
    {
      'partner_name': 'Olahraga',
      'last_chat': 'aqeqweqwe',
      'date': '12/10/11',
    },
    {
      'partner_name': 'Tenis',
      'last_chat': 'aqeqweqwe',
      'date': '12/10/11',
    },
    {
      'partner_name': 'SepakBola',
      'last_chat': 'aqeqweqwe',
      'date': '12/10/11',
    },
    {
      'partner_name': 'verrandy',
      'last_chat': 'aqeqweqwe',
      'date': '12/10/11',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        child: StreamBuilder<dynamic>(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List groups = snapshot.data.data()['groups'];
              print(groups);
              return ListView.builder(
                shrinkWrap: true,
                primary: true,
                itemBuilder: (context, index) {
                  return _chat(context, '${groups[index]}');
                },
                itemCount: groups.length,
              );
            }

            return Container();
          },
          stream: firestore.collection('users').doc(user_id).snapshots(),
        ));
  }

  Widget _chat(BuildContext context, String group_uid) {
    _photoProfile() {
      return Padding(
          padding: EdgeInsets.only(right: 12.0),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                  'https://media.istockphoto.com/photos/group-multiracial-people-having-fun-outdoor-happy-mixed-race-friends-picture-id1211345565?k=20&m=1211345565&s=612x612&w=0&h=Gg65DvzedP7YDo6XFbB-8-f7U7m5zHm1OPO3uIiVFgo=',
                  height: 64,
                  width: 64,
                  fit: BoxFit.cover)));
    }

    _descChat(String group_name, String last_message, dynamic date) {
      return Expanded(
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("${StringUtils.capitalize(group_name)}",
                  style: textTitle.copyWith(
                      color: kPrimaryColor, fontWeight: FontWeight.w700)),
              SizedBox(height: 4.0),
              Text('${last_message}',
                  style: textSubtitle.copyWith(
                      color: kPrimaryColor, fontWeight: FontWeight.w500)),
            ]),
            Text("${chatDate(date)}",
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
          var group = snapshot.data.data();
          print(group);
          return ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/group_message', arguments: {
                  'group_uid': group_uid,
                });
              },
              style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor:
                      MaterialStateProperty.resolveWith(group['last_message_userID'] == user_id ? _backgroundColor : _unReadedBackground),
                  padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12.0))),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _photoProfile(),
                    _descChat(
                        "${group['hobby']} ${group['lokasi']}",
                        group['last_message'],
                        group['last_message_date'].seconds),
                  ]));
        }
        return Container();
      },
      stream: firestore.collection('groups').doc(group_uid).snapshots(),
    );
  }
}
