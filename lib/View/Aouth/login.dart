import 'dart:async';

import 'package:extrachildhood/Constants/sharedPrefConst.dart';
import 'package:extrachildhood/View/passwordReset.dart';
import 'package:extrachildhood/View/homePage.dart';
import 'package:extrachildhood/View/mainActivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Service/apiservices.dart';
import '../Widgets/buttons.dart';
import '../Widgets/textField.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();checkLoginStatus() async {

    bool isLoggedIn = await SharedPref.getBoolSp(SharedPref.SP_ISLOGIN) ?? false;

    if (isLoggedIn) {
      String? accessToken = await SharedPref.getStringSp(SharedPref.SP_KEY_ACCESS_TOKEN);
      String? teacherId = await SharedPref.getStringSp(SharedPref.SP_KEY_TEACHER_ID);
      if (accessToken != null) {
        SharedPref.accessToken = accessToken;
        print("Access Token: $accessToken");  // Corrected this line to print accessToken
        print("Teacher ID: $teacherId");  // Added this line to print teacherId

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainActivityPage()),
        );
      }
    } else {
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
    }

  }

// Call this function where you need to check the login status


  @override
  void initState() {
   Future.delayed(Duration.zero).then((value) {
      checkLoginStatus();
   });
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return
      // resizeToAvoidBottomInset: false,
      // This line prevents resizing on keyboard show
      Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Login_Background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(child: ImageIcon(AssetImage("assets/extrachildhood.png"),size: 200,color: Colors.white,)),
          SizedBox(height: 200,),
          Positioned(
            child: Align(alignment: Alignment.bottomCenter,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [const SizedBox(height: 200,),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: MediaQuery.of(context).size.height*0.33,),
                              // const SizedBox(height: 70,),
                              const Text(
                                "Login",
                                style: TextStyle(color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10,),
                              MyFormTextField(
                                controller: _emailController,
                                fillColor: Colors.grey.shade300,
                                filled: true,
                                hintText: "Enter your Email/mobile ",
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(height: 20,),
                              MyFormTextField(
                                controller: _passController,
                                fillColor: Colors.grey.shade300,
                                filled: true,
                                hintText: "Create password ",
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(height: 35,),
                              LoginButton(
                                color: const Color(0xFFFFBB12),
                                height: 45,
                                width: double.infinity,
                                borderRadius: BorderRadius.circular(10),
                                child: const Center(
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                        fontSize: 22, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                onTap: () {
                                  ApiServices().loginApi(email:_emailController.text,pass: _passController.text,reqstLogin: true).then((value) {
                                    if(value != null && value["is_error"].toString()=="false"){
                                      setState(() {
                                        SharedPref.accessToken = value['token'].toString();
                                        SharedPref.setStringSp(SharedPref.SP_KEY_ACCESS_TOKEN, value["token"].toString());
                                        SharedPref.setStringSp(SharedPref.TEACHER_NAME, value["TeacherName"].toString());
                                        SharedPref.setStringSp(SharedPref.SCHOOL_ID, value["SchoolId"].toString());
                                        SharedPref.setStringSp(SharedPref.SP_KEY_TEACHER_ID, value["TeacherId"].toString());
                                        SharedPref.setStringSp(SharedPref.TEACHER_CONTACT, value["TeacherContact"].toString());
                                        SharedPref.setBoolSp(SharedPref.SP_ISLOGIN, true);
                                      });
                                    Fluttertoast.showToast(msg: value["message"].toString());
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => MainActivityPage(),));
                                    }else{
                                      Fluttertoast.showToast(msg: value["message"].toString());
                                    }
                                    print(value.toString());
                                  });
                                },
                              ),
                              const SizedBox(height: 25,),
                              // Row(
                              //   children: [
                              //     Text(
                              //       "Want to change your password? ",
                              //       style: TextStyle(color: Colors.white, fontSize: 14),
                              //     ),
                              //     // InkWell(
                              //     //   onTap: () {
                              //     //     Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword(),));
                              //     //   },
                              //     //   child: Text(
                              //     //     "Reset Password",
                              //     //     style: TextStyle(
                              //     //       color: Color(0xFFFFBB12),
                              //     //       fontSize: 14,
                              //     //       decoration: TextDecoration.underline,
                              //     //       decorationColor: Color(0xFFFFBB12),
                              //     //     ),
                              //     //   ),
                              //     // ),
                              //   ],
                              // ),
                              SizedBox(height: 3,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Forgot your Old Password? ",
                                    style: TextStyle(color: Colors.white, fontSize: 14),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      // Add your logic for contacting support
                                    },
                                    child: const Text(
                                      "Contact Support",
                                      style: TextStyle(
                                        color: Color(0xFFFFBB12),
                                        fontSize: 14,
                                        decoration: TextDecoration.underline,
                                        decorationColor: Color(0xFFFFBB12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
    );
  }}