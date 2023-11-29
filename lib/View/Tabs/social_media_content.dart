import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Constants/constants_helper.dart';
import '../../Constants/constcolor.dart';
import '../../Constants/sharedPrefConst.dart';
import '../../Service/apiservices.dart';
import '../Aouth/login.dart';
import '../Widgets/buttons.dart';
import '../social_media_upload.dart';

class SocialMedeaContent extends StatefulWidget {
  const SocialMedeaContent({super.key});

  @override
  State<SocialMedeaContent> createState() => _SocialMedeaContentState();
}

class _SocialMedeaContentState extends State<SocialMedeaContent> {
  var teacherName;
  Future<void> getPrefs() async {
    // teacherId = await SharedPref.getStringSp(SharedPref.SP_KEY_TEACHER_ID);
    teacherName = await SharedPref.getStringSp(SharedPref.TEACHER_NAME);
  }
  // contactN = await SharedPref.getStringSp(SharedPref.TEACHER_CONTACT);
  // schoolId = await SharedPref.getStringSp(SharedPref.SCHOOL_ID);
  // dob = await SharedPref.getStringSp(SharedPref.DOB);
  // specialization = await SharedPref.getStringSp(SharedPref.SPECIALIZATION);
  // email = await SharedPref.getStringSp(SharedPref.SP_KEY_USER_EMAIL);
  // hobby = await SharedPref.getStringSp(SharedPref.HOBBY);
  // board = await SharedPref.getStringSp(SharedPref.BOARD_ID);

  // print(schoolId.toString());
  // print(teacherId.toString());
  // print(contactN.toString());
  // print(teacherName.toString());

  List<dynamic> contents = [];

