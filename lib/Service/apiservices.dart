import 'dart:convert';
import 'dart:io';

import 'package:extrachildhood/Constants/sharedPrefConst.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class ApiServices{
  final String baseUrl = "http://15.168.106.169/ExtraChildhood/";

  Future<dynamic> loginApi({
    String? email,
    String? pass,
    reqstLogin,
  }) async {
    try {
      // Make sure to replace 'your_login_url' with the actual login API URL
      Response response = await post(
        Uri.parse("${baseUrl}api/loginApi.php"),
        body: {
          "reqstLogin":reqstLogin.toString(),
          "email":email,
          "pass":pass,
        }
      );
      if (response.statusCode == 200) {
        // Check if the response body is not empty
        if (response.body.isNotEmpty) {
          var data = jsonDecode(response.body);
          return data;
        } else {
          print('Error: Empty response body');
          return 'Unexpected response from the server. Please try again.';
        }
      } else {
        // Handle non-200 status codes
        print('Error: ${response.statusCode}');
        return 'Failed to perform the login. Please try again.';
      }
    } catch (e) {
      // Handle other errors, including network errors
      print('Error: $e');
      return 'An unexpected error occurred. Please try again later.';
    }
  }

  Future<dynamic> uploadContent({
    String? schoolId,
    String? teacherId,
    String? creatorName,
    String? creator,
    String? classN,
    String? section,
    String? projectSubject,
    String? caption,
    String? tags,
    // String? fileName,
    String? fileUploadType,
    String? fileLink,
    taskId,
    darftStatus,
  }) async {
    try {
      var file = File(fileLink?.toString()??'');
      //
      // var file = fileLink != null && fileLink.isNotEmpty
      //     ? File(fileLink)
      //     : File(''); // You can provide a default file path or leave it empty based on your needs

      if (!file.existsSync()) {
        file = File('');
        print('Error: File does not exist.');
        return 'File does not exist. Please check the file path.';
      }
      String fileName = basename(file.path); // Get the file name
      print(fileName);
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${baseUrl}api/uploadContentApi.php'),
      );

      request.fields.addAll({
        'SchoolId': schoolId ?? '',
        'TeacherId': teacherId ?? '',
        'CreatorName': creatorName ?? '',
        'Creator': creator ?? '',
        'Class': classN ?? '',
        'Sec': section ?? '',
        'ProjectSubject': projectSubject ?? '',
        'Caption': caption ?? '',
        'Tags': tags ?? '',
        'FileName': fileName,
        'TaskId':taskId,
        'FileType': fileUploadType ?? '',
        'darftStatus': darftStatus??"",
        'token': SharedPref.accessToken,
      });

      print("${request.fields} ${request.files} ${file.path}");
      request.files.add(
        await http.MultipartFile.fromPath('FIleLink', file.path),
      );

      var headers = {
        'Cookie': 'PHPSESSID=fullobmo2bh2umk4cf97juj35q'
      };
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        // Return the response body if needed
        return await response.stream.bytesToString();
      } else {
        // Return an error message or handle the error accordingly
        return 'Failed to upload. Status code: ${response.statusCode}';
      }
    } catch (e) {
      print('Error: $e');
      return 'An unexpected error occurred. Please try again later.';
    }
  }



  Future<dynamic> uploadSocialMedia({
    String? Title,
    String? Descp,
    String? tags,
    String? fileUploadType,
    String? fileLink,
    taskId,
  }) async {
    try {
      var file = File(fileLink?.toString()??'');
      //
      // var file = fileLink != null && fileLink.isNotEmpty
      //     ? File(fileLink)
      //     : File(''); // You can provide a default file path or leave it empty based on your needs

      if (!file.existsSync()) {
        file = File('');
        print('Error: File does not exist.');
        return 'File does not exist. Please check the file path.';
      }
      String fileName = basename(file.path); // Get the file name
      print(fileName);
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${baseUrl}api/uploadSocialMediaApi.php'),
      );

      request.fields.addAll({
        'Title': Title ?? '',
        'Descp': Descp ?? '',
        'Tags': tags ?? '',
        'FileType': fileUploadType ?? '',
        'token': SharedPref.accessToken,
      });

      print("${request.fields} ${request.files} ${file.path}");
      request.files.add(
        await http.MultipartFile.fromPath('FIleLink', file.path),
      );

      var headers = {
        'Cookie': 'PHPSESSID=fullobmo2bh2umk4cf97juj35q'
      };
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        // Return the response body if needed
        return await response.stream.bytesToString();
      } else {
        // Return an error message or handle the error accordingly
        return 'Failed to upload. Status code: ${response.statusCode}';
      }
    } catch (e) {
      print('Error: $e');
      return 'An unexpected error occurred. Please try again later.';
    }
  }


  Future<dynamic> getSocialMediaContent() async {
    try {
      // Make sure to replace 'your_login_url' with the actual login API URL
      Response response = await post(
          Uri.parse("${baseUrl}api/socialMediaContentApi.php"),
          body: {
            "token": SharedPref.accessToken,
          }
      );
      if (response.statusCode == 200) {
        // Check if the response body is not empty
        if (response.body.isNotEmpty) {
          var data = jsonDecode(response.body);
          print("content data:::::$data");
          return data;
        } else {
          print('Error: NotFound DAta');
          return 'Unexpected response from the server. Please try again.';
        }
      } else {
        // Handle non-200 status codes
        print('Error: ${response.statusCode}');
        return 'Failed to perform the login. Please try again.';
      }
    } catch (e) {
      // Handle other errors, including network errors
      print('Error: $e');
      return 'An unexpected error occurred. Please try again later.';
    }
  }



    Future<dynamic> getContent() async {
    try {
      // Make sure to replace 'your_login_url' with the actual login API URL
      Response response = await post(
        Uri.parse("${baseUrl}api/contentApi.php"),
        body: {
          "token":SharedPref.accessToken,
        }
      );
      if (response.statusCode == 200) {
        // Check if the response body is not empty
        if (response.body.isNotEmpty) {
          var data = jsonDecode(response.body);
          print("content data:::::$data");
          return data;
        } else {
          print('Error: NotFound DAta');
          return 'Unexpected response from the server. Please try again.';
        }
      } else {
        // Handle non-200 status codes
        print('Error: ${response.statusCode}');
        return 'Failed to perform the login. Please try again.';
      }
    } catch (e) {
      // Handle other errors, including network errors
      print('Error: $e');
      return 'An unexpected error occurred. Please try again later.';
    }
  }

