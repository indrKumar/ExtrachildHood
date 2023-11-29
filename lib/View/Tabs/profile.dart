import 'dart:async';
import 'package:another_flushbar/flushbar.dart';
import 'package:extrachildhood/Constants/constants_helper.dart';
import 'package:extrachildhood/Constants/constcolor.dart';
import 'package:extrachildhood/Constants/sharedPrefConst.dart';
import 'package:extrachildhood/Service/apiservices.dart';
import 'package:extrachildhood/View/Aouth/login.dart';
import 'package:extrachildhood/View/passwordReset.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:flutter_flushbar/flutter_flushbar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  var teacherId;
  var teacherName;
  var schoolId;
  var contactN;
  var sectionN;
  var dob;
  var email;
  var intrest;
  var hobby;
  var specialization;
  var board;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    loadData();
  }
  bool isLoadingLog = false;
Map getP = {};

  Future<void> loadData() async {

    ApiServices().getProfile().then((value) {
    if(value["is_validUser"] == false){
      setState(() {
        SharedPref.setBoolSp(SharedPref.SP_ISLOGIN, false);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false,
        );
      });
    }
    else{
      if(value["is_error"] == false){
        setState(() {
          getP = Map.from(value);
        });
        print("Gett:::::$getP");
      }else{
        print("Data not found");
      }
    }
    });
    setState(() {
      isLoading = true;
    });

    // Wait for the getPrefs method to complete
    await getPrefs();

    setState(() {
      isLoading = false;
    });
  }


  final String whatsappNumber = "+919900243291"; // Replace with the actual WhatsApp number
  final Uri supportWhatsApp = Uri.parse("https://wa.me/919900243291");

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
  Future<void> _launchWhatsApp() async {
    var status = await Permission.phone.status;

    if (status.isGranted) {
      // Permission is granted, proceed with launching WhatsApp
      final url = "https://wa.me/$whatsappNumber";

      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } else {
      // If permission is not granted, request it from the user
      var status = await Permission.phone.request();

      // Check the status after requesting permission
      if (status.isGranted) {
        // Permission granted, proceed with launching WhatsApp
        final url = "https://wa.me/$whatsappNumber";

        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw 'Could not launch $url';
        }
      } else {
        // Permission denied, handle it accordingly
        print('Permission denied to access phone.');
      }
    }
  }


  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'extrachildhood@gmail.com',
  );