  Future<void> _fetchTasks() async {
    try {
      // Fetch the first API
      final secondApiResponse = await ApiServices().getSocialMediaContent();
      if(secondApiResponse["is_validUser"] == false) {
        setState(() {
          SharedPref.setBoolSp(SharedPref.SP_ISLOGIN, false);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
          );
        });

      }else{
        if (secondApiResponse != null && secondApiResponse["content"] != null) {
          setState(() {
            isLoading = false;
            contents = List.from(secondApiResponse["content"]);
            print("Contents: ${contents[0]["Descp"]}");
          });
        } else {
          Future.delayed(Duration(seconds: 5), () {
            setState(() {
              isLoading = false;
            });
          });
          print("Error fetching first API");
        }
      }

    } catch (e) {
      print("Error: $e");
    }
  }

  //   Future<void> _fetchData() async {
  //   try {
  //     final value = await ApiServices().getContent();
  //
  //     if (value != null && value["content"] != null) {
  //       setState(() {
  //         isLoading = false;
  //         contents = List.from(value["content"]);
  //         print("Fetched data: $contents");
  //       });
  //     } else {
  //       Future.delayed(Duration(seconds: 2), () {
  //         setState(() {
  //           isLoading = false;
  //         });
  //       });
  //     }
  //   } catch (error) {
  //     print("Error fetching data: $error");
  //     // Handle the error as needed, e.g., show an error message.
  //   }
  // }

  bool isLoading = false;
  @override
  void initState() {
    getPrefs();
    setState(() {
      isLoading = true;
    });
    _fetchTasks().then((value) {});
    // _fetchData().then((value) {
    //
    // });

    // TODO: implement initState
    // _fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(
            "Uploaded Social Media",
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          // New parameter:
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: LoginButton(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SocialMediaUpload(),
                )).then((value) {setState(() {
              _fetchTasks();
            });});
          },
          height: 40,
          width: MediaQuery.of(context).size.width * 0.5,
          borderRadius: BorderRadius.circular(20),
          color: Helper.primaryColor,
          child: Center(
              child: Text(
                "Upload Social Media",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    fontWeight: FontWeight.w500),
              )),
        ),
        body:  isLoading
            ? ConstantsHelper.loadingIndicator():contents.isNotEmpty ?SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                            itemCount: contents.length,
                            // reverse: true,
                            itemBuilder: (context, index) {
                  // print(contents[index]['darftStatus']);
                  // String videoUrl = 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';
                  // Initialize the video player controller
              
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                    child: GestureDetector(
                      onTap: () {
                        // contents[index]['darftStatus'].toString() == "1" ? Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        //     UploadContentPage(
                        //       filename: contents[index]['FileName'],
                        //       caption: contents[index]["Caption"],
                        //       taskType: contents[index]["FileType"],
                        //       taskid: contents[index]["TaskId"],
                        //       creator: contents[index]["TaskFor"].toString(),
                        //       contentTags: contents[index]["Tags"].toString(),
                        //       contentId: contents[index]["id"],
                        //       // taskSubject: contents[index]["taskSubject"].toString(),
                        //
                        //     ),)):Null;
                      },
                      child: Column(children: [
                        Card(
                          color: Colors.white,
                          elevation: 0.5,
                          shape: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey.shade200),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      contents[index]["Title"] != null ? Row(
                                        children: [
                                          const Text(
                                            "Title : ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13),
                                          ),
                                          Flexible(
                                              child: Text(
                                                " ${contents[index]["Title"] ?? " Type is not define"}",
                                                style: const TextStyle(
                                                    color: Color(0xFF545454),
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 12),
                                              )),
                                        ],
                                      ):SizedBox(),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "#Tags : ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13),
                                          ),
                                          Flexible(
                                              child: Text(
                                                "${contents[index]["Tags"] ?? ""}",
                                                style: TextStyle(
                                                    color: Color(0xFF545454),
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 12),
                                              )),
                                        ],
                                      ),
                                      // Row
                                      //   (crossAxisAlignment: CrossAxisAlignment.start,
                                      //   children: [
                                      //     const Text("Theme : ",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 13),),
                                      //     Flexible(child: Text("${matchedTasks[index]["ProjectSubject"] ?? ""}",style: TextStyle(color: Color(0xFF545454),fontWeight: FontWeight.w300,fontSize: 12),)),
                                      //   ],),
                                      Row(
                                        children: [
                                          const Text(
                                            "Status : ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13),
                                          ),
                                          Flexible(
                                              child: Text(
                                                " ${contents[index]["Status"] ?? ''}",
                                                style: const TextStyle(
                                                    color: Color(0xFF545454),
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 12),
                                              )),
                                        ],
                                      ),
              
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Description : ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13),
                                          ),
                                          Flexible(
                                              child: Text(
                                                "${contents[index]["Descp"] ?? ""}",
                                                style: TextStyle(
                                                    color: Color(0xFF545454),
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 12),
                                              )),
                                        ],
                                      ),
                                      //                       Row(
                                      //                         children: [
                                      //                           const Text(
                                      //                             "Submitted on : ",
                                      //                             style: TextStyle(
                                      //                                 fontWeight: FontWeight.w500,
                                      //                                 fontSize: 13),
                                      //                           ),
                                      //                           Flexible(
                                      //                             child: Text(
                                      // contents[index]
                                      //                               ["submitDate"]
                                      //                                   .toString(),
                                      //                               // "${content?["submitDate"] != null && content!["submitDate"] is String && content!["submitDate"].isNotEmpty
                                      //                               //     ? DateFormat("yyyy-MM-dd").format(DateFormat("yyyyMMdd").parse(content!["submitDate"].toString()))
                                      //                               //     : 'N/A'}",
                                      //                               style: const TextStyle(
                                      //                                   color: Color(0xFF545454),
                                      //                                   fontWeight: FontWeight.w300,
                                      //                                   fontSize: 12),
                                      //                             ),
                                      //                           ),
                                      //                         ],
                                      //                       ),
                                      contents[index]["publishedDate"] != null &&
                                          contents[index]["publishedDate"]
                                              .toString()
                                              .isNotEmpty
                                          ? Row(
                                        children: [
                                          const Text(
                                            "Published on : ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13),
                                          ),
                                          Flexible(
                                              child: Text(
                                                " ${contents[index]["publishedDate"]}",
                                                style: TextStyle(
                                                    color: Color(0xFF545454),
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 12),
                                              )),
                                        ],
                                      )
                                          : SizedBox(),
                                      Row(
                                        children: [
                                          const Text(
                                            "Uploaded By : ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13),
                                          ),
                                          Flexible(
                                              child: Text(
                                                " ${teacherName ?? ''}",
                                                style: TextStyle(
                                                    color: Color(0xFF545454),
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 12),
                                              )),
                                        ],
                                      ),
                                      // Row(
                                      //   crossAxisAlignment: CrossAxisAlignment.start,
                                      //   children: [
                                      //     const Text(
                                      //       "Caption : ",
                                      //       style: TextStyle(
                                      //           fontWeight: FontWeight.w500,
                                      //           fontSize: 13),
                                      //     ),
                                      //     Flexible(
                                      //         child: Text(
                                      //           " ${contents[index]["Caption"] ?? ''}",
                                      //           style: TextStyle(
                                      //               color: Color(0xFF545454),
                                      //               fontWeight: FontWeight.w300,
                                      //               fontSize: 12),
                                      //         )),
                                      //   ],
                                      // ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          // print(matchedTasks[index]["imgUrl"].toString());
                                          launchUrl(
                                              Uri.parse(contents[index]["FIleLink"]),
                                              mode: LaunchMode.externalApplication);
                                          // launchUrl(Uri.parse(matchedTasks[index]["imgUrl`"].toString()));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Helper.primaryColor,
                                              borderRadius: BorderRadius.circular(5)),
                                          child: const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 4),
                                            child: Text("View Uploaded File"),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      contents[index]["facebookLink"]
                                          .toString()
                                          .isNotEmpty &&
                                          contents[index]["facebookLink"] !=
                                              null ||
                                          contents[index]["xLink"]
                                              .toString()
                                              .isNotEmpty &&
                                              contents[index]["xLink"] != null ||
                                          contents[index]["youtubeLink"]
                                              .toString()
                                              .isNotEmpty &&
                                              contents[index]["youtubeLink"] !=
                                                  null ||
                                          contents[index]["InstaLink"]
                                              .toString()
                                              .isNotEmpty &&
                                              contents[index]["InstaLink"] != null
                                          ? Row(
                                        children: [
                                          const Text("Broadcast Links :   "),
                                          Row(
                                            children: [
                                              contents[index]["facebookLink"]
                                                  .toString()
                                                  .isNotEmpty &&
                                                  contents[index][
                                                  "facebookLink"] !=
                                                      null
                                                  ? InkWell(
                                                  onTap: () {
                                                    launchUrl(Uri.parse(
                                                        contents[index][
                                                        "facebookLink"]
                                                            .toString()));
                                                  },
                                                  child: Icon(
                                                    Icons.facebook_outlined,
                                                    size: 25,
                                                    color:
                                                    Helper.primaryColor,
                                                  ))
                                                  : SizedBox(),
                                              contents[index]["youtubeLinkxLink"]
                                                  .toString()
                                                  .isNotEmpty &&
                                                  contents[index]
                                                  ["xLink"] !=
                                                      null
                                                  ? const SizedBox(
                                                width: 15,
                                              )
                                                  : SizedBox(),
                                              contents[index]["xLink"]
                                                  .toString()
                                                  .isNotEmpty &&
                                                  contents[index]
                                                  ["xLink"] !=
                                                      null
                                                  ? InkWell(
                                                  onTap: () {
                                                    launchUrl(Uri.parse(
                                                        contents[index]
                                                        ["xLink"]
                                                            .toString()));
                                                  },
                                                  child: const ImageIcon(
                                                    AssetImage(
                                                        "assets/twitter.png"),
                                                    size: 22,
                                                    color:
                                                    Colors.blueAccent,
                                                  ))
                                                  : SizedBox(),
                                              contents[index]["youtubeLink"]
                                                  .toString()
                                                  .isNotEmpty &&
                                                  contents[index]
                                                  ["youtubeLink"] !=
                                                      null
                                                  ? const SizedBox(
                                                width: 15,
                                              )
                                                  : SizedBox(),
                                              contents[index]["youtubeLink"]
                                                  .toString()
                                                  .isNotEmpty &&
                                                  contents[index]
                                                  ["youtubeLink"] !=
                                                      null
                                                  ? InkWell(
                                                onTap: () {
                                                  launchUrl(Uri.parse(
                                                      contents[index][
                                                      "youtubeLink"]
                                                          .toString()));
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          2)),
                                                  height: 18,
                                                  width: 22,
                                                  child: const Center(
                                                      child: Icon(
                                                        Icons.play_arrow,
                                                        color: Colors.white,
                                                        size: 15,
                                                      )),
                                                ),
                                              )
                                                  : SizedBox(),
                                              contents[index]["InstaLink"]
                                                  .toString()
                                                  .isNotEmpty &&
                                                  contents[index]
                                                  ["InstaLink"] !=
                                                      null
                                                  ? SizedBox(
                                                width: 15,
                                              )
                                                  : SizedBox(),
                                              contents[index]["InstaLink"]
                                                  .toString()
                                                  .isNotEmpty &&
                                                  contents[index]
                                                  ["InstaLink"] !=
                                                      null
                                                  ? InkWell(
                                                  onTap: () {
                                                    launchUrl(Uri.parse(
                                                        contents[index][
                                                        "InstaLink"]
                                                            .toString()));
                                                  },
                                                  child: const ImageIcon(
                                                    AssetImage(
                                                        "assets/instagram.png"),
                                                    size: 19,
                                                  ))
                                                  : SizedBox(),
                                            ],
                                          )
                                        ],
                                      )
                                          : SizedBox(),
                                      // contents[index]["darftStatus"].toString() ==  "1"?  const Row
                                      //   (crossAxisAlignment: CrossAxisAlignment.start,
                                      //   children: [
                                      //     Text("Save In Draft",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14),),
                                      //   ],):SizedBox(),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                contents[index]["FileType"].toString() == "Image"
                                    ? GestureDetector(
                                    onTap: () {
                                      launchUrl(Uri.parse(
                                          contents[index]["taskDoc"].toString()));
                                    },
                                    child: const Image(
                                      image: AssetImage("assets/magazine.jpg"),
                                      height: 50,
                                    ))
                                    : contents[index]["FileType"].toString() ==
                                    "Pdf"
                                    ? const Image(
                                  image:
                                  AssetImage("assets/social_media.png"),
                                  height: 70,
                                )
                                    : contents[index]["FileType"]
                                    .toString() ==
                                    "Video"
                                    ? GestureDetector(
                                  onTap: () {
                                    launchUrl(Uri.parse(
                                        contents[index]["taskDoc"]
                                            .toString()));
                                  },
                                  child: const Image(
                                    image: AssetImage(
                                        "assets/tvImg.jpeg"),
                                    height: 50,
                                  ),
                                )
                                    : contents[index]["FileType"]
                                    .toString() ==
                                    "Audio"
                                    ? GestureDetector(
                                    onTap: () {
                                      launchUrl(Uri.parse(
                                          contents[index]
                                          ["taskDoc"]
                                              .toString()));
                                    },
                                    child: const Image(
                                      image: AssetImage(
                                          "assets/radio.png"),
                                      height: 70,
                                    ))
                                    : Container(),
                                // GestureDetector(
                                //   onTap: () {
                                //     print(matchedTasks[index]["imgUrl"].toString());
                                //     launchUrl(Uri.parse(matchedTasks[index]["imgUrl"].toString()));
                                //   },
                                //   child: Container(
                                //     height: 70,
                                //     width: 70,
                                //     decoration: const BoxDecoration(
                                //         image: DecorationImage(image: AssetImage("assets/ectratran.png"))
                                //     ),
                                //   ),
                                // ),
              
                                // contents[index]["FileType"].toString() == "Magazine" || contents[index]["FileType"].toString() == "NewsPaper" ?
                                // Container(
                                //   height: 70,
                                //   width: 80,
                                //   decoration: BoxDecoration(
                                //     color: Colors.grey.shade100,
                                //     image: contents[index]["FIleLink"] != null && contents[index]["FIleLink"]!.isNotEmpty
                                //         ? DecorationImage(
                                //       image: NetworkImage("${contents[index]["FIleLink"]}"),
                                //       fit: BoxFit.fill,
                                //     )
                                //         : null, // Set image to null if URL is invalid or empty
                                //     borderRadius: BorderRadius.circular(10),
                                //   ),
                                // ) : contents[index]["FileType"].toString() == "TV" ?  Container(
                                //   height: 70,
                                //   width: 80,
                                //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                                //     color: Colors.grey.shade200,
                                //   ),
                                //   child: Center(child:Icon( Icons.play_circle),),
                                // ) :contents[index]["FileType"].toString() == "Radio" ? Image(image: const AssetImage("assets/images.jpeg"),height: 40,) : Container()
              
                                // SizedBox(
                                //   height: 50,
                                //   width: 50,
                                //   child: Center(
                                //     child: _controller.value.isInitialized
                                //         ? AspectRatio(
                                //       aspectRatio: _controller.value.aspectRatio,
                                //       child: VideoPlayer(_controller),
                                //     )
                                //         : CircularProgressIndicator(),
                                //   ),
                                //
                                // )
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ),
                  );
                            },
                          ),
                  SizedBox(height:40,)
                ],
              ),
            ):Align(alignment:Alignment.center,child: Center(child: const Text("You have not uploaded any content yet!"))));
  }
}
