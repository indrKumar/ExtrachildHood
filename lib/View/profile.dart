import 'package:extrachildhood/Constants/constcolor.dart';
import 'package:extrachildhood/Constants/sharedPrefConst.dart';
import 'package:extrachildhood/Service/apiservices.dart';
import 'package:extrachildhood/View/Aouth/login.dart';
import 'package:extrachildhood/View/passwordReset.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flushbar/flutter_flushbar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Profile",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
        actions: [
          InkWell(
              onTap: () {
                _showLogoutConfirmation(context);
              },
              child: Icon(Icons.exit_to_app,weight: 30,size: 30,)),
          SizedBox(width: 10,)
        ],
      ),
      body: Column(children: [

        SizedBox(height: 20,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text("Teacher Nme"),
                SizedBox(height: 10,),
                Text("Avinas",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                  SizedBox(height: 30,),
                  Text("Teacher Id"),
                SizedBox(height: 10,),
                Text("SC0001_T001",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                  SizedBox(height: 30,),
                  Text("School Id"),
                SizedBox(height: 10,),
                Text("SC0001",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                  SizedBox(height: 30,),
                  Text("Contact Number"),
                SizedBox(height: 10,),
                Text("+91 2728378328",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                  SizedBox(height: 30,),

                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPassword(),));
                    },
                    child: Container(
                      width: 130,
                      decoration: BoxDecoration(color: Colors.grey.shade400,borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Password",style: TextStyle(fontSize: 16),),
                          SizedBox(width: 10,),
                          Icon(Icons.edit_sharp,size: 20,)
                        ],
                    ),
                      ),),
                  )
              ],),
            ),
          ),
        ),
        Spacer()
      ],),
    );
  }
  void _showLogoutConfirmation(BuildContext context) {
    Flushbar(
      title: 'Logout Confirmation',
      message: 'Are you sure you want to logout?',
      duration: Duration(seconds: 10),
      flushbarStyle: FlushbarStyle.FLOATING,
      backgroundColor: Helper.primaryColor,
      // borderRadius: 8.0,
      margin: EdgeInsets.all(8.0),
      icon: Icon(
        Icons.info,
        color: Colors.white,
      ),
      mainButton: ElevatedButton(
        onPressed: () {
          ApiServices().logOut().then((value){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
            SharedPref.setBoolSp(SharedPref.SP_ISLOGIN, false);
            sharedPreferences.clear();
          });
        },
        child: Text(
          'Logout',
          style: TextStyle(color: Colors.red),
        ),
      ),
    ).show(context);
  }
}
