import 'package:flutter/material.dart';
import 'package:flutter_chat/styles.dart';
import '../../services/user_service.dart';
import '../../models/user_model.dart';
import '../../components/LoadingScreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwodController = new TextEditingController();
  TextEditingController _fullnameController = new TextEditingController();

  bool isLoading = false;

  regiterNewUser(BuildContext context) {
    setState(() {
      isLoading = true;
    });
    UserModel user_model = new UserModel(
        email: _emailController.text,
        friends: [],
        password: _passwodController.text,
        fullname: _fullnameController.text);

    UserService user_service = new UserService();

    user_service.create_user(user_model.toJson()).then((resp) {
      setState(() {
        isLoading = false;
      });
      Navigator.pushNamed(context, "/login");
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
                              margin: EdgeInsets.only(bottom: kDefaultPadding),
                              child: TextField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                      hintText: "Email",
                                      prefixIcon: Icon(Icons.email),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              width: 4,
                                              color: kPrimaryColor))))),
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
                          SizedBox(
                            height: kDefaultPadding / 2,
                          ),
                          Container(
                            width: double.infinity,
                            child: TextButton(
                              child: Text("Create Account"),
                              onPressed: () => regiterNewUser(context),
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
