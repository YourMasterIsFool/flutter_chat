import 'package:flutter/material.dart';
import 'package:flutter_chat/my_firebase.dart';

class PersonTextField extends StatefulWidget {
  final String url;
  final String user_uid;
  final String data_form;
  final String title;
  final String column;

  const PersonTextField(
      {Key? key,
      required this.url,
      required this.column,
      required this.title,
      required this.user_uid,
      required this.data_form})
      : super(key: key);

  @override
  _PersonTextFieldState createState() => _PersonTextFieldState();
}

class _PersonTextFieldState extends State<PersonTextField> {
  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    controller.text = widget.data_form;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.title}'),
        ),
        body: Padding(
          padding: EdgeInsets.all(12.0),
          child: Column(
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(),
              ),
              SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        firestore
                            .collection(widget.url)
                            .doc(widget.user_uid)
                            .update({'${widget.column}': controller.text}).then(
                                (resp) {
                          Navigator.pop(context);
                        });
                      },
                      child: Text("Edit"))
                ],
              )
            ],
          ),
        ));
  }
}
