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
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey),borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                        MyFormTextField(
                            controller: _currentPass,
                            fillColor: Colors.white38,filled: true,hintText: "Enter current password",textAlign: TextAlign.start),
                        const SizedBox(height: 25),
                        MyFormTextField(
                            controller: _newPass,
                            fillColor: Colors.white38,filled: true,hintText: "Enter new password  ",textAlign: TextAlign.start),
                        const SizedBox(height: 25),
                        MyFormTextField(borderColor: Colors.grey.shade200,
                            controller: _confirmPass,
                            fillColor: Colors.white38,filled: true,hintText: "Enter confirm new password  ",textAlign: TextAlign.start),

                        const SizedBox(height: 20,),

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
                    ),)
                ),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13,vertical: 10),
                child: // ...

                LoginButton(
                  color: Color(0xFFFFBB12),
                  height: 45,
                  width: double.infinity,
                  borderRadius: BorderRadius.circular(10),
                  child: Center(child: Text("Reset Password", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                  onTap: () {
                    if (_validateInputs()) {
                      ApiServices().resetApi(
                        currentPass: _currentPass.text,
                        newPass: _newPass.text,
                        confirmPass: _confirmPass.text,
                      ).then((value) {
                        Fluttertoast.showToast(msg: value["message"]);
                        if (value != null && value["is_error"] == false) {
                          print(value);
                          Navigator.pop(context);
                          Fluttertoast.showToast(msg: value["message"]);
                        }
                      });
                    }
                  },
                )

// ...


            ),
          ],
        ),
      ),
    );


  }
  bool _validateInputs() {
    if (_currentPass.text.isEmpty || _newPass.text.isEmpty || _confirmPass.text.isEmpty) {
      Fluttertoast.showToast(msg: 'All fields are required');
      return false;
    }

    if (_newPass.text != _confirmPass.text) {
      Fluttertoast.showToast(msg: 'New password and confirm password must match');
      return false;
    }

    // Add more validation checks if needed

    return true;
  }
}
