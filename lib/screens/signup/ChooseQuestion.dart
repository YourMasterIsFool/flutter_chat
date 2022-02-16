import 'package:flutter/material.dart';

typedef StringValue = String? Function(String?);


class ChooseQuestion extends StatefulWidget {
	List<String> choices;
	String title;
	StringValue callback;
	String? value;
	ChooseQuestion({
		required this.choices,
		required this.title,
		required this.callback,
		this.value
	});
	@override
	_ChooseQuestionState createState() => _ChooseQuestionState();
}

class _ChooseQuestionState extends State<ChooseQuestion> {

	@override
	Widget build(BuildContext context) {
		return 

		Scaffold(
			appBar: AppBar(
				title: Text("${widget.title}")
			),
			body: Container(
				child: ListView.builder(
					itemCount: widget.choices.length,
					itemBuilder: (context, index) {
						return Container(
							child: ElevatedButton(
								onPressed: (){
									widget.callback(widget.choices[index]);
									Navigator.pop(context);
								},
								child: Text("${widget.choices[index]}"),
								style: ButtonStyle(
									padding:MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0)),
									backgroundColor: MaterialStateProperty.all(
										widget.choices[index] == widget.value ? Colors.blue.shade100 : Colors.white
									),
									foregroundColor: MaterialStateProperty.all(Colors.black)
								)
							)
						);
					}
				)
			)
		);
		
	}
}