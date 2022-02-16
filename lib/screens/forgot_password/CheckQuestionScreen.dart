import 'package:flutter/material.dart';
import '../../my_firebase.dart';
import '../../styles.dart';
import 'package:flutter/cupertino.dart';
import './SetNewPasswordScreen.dart';


class CheckQuestionScreen extends StatefulWidget {

	String email;

	CheckQuestionScreen({
		required this.email
	});

	@override
	_CheckQuestionScreenState createState() => _CheckQuestionScreenState();
}

class _CheckQuestionScreenState extends State<CheckQuestionScreen> {

	TextEditingController  _answerController = new TextEditingController();
	String error_message = "";

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text("Validasi Pertanyaan")
			),
			body: SafeArea(
				child: Container(
						padding:EdgeInsets.symmetric(horizontal:12, vertical:24),
						child: ListView(
							shrinkWrap:true,
							primary: false,
							physics:  NeverScrollableScrollPhysics(),
							children: [
								Container(
									child: StreamBuilder<dynamic>(
										stream: firestore.collection('users')
										.where('email', isEqualTo: widget.email)
										.limit(1)
										.snapshots(),
										builder: (context, snapshot) {
											if(snapshot.hasData){
												if(snapshot.data.docs.length > 0){
													var doc = snapshot.data.docs[0].data();

												

													return Text("${doc['question']}", style: textTitle);
												}
												return Container();
											}

											return Container();
										}
									)
								),
								SizedBox(
									height: 12.0,
								),
								TextFormField(
									controller: _answerController,
									decoration: InputDecoration(
	                                      hintText: "Jawaban",

	                                      border: OutlineInputBorder(
	                                          borderRadius:
	                                              BorderRadius.circular(10),
	                                          borderSide: BorderSide(
	                                              width: 4,
	                                              color: kPrimaryColor)))),
								SizedBox(
									height: 12.0,
								),
								error_message != "" ? Text("${error_message}", style: textSubtitle.copyWith(color: Colors.red.shade500)) : Container(),
 
								Row(
									mainAxisAlignment: MainAxisAlignment.end,
									children: [
										TextButton(
											onPressed: () {
												firestore.collection('users')
												.where('email', isEqualTo: widget.email)
												.where('answer', isEqualTo: _answerController.text )
												.get()
												.then((snapshot) {
													print(snapshot.docs[0].data());

													if(snapshot.docs.length > 0) {
														var doc = snapshot.docs[0];
														print(doc.data());
														Navigator.push(context, CupertinoPageRoute(builder: (context) => SetNewPasswordScreen(user_uid: "${doc.id}")));
														
													}
													else {
														setState(() {
															error_message = "Jawaban kamu salah";
														});
													}
												});
											},
											child: Text(
												"Recovery Password"
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