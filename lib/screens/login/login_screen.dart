import 'package:flutter/material.dart';
import 'package:flutter_chat/preferences/user_pref.dart';
import 'package:flutter_chat/styles.dart';
import '../../services/user_service.dart';
import '../../models/user_model.dart';
import '../../services/user_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import '../forgot_password/CheckMailScreen.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _fullnameController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  dynamic _loginQuery = null;
  String error = "";

  bool isLoading = false;

  loginUser(BuildContext context, String email, String password) async {
    setState(() {
      isLoading = true;
    });

    UserService user_service = new UserService();
    var schema = {'email': email, 'password': password};
    await user_service.login_user(schema).then<dynamic>((snapshot) async {
      if (snapshot.docs.length > 0) {
        var user = snapshot.docs[0];
        await set_userId(user.id).then((value) {
          Navigator.of(context)
        .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
        });
      } else {
        setState(() {
          error = "User tidak ada atau incorected password !";
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        automaticallyImplyLeading: false,
        title: Text("Login",
            style: textHeading.copyWith(
                color: kPrimaryColor, fontWeight: FontWeight.w600)),
        elevation: 0,
        iconTheme: IconThemeData(color: kPrimaryColor),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 24,
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  width: 250,
                  child: Text("Hello again welcome back",
                      style: textHeading.copyWith(
                          color: kPrimaryColor, fontSize: 32.0))),
              SizedBox(height: 24),
              Container(
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Column(children: [
                  Container(
                      margin: EdgeInsets.only(bottom: kDefaultPadding),
                      child: TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                              hintText: "Email",
                              prefixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      width: 4, color: kPrimaryColor))))),
                  Container(
                      margin: EdgeInsets.only(bottom: kDefaultPadding),
                      child: TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                              hintText: "Password",
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      width: 4, color: kPrimaryColor))))),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      error != ""
                          ? Text(
                              "user tidak ada atau password salah",
                              style: textSubtitle.copyWith(
                                  color: Colors.red.shade600),
                            )
                          : Container(),
                    ],
                  ),
                  SizedBox(
                    height: kDefaultPadding / 2,
                  ),
                  Container(
                    width: double.infinity,
                    child: TextButton(
                      child: Text("Sign In"),
                      onPressed: () => loginUser(context, _emailController.text,
                          _passwordController.text),
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          textStyle:
                              MaterialStateProperty.all(textTitle.copyWith()),
                          shape:
                              MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                          backgroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.blue.shade700;
                            }
                            return kPrimaryColor;
                          }),
                          padding:
                              MaterialStateProperty.all(EdgeInsets.all(16))),
                    ),
                  ),

                  SizedBox(
                    height: kDefaultPadding /4
                  ),
                  Row(
                    children: [
                      Text("Forgot password?" , style:textSubtitle.copyWith(color: Colors.grey.shade600)),
                      TextButton(
                        onPressed: (){
                          Navigator.push(context, CupertinoPageRoute(builder: (context) => CheckMailScreen()));
                        },
                        child: Text("recovery password")
                      )
                    ]
                  ),
            
                  Row(
                    children: [
                      Text(
                        "doesn't have account ?",
                        style:
                            textSubtitle.copyWith(color: Colors.grey.shade600),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: Text(
                            "Sign Up",
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
    );
  }

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