// Profile
  Future<dynamic> getProfile() async {
    try {
      // Make sure to replace 'your_login_url' with the actual login API URL
      Response response = await post(
        Uri.parse("${baseUrl}api/taskCountApi.php"),
        body: {
          "token":SharedPref.accessToken,
        }
      );
      if (response.statusCode == 200) {
        // Check if the response body is not empty
        if (response.body.isNotEmpty) {
          var data = jsonDecode(response.body);
          print("content data:::::$data");
          return data;
        } else {
          print('Error: NotFound DAta');
          return 'Unexpected response from the server. Please try again.';
        }
      } else {
        // Handle non-200 status codes
        print('Error: ${response.statusCode}');
        return 'Failed to perform the login. Please try again.';
      }
    } catch (e) {
      // Handle other errors, including network errors
      print('Error: $e');
      return 'An unexpected error occurred. Please try again later.';
    }
  }

  Future<dynamic> getTaskApi() async {
    try {
      // Make sure to replace 'your_login_url' with the actual login API URL
      Response response = await post(
        Uri.parse("${baseUrl}api/taskApi.php"),
        body: {
          "token":SharedPref.accessToken,
        }
      );
      if (response.statusCode == 200) {
        // Check if the response body is not empty
        if (response.body.isNotEmpty) {
          var data = jsonDecode(response.body);
          print(data);
          return data;
        } else {
          print('Error: NotFound DAta');
          return 'Unexpected response from the server. Please try again.';
        }
      } else {
        // Handle non-200 status codes
        print('Error: ${response.statusCode}');
        return 'Failed to perform the login. Please try again.';
      }
    } catch (e) {
      // Handle other errors, including network errors
      print('Error: $e');
      return 'An unexpected error occurred. Please try again later.';
    }
  }

  Future<dynamic> logOut() async {
    try {
      // Make sure to replace 'your_login_url' with the actual login API URL
      Response response = await post(
          Uri.parse("${baseUrl}api/logoutApi.php"),
          body: {
            "token":SharedPref.accessToken,
          }
      );
      if (response.statusCode == 200) {
        // Check if the response body is not empty
        if (response.body.isNotEmpty) {
          var data = jsonDecode(response.body);
          return data;
        } else {
          print('Error: Empty response body');
          return 'Unexpected response from the server. Please try again.';
        }
      } else {
        // Handle non-200 status codes
        print('Error: ${response.statusCode}');
        return 'Failed to perform the login. Please try again.';
      }
    } catch (e) {
      // Handle other errors, including network errors
      print('Error: $e');
      return 'An unexpected error occurred. Please try again later.';
    }
  }

  Future<dynamic> resetApi({
    String? currentPass,
    String? newPass,
    String? confirmPass,
  }) async {
    try {
      // Make sure to replace 'your_login_url' with the actual login API URL
      Response response = await post(
          Uri.parse("${baseUrl}api/updateLoginPass.php"),
          body: {
            "Oldpass":currentPass,
            "NewPass":newPass,
            "Cpass":confirmPass,
            "token":SharedPref.accessToken
          }
      );
      if (response.statusCode == 200) {
        // Check if the response body is not empty
        if (response.body.isNotEmpty) {
          var data = jsonDecode(response.body);
          return data;
        } else {
          print('Error: Empty response body');
          return 'Unexpected response from the server. Please try again.';
        }
      } else {
        // Handle non-200 status codes
        print('Error: ${response.statusCode}');
        return 'Failed to perform the login. Please try again.';
      }
    } catch (e) {
      // Handle other errors, including network errors
      print('Error: $e');
      return 'An unexpected error occurred. Please try again later.';
    }
  }
}


