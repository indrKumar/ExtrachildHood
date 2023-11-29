import 'dart:async';

import 'package:extrachildhood/Constants/constants_helper.dart';
import 'package:extrachildhood/Constants/sharedPrefConst.dart';
import 'package:extrachildhood/View/passwordReset.dart';
import 'package:extrachildhood/View/Tabs/homePage.dart';
import 'package:extrachildhood/View/mainActivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

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
  TextEditingController _passController = TextEditingController();
  checkLoginStatus() async {
    bool isLoggedIn =
        await SharedPref.getBoolSp(SharedPref.SP_ISLOGIN) ?? false;

    if (isLoggedIn) {
      String? accessToken =
      await SharedPref.getStringSp(SharedPref.SP_KEY_ACCESS_TOKEN);
      String? teacherId =
      await SharedPref.getStringSp(SharedPref.SP_KEY_TEACHER_ID);
      if (accessToken != null) {
        SharedPref.accessToken = accessToken;
        print(
            "Access Token: $accessToken"); // Corrected this line to print accessToken
        print("Teacher ID: $teacherId"); // Added this line to print teacherId

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainActivityPage()),
        );
      }
    } else {
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

// Function to launch URL with fallback
  Future<void> launchUrl(Uri url, {Uri? fallbackUrl}) async {
    if (await canLaunch(url.toString())) {
      await launch(url.toString());
    } else if (fallbackUrl != null && await canLaunch(fallbackUrl.toString())) {
      await launch(fallbackUrl.toString());
    } else {
      print('Could not launch URL: $url');
    }
  }

  final Uri poneNumber = Uri.parse("tel:+91");
  final Uri whatsApp = Uri.parse("https://wa.me/919691486905");
  final Uri supportWhatsApp = Uri.parse("https://wa.me/919900243291");

  // Future<void> launchUrl(Uri url) async {
  //   if (await canLaunch(url.toString())) {
  //     await launch(url.toString());
  //   } else {
  //     print('Could not launch URL: $url');
  //   }
  // }
// Call this function where you need to check the login status
//
//   Future<void> _launchWhatsApp() async {
//     var status = await Permission.phone.status;
//
//     if (status.isGranted) {
//       // Permission is granted, proceed with launching WhatsApp
//       final whatsappNumber = "919691486905"; // Remove the '+' and any spaces
//
//       final url = "https://wa.me/$whatsappNumber";
//
//       if (await canLaunch(url)) {
//         await launch(url);
//       } else {
//         throw 'Could not launch $url';
//       }
//     } else {
//       // If permission is not granted, request it from the user
//       var status = await Permission.phone.request();
//
//       // Check the status after requesting permission
//       if (status.isGranted) {
//         // Permission granted, proceed with launching WhatsApp
//         final whatsappNumber = "+919691486905"; // Remove the '+' and any spaces
//
//         final url = "https://wa.me/$whatsappNumber";
//
//         if (await canLaunch(url)) {
//           await launch(url);
//         } else {
//           throw 'Could not launch $url';
//         }
//       } else {
//         // Permission denied, handle it accordingly
//         print('Permission denied to access phone.');
//       }
//     }
//   }

  bool isLoading = false;

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
          SizedBox(
            height: 200,
          ),
          Positioned(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 200,
                          ),
                          const Center(
                              child: ImageIcon(
                                AssetImage("assets/extrachildhood.png"),
                                size: 200,
                                color: Colors.white,
                              )),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Welcome To ExtraChildhood India’s First Integrated Media Platform For Schools",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 14),textAlign: TextAlign.center),
                              // SizedBox(
                              //   height: MediaQuery.of(context).size.height * 0.33,
                              // ),
                              const SizedBox(
                                height: 20,
                              ),// const SizedBox(height: 70,),
                              const Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              MyFormTextField(
                                controller: _emailController,
                                fillColor: Colors.grey.shade300,
                                filled: true,
                                hintText: "Enter Email Id",
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              MyFormTextField(
                                controller: _passController,
                                fillColor: Colors.grey.shade300,
                                filled: true,
                                hintText: "Enter Password ",
                                textAlign: TextAlign.start,
                              ),
                              const SizedBox(
                                height: 35,
                              ),
                              LoginButton(
                                color: const Color(0xFFFFBB12),
                                height: 45,
                                width: double.infinity,
                                borderRadius: BorderRadius.circular(10),
                                child:  Center(
                                  child: isLoading ? ConstantsHelper.loadingIndicator():Text(
                                    "Login",
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  ApiServices()
                                      .loginApi(
                                      email: _emailController.text,
                                      pass: _passController.text,
                                      reqstLogin: true)
                                      .then((value) {
                                    if (value != null &&
                                        value["is_error"].toString() == "false") {
                                      setState(() {
                                        isLoading = false;
                                        SharedPref.accessToken =
                                            value['token'].toString();
                                        SharedPref.setStringSp(
                                            SharedPref.SP_KEY_ACCESS_TOKEN,
                                            value["token"].toString());
                                        SharedPref.setStringSp(
                                            SharedPref.TEACHER_NAME,
                                            value["TeacherName"].toString());
                                        SharedPref.setStringSp(
                                            SharedPref.SCHOOL_ID,
                                            value["SchoolId"].toString());
                                        SharedPref.setStringSp(
                                            SharedPref.SP_KEY_TEACHER_ID,
                                            value["TeacherId"].toString());
                                        SharedPref.setStringSp(
                                            SharedPref.TEACHER_CONTACT,
                                            value["TeacherContact"].toString());
                                        SharedPref.setStringSp(
                                            SharedPref.BOARD_ID,
                                            value["BoardId"].toString());
                                        SharedPref.setStringSp(
                                            SharedPref.DOB,
                                            value["Dob"].toString());
                                        SharedPref.setStringSp(
                                            SharedPref.HOBBY,
                                            value["Hobby"].toString());
                                        SharedPref.setStringSp(
                                            SharedPref.SPECIALIZATION,
                                            value["Specialization"].toString());
                                        SharedPref.setStringSp(
                                            SharedPref.SP_KEY_USER_EMAIL,
                                            _emailController.text.toString());
                                        SharedPref.setBoolSp(
                                            SharedPref.SP_ISLOGIN, true);
                                      });
                                      Fluttertoast.showToast(
                                          msg: "Login Successfully");
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MainActivityPage()));
                                    } else {
                                      Future.delayed(Duration(seconds: 2), () {
                                        setState(() {
                                          isLoading = false;
                                        });
                                      });
                                      Fluttertoast.showToast(
                                          msg: "Invalid Email or Password");
                                    }
                                    print(value.toString());
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 25,
                              ),
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
                              SizedBox(
                                height: 3,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Forgot your Old Password ? ",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      launchUrl(supportWhatsApp, fallbackUrl: Uri.parse("https://wa.me/919900243291")); // Provide a fallback URL

                                    },
                                    child: const Text(
                                      "Contact Support",
                                      style: TextStyle(
                                        color: Color(0xFFFFBB12),
                                        fontSize: 13,
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
  }
}
