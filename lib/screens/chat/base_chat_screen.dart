import 'package:flutter/material.dart';
import 'package:flutter_chat/preferences/user_pref.dart';
import '../../styles.dart';
import './group_chat/group_chat_screen.dart';
import './private_chat/private_chat_screen.dart';

class BaseChatScreen extends StatefulWidget {
  @override
  _BaseChatScreen createState() => _BaseChatScreen();
}

class _BaseChatScreen extends State<BaseChatScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  var user_id;

  Future<dynamic> get_user_id() async {
    await get_userId().then((data) {
      print(data);
      setState(() {
        user_id = data;
      });
    });
  }

  int selectedTabIndex = 0;

  void initState() {
    get_user_id();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    tabController!.dispose();
  }

  void searchScreen(int? index, BuildContext context) {
    if (index == 1) {
      Navigator.pushNamed(context, '/search_group');
    }
    print(index);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
            appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
                actions: [
                  IconButton(
                      color: Colors.white,
                      onPressed: () {
                        if (selectedTabIndex == 0) {
                        } else {
                          Navigator.pushNamed(context, '/search_group');
                        }
                      },
                      icon: Icon(
                        Icons.search,
                        size: 24,
                        color: Colors.white,
                      )),
                  IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/person_profile",
                            arguments: {'partner_uid': user_id});
                      },
                      icon: Icon(Icons.person_rounded))
                ],
                //titile app bar
                title: Text(
                  "MyChat",
                  style: textTitle.copyWith(fontWeight: FontWeight.w600),
                ),
                elevation: 0,
                bottom: new TabBar(
                    onTap: (tabIndex) {
                      setState(() {
                        selectedTabIndex = tabIndex;
                      });
                    },
                    labelStyle: textSubtitle.copyWith(
                        fontWeight: FontWeight.w600, color: Colors.white),
                    unselectedLabelStyle:
                        textSubtitle.copyWith(color: Colors.grey.shade200),
                    tabs: [
                      Tab(
                        icon: null,
                        text: "Private Chat",
                      ),
                      Tab(icon: null, text: "Group Chat")
                    ])),
            body: Container(
                height: double.infinity,
                width: double.infinity,
                child: TabBarView(children: [
                  PrivateChatScreen(),
                  GroupChatScreen(),
                ])),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/new_chat');
                },
                backgroundColor: kPrimaryColor,
                child: Icon(Icons.message))));
  }
}
