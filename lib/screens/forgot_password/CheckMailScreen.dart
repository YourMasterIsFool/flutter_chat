import 'package:flutter/material.dart';
import '../../styles.dart';
import '../../my_firebase.dart';
import 'package:flutter/cupertino.dart';
import './CheckQuestionScreen.dart';
import 'package:email_validator/email_validator.dart';


class CheckMailScreen extends StatefulWidget {
	@override
	_CheckMailScreenState createState() => _CheckMailScreenState();
}

class _CheckMailScreenState extends State<CheckMailScreen> {

	TextEditingController _emailController = new TextEditingController();

	String error_message="";


	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text("Check Email")
			),
			body: 
			SafeArea(
				child:Container(
					padding: EdgeInsets.symmetric(horizontal:kDefaultPadding /2 , vertical: kDefaultPadding),
					child:SingleChildScrollView(
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Text("Check Email", style:textTitle),
								SizedBox(height: 12.0),
									TextFormField(
									controller: _emailController,
									decoration: InputDecoration(
	                                      hintText: "Email",
	                                      prefixIcon: Icon(Icons.email),

	                                      border: OutlineInputBorder(
	                                          borderRadius:
	                                              BorderRadius.circular(10),
	                                          borderSide: BorderSide(
	                                              width: 4,
	                                              color: kPrimaryColor)))),

									error_message != "" ? Text("${error_message}", style: textSubtitle.copyWith(color: Colors.red.shade600)) : Container(),

									SizedBox(
										height: 24,
									),
									Row(
										mainAxisAlignment: MainAxisAlignment.end,
										children: [
											TextButton(
												onPressed: (){
													if(EmailValidator.validate("${_emailController.text}")){
														firestore.collection('users')
														.where('email', isEqualTo: _emailController.text)
														.get()
														.then((snapshot) {
															if(snapshot.docs.length > 0) {
																Navigator.push(context, CupertinoPageRoute(builder: (context) => CheckQuestionScreen(email: _emailController.text)));
															}
															else {
																setState(() {
																	error_message = "Email tidak terdaftar";
																});
															}
														})
															;
													}
													else {
														setState(() {
															error_message = "Email tidak valid";
														});
													}
													
												},
												style: ButtonStyle(
													padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical:8, horizontal: 16.0)),
													foregroundColor: MaterialStateProperty.all(Colors.white),
													backgroundColor: MaterialStateProperty.resolveWith((states) {

														if(states.contains(MaterialState.pressed)) {
															return Colors.blue.shade500;
														}

														return Colors.blue.shade400;

													}),
												),
												child: Text("Check Email")
											)
										]
									)
								

							]
						)
					)
				)
			)
			
		);
	}
}