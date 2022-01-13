import 'package:flutter/material.dart';
import './chat/base_chat_screen.dart';

class BaseScreen extends StatefulWidget {
	@override
	_BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
	@override
	Widget build(BuildContext context) {
		return BaseChatScreen();
	}
}