import 'package:extrachildhood/Service/apiservices.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Widgets/buttons.dart';
import 'Widgets/textField.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _currentPass =TextEditingController();
  TextEditingController _newPass = TextEditingController();
  TextEditingController _confirmPass =TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: const Text("Reset Password",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
        actions: [
          SizedBox(width: 10,)
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height*0.3,),
                  MyFormTextField(
                      controller: _currentPass,
                      fillColor: Colors.grey.shade300,filled: true,hintText: "Enter current password",textAlign: TextAlign.start),
                  const SizedBox(height: 20),
                  MyFormTextField(
                      controller: _newPass,
                      fillColor: Colors.grey.shade300,filled: true,hintText: "Create new password  ",textAlign: TextAlign.start),
                  const SizedBox(height: 20),
                  MyFormTextField(
                      controller: _confirmPass,
                      fillColor: Colors.grey.shade300,filled: true,hintText: "Confirm password  ",textAlign: TextAlign.start),

                  const SizedBox(height: 35,),

                  // Row(
                  //   children: [
                  //     const Text("Want to change your password? ",style: TextStyle(color: Colors.white,fontSize: 14),),
                  //     InkWell(
                  //         onTap: () {
                  //         },
                  //         child: const Text("Reset Password",style: TextStyle(color: Color(0xFFFFBB12),fontSize: 14,decoration: TextDecoration.underline,decorationColor: Color(0xFFFFBB12),),)),
                  //   ],
                  // ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     const Text("Forgot your Old Password? ",style: TextStyle(color: Colors.white,fontSize: 14),),
                  //     InkWell(
                  //         onTap: () {
                  //         },
                  //         child: const Text("Contact Support",style: TextStyle(color: Color(0xFFFFBB12),fontSize: 14,decoration: TextDecoration.underline,decorationColor: Color(0xFFFFBB12),),)),
                  //   ],
                  // ),

                ],),
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 35),
        child: LoginButton(
          color: Color(0xFFFFBB12),height: 45,width: double.infinity,borderRadius: BorderRadius.circular(10),child: Center(child: Text("Reset Password",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold))),onTap: () {
          ApiServices().resetApi(currentPass: _currentPass.text,newPass: _newPass.text,confirmPass: _currentPass.text).then((value) {
            if(value != null){
              if(value["is_error"] = false){
                Navigator.pop(context);
                Fluttertoast.showToast(msg: value["message"]);
              }
            }
          });
        },),
      ),
    );


  }
}