// class UserList{
// Future<List<UserListt>> listUser()async{
// const url = "https://billingapi.qrstaff.in/api/client";
// final uri = Uri.parse(url);
// final response = await http.get(uri,headers: {
//   'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtb2JpbGVObyI6Ijk2NDQ5MzY0NjYiLCJfaWQiOiI2NTNiYjQxZmMyMmM0YzVmYmRlNDY0Y2YiLCJpYXQiOjE3MDAxMTQ0MTYsImV4cCI6MTcwMjcwNjQxNn0.WSeFt1gwesLdekd8HGLnqCL3eg15_EpHBmyTrsDBrx8',
//   'Content-Type': 'application/json',
// });
// final body = response.body;
// final json = jsonDecode(body);
// final result = json["data"] as List<dynamic>;
// final user = result.map((e) {
//   return UserListt(
//       name: e["name"],
//       number: e["contactNo"]
//   );
// }).toList();
// return user;
// }
// }
// Future<dynamic> uploadContent({
//   String? schoolId,
//   String? teacherId,
//   String? creatorName,
//   String? creator,
//   String? classN,
//   String? section,
//   String? projectSubject,
//   String? caption,
//   String? tags,
//   String? fileUploadType,
//   String? fileLink,
//   String? fileName,
//   taskId,
//   darftStatus,
// }) async {
//   try {
//     var file = File(fileLink?.toString()??'');
//     //
//     // var file = fileLink != null && fileLink.isNotEmpty
//     //     ? File(fileLink)
//     //     : File(''); // You can provide a default file path or leave it empty based on your needs
//
//     if (!file.existsSync()) {
//       file = File('');
//       print('Error: File does not exist.');
//       return 'File does not exist. Please check the file path.';
//     }
//     //
//     // if (!file.existsSync()) {
//     //   file = File('');
//     //   print('Error: File does not exist.');
//     //   return 'File does not exist. Please check the file path.';
//     // }
//     var request = http.MultipartRequest(
//       'POST',
//       Uri.parse('${baseUrl}api/uploadContentApi.php'),
//     );
//
//     request.fields.addAll({
//       'SchoolId': schoolId ?? '',
//       'TeacherId': teacherId ?? '',
//       'CreatorName': creatorName ?? '',
//       'Creator': creator ?? '',
//       'Class': classN ?? '',
//       'Sec': section ?? '',
//       'ProjectSubject': projectSubject ?? '',
//       'Caption': caption ?? '',
//       'Tags': tags ?? '',
//       'FileName': fileName ?? '',
//       'TaskId': taskId,
//       'FileType': fileUploadType ?? '',
//       'darftStatus': darftStatus ?? '',
//       'token': SharedPref.accessToken,
//     });
//     if (file.path.isNotEmpty) {
//       request.files.add(
//         await http.MultipartFile.fromPath('FIleLink', file.path),
//       );
//     }
//
//
//
//     print("${request.fields} ${request.files} ${file.path}");
//     // request.files.add(
//     //   await http.MultipartFile.fromPath('FileLink', file.path),
//     // );
//
//     var headers = {
//       'Cookie': 'PHPSESSID=fullobmo2bh2umk4cf97juj35q',
//     };
//
//     request.headers.addAll(headers);
//
//     http.StreamedResponse response = await request.send();
//
//     if (response.statusCode == 200) {
//       // Read and decode the response
//       String responseBody = await response.stream.bytesToString();
//       Map<String, dynamic> respMap = jsonDecode(responseBody);
//       if (respMap['is_error'] == false) {
//         print("EXP::::$respMap");
//         return respMap;
//       } else {
//         return 'Error: ${respMap['error_message']}';
//       }
//     } else {
//       return 'Failed to upload. Status code: ${response.statusCode}';
//     }
//   } catch (e) {
//     print('Error: $e');
//     return 'An unexpected error occurred. Please try again later.';
//   }
// }