import 'package:flutter/material.dart';
import 'package:flutter_chat/styles.dart';
import '../../services/user_service.dart';
import '../../models/user_model.dart';
import '../../components/LoadingScreen.dart';
import './ChooseQuestion.dart';
import '../../my_firebase.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwodController = new TextEditingController();
  TextEditingController _fullnameController = new TextEditingController();
  TextEditingController _answerController = new TextEditingController();


  bool isLoading = false;


  List<String> questions = [
    "siapa nama ibu kamu?",
    "dimana kota kamu tinggal? "
  ];

  String? question_val = "siapa nama ibu kamu?";
  String error = "";
  bool buttonDisabled = false;


 Future<bool> checkUser(String email) async {
      
      bool result = false;

      
      setState(() {
        isLoading = false;
      });

      print(result);
      return result;
  }
  regiterNewUser(BuildContext context) async{
    setState(() {
      isLoading = true;
    });

    await firestore..collection("users")
      .where("email",  isEqualTo:_emailController.text)
      .get()
      .then((snapshot) async {
        if(snapshot.docs.length > 0) {
         error = "Email sudah digunakan";
        }


      else {
        FirebaseAuth _authInstance = FirebaseAuth.instance;
        await _authInstance.createUserWithEmailAndPassword(email: _emailController.text.trim(), password:"verrandy123")
        .then((UserCredential userCredential){

          User? user= userCredential.user;
          print(user?.emailVerified.toString());
          user?.sendEmailVerification().then((result) {

              print("verification user email has been sended");
                 UserModel user_model = new UserModel(
                  email: _emailController.text,
                  friends: [],
                  question: "${question_val}".toLowerCase(),
                  answer:_answerController.text.toLowerCase(),
                  password: _passwodController.text,
                  fullname: _fullnameController.text);

                  UserService user_service = new UserService();

                  user_service.create_user(user_model.toJson()).then((resp) {
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.pushNamed(context, "/login");
                  });
            
          });


          // if(!user?.emailVerified) {
          //   print(user?.emailVerified);
          //    user?.sendEmailVerification()
          //    .then((resp){
          //       print("verification user email has been sended");
          //        UserModel user_model = new UserModel(
          //         email: _emailController.text,
          //         friends: [],
          //         question: "${question_val}".toLowerCase(),
          //         answer:_answerController.text.toLowerCase(),
          //         password: _passwodController.text,
          //         fullname: _fullnameController.text);

          //         UserService user_service = new UserService();

          //         user_service.create_user(user_model.toJson()).then((resp) {
          //           setState(() {
          //             isLoading = false;
          //           });
          //           Navigator.pushNamed(context, "/login");
          //         });
          //     });
          // }
        
        });

      
        }
        
        setState(() {
          isLoading = false;
        });
      });


        print(error);
    
  }


  setQuestionValue(String value) {
    setState(() {
      question_val = value;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.shade50,
          title: Text("Create Account",
              style: textHeading.copyWith(
                  color: kPrimaryColor, fontWeight: FontWeight.w600)),
          elevation: 0,
          iconTheme: IconThemeData(color: kPrimaryColor),
        ),
        body: SafeArea(
          child: IgnorePointer(
            ignoring: isLoading,
            child: Stack(children: [
              LoadingScreen(
                isLoading: isLoading,
              ),
              Container(
                width: double.infinity,
                height: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: kDefaultPadding,
                      ),
                      Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: kDefaultPadding),
                          width: 300,
                          child: Text("Create Chat Account",
                              style: textHeading.copyWith(
                                  color: kPrimaryColor, fontSize: 32.0))),
                      SizedBox(height: 24),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: kDefaultPadding),
                        child: Column(children: [
                          Container(
                              // margin: EdgeInsets.only(bottom: kDefaultPadding),
                              child: Form(
                               // autovalidate: true,
                                child: TextFormField(
                                  validator: (value) {
                                    if(EmailValidator.validate("${value}")) {
                                      setState(() {
                                        _emailController.text = "${value}";
                                      });
                                    }
                                    else{
                                      setState(() {
                                        error = "Email tidak valid";
                                        });
                                    }
                                  },
                                  onChanged:(value){
                                    setState(() {
                                        _emailController.text = "${value}";
                                      });
                                    if(EmailValidator.validate("${value}")) {
                                      setState(() {
                                        _emailController.text = "${value}";
                                      });
                                      error = "";
                                      buttonDisabled = false;
                                    }
                                    else{
                                      setState(() {
                                        error = "Email ${_emailController.text} tidak valid";
                                        });
                                        buttonDisabled = true;
                                    }
                                    },
                                  // controller: _emailController,
                                  decoration: InputDecoration(
                                      hintText: "Email",
                                      prefixIcon: Icon(Icons.email),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              width: 4,
                                              color: kPrimaryColor))))
                              ) 

                            ),
                          error == "" ? Container() : Text("${error}", style: textSubtitle.copyWith(color: Colors.red.shade500)),
                          
                          SizedBox(height:24/3),
                          Container(
                              margin: EdgeInsets.only(bottom: kDefaultPadding),
                              child: TextField(
                                  controller: _fullnameController,

                                  decoration: InputDecoration(
                                      hintText: "Fullname",
                                      prefixIcon: Icon(Icons.person),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              width: 4,
                                              color: kPrimaryColor))))),
                          Container(
                              margin: EdgeInsets.only(bottom: kDefaultPadding),
                              child: TextField(
                                  controller: _passwodController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      hintText: "Password",
                                      prefixIcon: Icon(Icons.lock),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              width: 4,
                                              color: kPrimaryColor))))),


                           Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: kDefaultPadding / 3
                              ),
                              Text(
                                "Pilih Pertanyaan:"
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              ElevatedButton(
                                onPressed: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ChooseQuestion(choices: questions, value:question_val, title: "Pilih Pertanyaan", callback:(String? value) {
                                      setState(() {
                                        question_val = value;
                                      });
                                    }))
                                    );
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(Colors.white),
                                  foregroundColor: MaterialStateProperty.all(Colors.black),
                                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0))
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    Flexible(
                                      child: Text("${question_val}")
                                    ),

                                    Icon(
                                      Icons.arrow_right
                                    )

                                  ]
                                )
                              ),
                              SizedBox(
                                height: 12.0,
                              ),

                              Container(
                              margin: EdgeInsets.only(bottom: kDefaultPadding),
                              child: TextField(
                                  controller: _answerController,
                                  // obscureText: true,
                                  decoration: InputDecoration(
                                      hintText: "Jawab",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              width: 4,
                                              color: kPrimaryColor))))),


                            ]
                          ),

                          SizedBox(
                            height: kDefaultPadding / 2,
                          ),


                        
                          Container(
                            width: double.infinity,
                            child: TextButton(
                              child: Text("Create Account"),
                              onPressed: () => buttonDisabled ? null : regiterNewUser(context),
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  textStyle: MaterialStateProperty.all(
                                      textTitle.copyWith()),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith(
                                          (states) {
                                    if (states
                                        .contains(MaterialState.pressed)) {
                                      return Colors.blue.shade700;
                                    }
                                    return kPrimaryColor;
                                  }),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.all(16))),
                            ),
                          ),
                          SizedBox(
                            height: kDefaultPadding / 3,
                          ),
                          Row(
                            children: [
                              Text(
                                "have account? ",
                                style: textSubtitle.copyWith(
                                    color: Colors.grey.shade600),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Login",
                                    style: textSubtitle.copyWith(
                                        color: kPrimaryColor,
                                        fontWeight: FontWeight.w600),
                                  ))
                            ],
                          )
                        ]),
                      )
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ));
  }

  // Widget _choiceQuestionPassword() {
  //   return ElevatedButton(
  //     onPressed: (){},
  //        child: Text("choice your question"),
  //     style: ButtonStyle(

  //       backgroundColor: MaterialStateProperty.all(Colors.blue.shade100)
  //     )
  //   );
  // }

  Widget _inputField(
    TextEditingController controller,
    String label,
  ) {
    return TextField(
        controller: controller,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade500))));
  }
}
