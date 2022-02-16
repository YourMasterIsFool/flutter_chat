import 'package:flutter/material.dart';
import '../../styles.dart';
import '../../my_firebase.dart';
class SetNewPasswordScreen extends StatefulWidget {

	String user_uid;
	SetNewPasswordScreen({
		required this.user_uid
	});
	@override
	_SetNewPasswordScreenState createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {

	TextEditingController _passwordController = new TextEditingController();
	TextEditingController _checkPasswordController = new TextEditingController();

	String error_message = "";

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text("Setup New Password")
			),
			body: SafeArea(
				child: 
				Container(
					padding:EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
					child:ListView(
					children: [
						Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Text("Setup New Password", style:textTitle),
								SizedBox(
									height: 12.0,
								),
								TextFormField(
									obscureText: true,
									controller: _passwordController,
									decoration: InputDecoration(
	                                      hintText: "",	
	                                      
	                                      border: OutlineInputBorder(
	                                          borderRadius:
	                                              BorderRadius.circular(10),
	                                          borderSide: BorderSide(
	                                              width: 4,
	                                              color: kPrimaryColor)))),
							]
						),
						SizedBox(
							height: 24.0,
						),
						Column(
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								Text("Password Validation", style:textTitle),
								SizedBox(
									height: 12.0,
								),
								TextFormField(
									obscureText: true,
									onChanged:(value) {
	                                      	if(value.trim() != _passwordController.text.trim()) {
	                                      		setState(() {
	                                      			error_message = "Password tidak sama";
	                                      		});
	                                      		print("pasword salah");
	                                      	}
	                                      	else {
	                                      		setState(() {
	                                      			error_message = "";
	                                      		});
	                                      	} 
	                                      },
									decoration: InputDecoration(
	                                      hintText: "",	
	                                      
	                                      border: OutlineInputBorder(
	                                          borderRadius:
	                                              BorderRadius.circular(10),
	                                          borderSide: BorderSide(
	                                              width: 4,
	                                              color: kPrimaryColor)))),
							]
						),
								error_message != "" ? Text("${error_message}", style: textSubtitle.copyWith(color: Colors.red.shade600)) : Container(),
								SizedBox(
									height:24.0
								),

								Row(
									mainAxisAlignment: MainAxisAlignment.end,
									children: [
										TextButton(
											onPressed: error_message != "" ? (){} : (){
												firestore.collection('users').doc(widget.user_uid)
												.update({
													'password': _passwordController.text
												})
												.then((snapshot){
													Navigator.of(context)
        												.pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
												});
											},
											child: Text(
												"setup new password"
											),
											style: ButtonStyle(
												padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 12, horizontal: 20.0)),
												foregroundColor: MaterialStateProperty.all(Colors.white),
												backgroundColor: MaterialStateProperty.resolveWith((states){
													if(states.contains(MaterialState.pressed)) {
														return Colors.blue.shade500;
													}

													return Colors.blue.shade400;
												})
											)
										)
									]
								)
					]
				)
				)
				
			)
		);
	}
}