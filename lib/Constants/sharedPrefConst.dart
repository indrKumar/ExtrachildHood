import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
late SharedPreferences sharedPreferences;
class SharedPref{
  static String accessToken = "";
  static const String SP_ISLOGIN = "isLogin";

  late Size _screenSize;
  late TextTheme _textTheme;
  late Map<String, dynamic> _passedData;
  static String businessName = "Business_Name";
  static String FCMToken = "";
  static String userName = "";
  static String profileImageUrl = "";
  static String mobileNumber = "";
  static String userType = "";
  static String userEmail = "";
  static String userAddress = "";

  Constants(BuildContext context) {
    try {
      _screenSize = MediaQuery
          .of(context)
          .size;
      _passedData = ModalRoute
          .of(context)!
          .settings
          .arguments as Map<String, dynamic>;
    } catch (e) {
      // log("constant error $e");
    }
    _textTheme = Theme
        .of(context)
        .textTheme;
  }

  double get screenWidth {
    return _screenSize.width;
  }

  double get screenHeight {
    return _screenSize.height;
  }

  double get iconSize {
    return _screenSize.width;
  }

  double get appBarSize {
    return _screenSize.height;
  }

  TextTheme get textTheme {
    return _textTheme;
  }

  Map<String, dynamic> get passedData {
    return _passedData;
  }

  static Widget loadingIndicator(){
    return const Center(
        child: CircularProgressIndicator(

        )
    );
  }



  static String
  SP_KEY_USER_TYPE = "key_user_type",
      SP_KEY_ACCESS_TOKEN = "key_user_token",
      SP_KEY_IS_LOGGED_IN = "key_is_logged_in",
      SP_KEY_USER_NAME = "key_user_name",
      SP_KEY_USER_MOBILE_NUMBER="key_mobile_number",
      SP_KEY_USER_EMAIL="key_user_email",
      SP_KEY_USER_ADDRESS="key_user_address",
      SP_KEY_USER_IMAGE="key_user_image",
      SP_KEY_TEACHER_ID = "key_teacher_id",
      TEACHER_NAME = "key_teacher_name",
      SCHOOL_ID = "key_school_id",
      TEACHER_CONTACT = "key_teacher_contact";

  static setStringSp(String key, String value) async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString(key, value);
  }

  static Future<String?> getStringSp(String key) async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString(key);
  }

  static setBoolSp(String key, bool value) async{
    SharedPreferences sp = await SharedPreferences.getInstance();

    sp.setBool(key, value);
  }

  static Future<bool?> getBoolSp(String key) async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getBool(key);
  }
}