// Replace the return type with the actual type returned by getPrefs
  Future<void> getPrefs() async {
    teacherId = await SharedPref.getStringSp(SharedPref.SP_KEY_TEACHER_ID);
    teacherName = await SharedPref.getStringSp(SharedPref.TEACHER_NAME);
    contactN = await SharedPref.getStringSp(SharedPref.TEACHER_CONTACT);
    schoolId = await SharedPref.getStringSp(SharedPref.SCHOOL_ID);
    dob = await SharedPref.getStringSp(SharedPref.DOB);
    specialization = await SharedPref.getStringSp(SharedPref.SPECIALIZATION);
    email = await SharedPref.getStringSp(SharedPref.SP_KEY_USER_EMAIL);
    hobby = await SharedPref.getStringSp(SharedPref.HOBBY);
    board = await SharedPref.getStringSp(SharedPref.BOARD_ID);

    print(schoolId.toString());
    print(teacherId.toString());
    print(contactN.toString());
    print(teacherName.toString());
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: const Text("Profile",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
      ),
      body: isLoading ? ConstantsHelper.loadingIndicator() : SingleChildScrollView(
        child: Column(children: [

          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.6),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   Text("Name",style: GoogleFonts.roboto(fontSize: 15,fontWeight: FontWeight.w500),),
                  const SizedBox( width: 10,),
                  Flexible(child: Text("$teacherName",maxLines: 2,softWrap: true,style:  GoogleFonts.roboto(fontWeight: FontWeight.w600,fontSize: 16,),)),],),

                    // const SizedBox(height: 15,),
                    Divider(color: Colors.black12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     Text("Board ID",style:GoogleFonts.roboto(fontSize: 15,fontWeight: FontWeight.w500),),
                    const SizedBox(width: 10,),
                    Text("$board",style:  GoogleFonts.roboto(fontWeight: FontWeight.w600,fontSize: 16,),),
                  ],),
                    Divider(color: Colors.black12),
                    // const SizedBox(height: 15,)

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                       Text("School ID",style:GoogleFonts.roboto(fontSize: 15,fontWeight: FontWeight.w500),),
                      const SizedBox(width: 10,),
                      Text("$schoolId",style:  GoogleFonts.roboto(fontWeight: FontWeight.w600,fontSize: 16,),),
                    ],),
                    // const SizedBox(height: 10),
                    Divider(color: Colors.black12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                       Text("Teacher ID",style: GoogleFonts.roboto(fontSize: 15,fontWeight: FontWeight.w500),),
                      const SizedBox(width: 10,),
                      Text("$teacherId",style:  GoogleFonts.roboto(fontWeight: FontWeight.w600,fontSize: 16,),),
                    ],),
                    // const SizedBox(height: 15,),
                    // const SizedBox(height: 30,),


                ],),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.6),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
                borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Contact No.",style: GoogleFonts.roboto(fontSize: 15,fontWeight: FontWeight.w500),),
                        const SizedBox(width: 10,),
                        Text("+91 $contactN",style:  GoogleFonts.roboto(fontWeight: FontWeight.w600,fontSize: 16,),),
                      ],),
                    // const SizedBox(height: 15,),
                    Divider(color: Colors.black12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     Text("Email",style:GoogleFonts.roboto(fontSize: 15,fontWeight: FontWeight.w500),),
                    const SizedBox(width: 10,),
                    Text("$email",style:  GoogleFonts.roboto(fontWeight: FontWeight.w600,fontSize: 16,),),
                  ],),
                    Divider(color: Colors.black12),
                    // const SizedBox(height: 15,)

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                       Text("Specialization",style:GoogleFonts.roboto(fontSize: 15,fontWeight: FontWeight.w500),),
                      const SizedBox(width: 10,),
                      Text("$specialization",style:  GoogleFonts.roboto(fontWeight: FontWeight.w600,fontSize: 16,),),
                    ],),
                    // const SizedBox(height: 10),
                    Divider(color: Colors.black12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                       Text("Hobby",style: GoogleFonts.roboto(fontSize: 15,fontWeight: FontWeight.w500),),
                      const SizedBox(width: 10,),
                      Text("$hobby",style:  GoogleFonts.roboto(fontWeight: FontWeight.w600,fontSize: 16,),),
                    ],),
                    // const SizedBox(height: 15,),
                    Divider(color: Colors.black12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     Text("Date of Birth.",style: GoogleFonts.roboto(fontSize: 15,fontWeight: FontWeight.w500),),
                    const SizedBox(width: 10,),
                    Text("$dob",style:  GoogleFonts.roboto(fontWeight: FontWeight.w600,fontSize: 16,),),
                  ],),
                    // const SizedBox(height: 30,),


                ],),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Row(
                      children: [
                        // Icon(Icons.contact_support_outlined,size: 20),
                        // SizedBox(width: 10,),
                        Text("Tasks Info",style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                        ),),
                      ],
                    ),
                    Divider(endIndent: MediaQuery.of(context).size.width*0.62,color: Colors.black12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Pending Task",style: GoogleFonts.roboto(fontSize: 15,fontWeight: FontWeight.w500),),
                        const SizedBox(width: 10,),
                        Text(getP["PendingTaskCount"] != null ? getP["PendingTaskCount"].toString():"0",style:  GoogleFonts.roboto(fontWeight: FontWeight.w600,fontSize: 16,),),
                      ],),
                    Divider(color: Colors.black12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Completed Task",style: GoogleFonts.roboto(fontSize: 15,fontWeight: FontWeight.w500),),
                        const SizedBox(width: 10,),
                        Text(getP["CompleatedTaskCount"] != null ? getP["CompleatedTaskCount"].toString() : "0",style:  GoogleFonts.roboto(fontWeight: FontWeight.w600,fontSize: 16,),),
                      ],),  Divider(color: Colors.black12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Expired Task",style: GoogleFonts.roboto(fontSize: 15,fontWeight: FontWeight.w500),),
                        const SizedBox(width: 10,),
                        Text(getP["ExpiredTaskCount"] != null ? getP["ExpiredTaskCount"].toString() : "0",style:  GoogleFonts.roboto(fontWeight: FontWeight.w600,fontSize: 16,),),
                      ],),
                    Divider(color: Colors.black12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total Assigned Task",style: GoogleFonts.roboto(fontSize: 15,fontWeight: FontWeight.w500),),
                        const SizedBox(width: 10,),
                        Text(getP["TotalTaskAssignedCount"] != null ? getP["TotalTaskAssignedCount"].toString() : "0",style:  GoogleFonts.roboto(fontWeight: FontWeight.w600,fontSize: 16,),),
                      ],),
                  ],),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        // Icon(Icons.contact_support_outlined,size: 20),
                        // SizedBox(width: 10,),
                        Text("Ask For Assistance",style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                        ),),
                      ],
                    ),
                    const SizedBox(height: 10,),
                    GestureDetector(
                      onTap: () {
                        launch(emailLaunchUri.toString());
                      },
                      child: Container(
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400),),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.email_outlined,size: 20),
                                  SizedBox(width: 10,),
                                  Text("Email",style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500
                                  ),),
                                ],
                              ),
                              Icon(Icons.arrow_forward_ios,size: 20,)
                            ],
                          ),
                        ),
                      ),
                    ),  const SizedBox(height: 10,),
                    GestureDetector(
                      onTap: () {
                        launchUrl(supportWhatsApp, fallbackUrl: Uri.parse("https://wa.me/919900243291")); // Provide a fallback URL
                      },
                      child: Container(
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400),),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  ImageIcon(AssetImage("assets/whatsapp.png"),size: 20),
                                  SizedBox(width: 10,),
                                  Text("WhatsApp",style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500
                                  ),),
                                ],
                              ),
                              Icon(Icons.arrow_forward_ios,size: 20,)
                            ],
                          ),
                        ),
                      ),
                    ),

                  ],),
              ),
            ),
          ),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22,vertical: 5),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPassword(),));
              },
              child: Container(
                // width: 130,
                decoration: BoxDecoration(color: Helper.primaryColor,borderRadius: BorderRadius.circular(5)),
                child:  const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5,vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Change Password",style: TextStyle(fontSize: 16),),
                      SizedBox(width: 10,),
                      Icon(Icons.lock_reset_rounded,size: 25,)
                    ],
                  ),
                ),),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
            child: InkWell(
                onTap: () {
                  _showLogoutConfirmation(context);
                },
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Log Out",style: TextStyle(fontSize: 18,color: Colors.red,fontWeight: FontWeight.bold)),
                        SizedBox(width: 10,),
                        Icon(Icons.exit_to_app,weight: 30,size: 30,color: Colors.red),
                      ],
                    ),
                  ),
                )),
          ),
        ],),
      ),
    );
  }
  void _showLogoutConfirmation(BuildContext context) {
    Flushbar(
      title: 'Logout Confirmation',
      message: 'Are you sure you want to logout?',
      duration: const Duration(seconds: 10),
      flushbarStyle: FlushbarStyle.FLOATING,
      backgroundColor: Helper.primaryColor.withOpacity(0.7),
      // borderRadius: 8.0,
      margin: const EdgeInsets.all(10.0),
      icon: const Icon(
        Icons.info,
        color: Colors.white,
      ),
      mainButton: ElevatedButton(
        onPressed: () {
          setState(() {
            isLoadingLog = true;
          });
          ApiServices().logOut().then((value){
            if(value["is_error"] == false){
              setState(() {
                isLoadingLog = false;
                SharedPref.setBoolSp(SharedPref.SP_ISLOGIN, false);
              });
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
              );
              sharedPreferences.clear();
            }else{
              Future.delayed(Duration(seconds: 3)).then((value) {
                setState(() {
                  isLoadingLog = false;
                });
              });


              Fluttertoast.showToast(msg: "Something Went Wrong");
            }
          });
        },
        child:
        isLoadingLog ? ConstantsHelper.loadingIndicator():
        const Text(
          'Logout',
          style: TextStyle(color: Colors.red),
        ),
      ),
    ).show(context);
  }
}
