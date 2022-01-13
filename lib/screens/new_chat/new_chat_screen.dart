import 'package:flutter/material.dart';
import 'package:flutter_chat/styles.dart';
import 'package:basic_utils/basic_utils.dart';

class NewChatScreen extends StatefulWidget {
  const NewChatScreen({Key? key}) : super(key: key);

  @override
  _NewChatScreenState createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  bool showSearchInput = false;
  TextEditingController searchController = new TextEditingController();

  @override
  void initState() {
    searchController = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  void searchInput() {
    setState(() {
      showSearchInput = !showSearchInput;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarComponent(
          context, showSearchInput, searchInput, searchController),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: kDefaultPadding / 2,
                  horizontal: kDefaultPadding / 2),
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.grey.shade900),
              child: Text(
                "Your contact",
                style: textTitle.copyWith(color: Colors.white),
              ),
            ),
            Flexible(child: _contactListComponent(context))
          ],
        ),
      ),
    );
  }

  AppBar _appBarComponent(BuildContext? context, bool showSearchInput,
      VoidCallback openShowSearch, TextEditingController controller) {
    _searchContact() {
      return TextField(
        controller: controller,
        style: textTitle.copyWith(color: Colors.white),
        decoration: InputDecoration(
            hintStyle: textTitle.copyWith(color: Colors.grey.shade300),
            border: InputBorder.none,
            hintText: "Search Contact..."),
      );
    }

    return AppBar(
      title: showSearchInput
          ? _searchContact()
          : Text(
              "New Message",
              style: textTitle.copyWith(color: Colors.white),
            ),
      actions: [
        IconButton(
          onPressed: openShowSearch,
          icon: Icon(showSearchInput ? Icons.close : Icons.search),
          color: Colors.white,
        )
      ],
    );
  }

  Widget _contactComponent(String? name) {
    _backgroundColor(states) {
      if (states.contains(MaterialState.pressed)) {
        return Colors.grey.shade300;
      }
      return Colors.white;
    }

    return ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith(_backgroundColor),
          elevation: MaterialStateProperty.all(0),
          padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(vertical: 8, horizontal: 16)),
        ),
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
            SizedBox(
              width: kDefaultPadding / 2,
            ),
            Text(
              "${StringUtils.capitalize('$name')}",
              style: textTitle.copyWith(
                  color: Colors.black, fontWeight: FontWeight.w500),
            )
          ],
        ));
  }

  Widget _contactListComponent(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return _contactComponent('verrandy');
      },
      itemCount: 12,
    );
  }
}
