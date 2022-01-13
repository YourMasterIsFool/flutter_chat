import 'package:flutter/material.dart';
import 'package:flutter_chat/styles.dart';

class LoadingScreen extends StatefulWidget {
  bool isLoading = false;

  LoadingScreen({this.isLoading = false});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.isLoading
          ? Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.grey.withOpacity(0.2),
              child: Center(
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: kPrimaryColor)))
          : Container(),
    );
  }
}
