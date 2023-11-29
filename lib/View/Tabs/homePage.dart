import 'package:extrachildhood/Constants/constants_helper.dart';
import 'package:extrachildhood/Constants/constcolor.dart';
import 'package:extrachildhood/Service/apiservices.dart';
import 'package:extrachildhood/View/Widgets/buttons.dart';
import 'package:extrachildhood/View/social_media_upload.dart';
import 'package:extrachildhood/View/uploadcontent.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import '../../Constants/sharedPrefConst.dart';
import '../Aouth/login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> contents = [];
  bool isLoading = false;
  List<dynamic> matchedTasks = [];
  List<dynamic> unmatchedTasks = [];

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
    Future<void> _fetchTasks() async {
    try {
      List<dynamic> tasks = [];
      List<dynamic> contents = [];

      // Fetch the first API
      final secondApiResponse = await ApiServices().getContent();
      print("FietsLL:::${secondApiResponse["is_validUser"]}");

    if(secondApiResponse["is_validUser"].toString() == "false"){
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
          // isLoading = false;
          contents = List.from(secondApiResponse["content"]);
          print("Contents: $contents");
        });

        // Fetch the second API
        final firstApiResponse = await ApiServices().getTaskApi();
        await getPrefs();
        if (firstApiResponse != null && firstApiResponse["tasks"] != null) {
          setState(() {
            tasks = List.from(firstApiResponse["tasks"]);
            print("Tasks: $tasks");
          });

          // Compare data based on TaskId
          List<dynamic> matchedTaskss = [];
          List<dynamic> unmatchedTaskss = [];

          for (var con in contents) {
            var taskId1 = con["TaskId"];
            print("TASKID::${con["TaskId"]}");

            // Find the matching task index
            int matchingTaskIndex =
            tasks.indexWhere((task) => task["TaskId"] == taskId1);
            print("IndexMatch:::::$matchingTaskIndex");
            if (matchingTaskIndex != -1) {
              String img = tasks[matchingTaskIndex]["taskDoc"];
              String taskTitle = tasks[matchingTaskIndex]["taskTitle"];
              // Create a new Map with the content properties and add "imgUrl"
              var matchedTaskWithImgUrl = Map.from(con);
              matchedTaskWithImgUrl["imgUrl"] = img;
              matchedTaskWithImgUrl["taskTitle"] = taskTitle;

              matchedTaskss.add(matchedTaskWithImgUrl);
            } else {
              unmatchedTaskss.add(con);
            }
          }

          setState(() {
            isLoading = false;
            matchedTasks = matchedTaskss;
            unmatchedTasks = unmatchedTaskss;
          });

          // Perform actions with matched and unmatched tasks as needed
          print("Matched Tasks: $matchedTaskss");
          print("Unmatched Tasks: $unmatchedTaskss");
          // } else {
          //   setState(() {
          //     unmatchedTasks = List.from(firstApiResponse["contents"]);
          //     isLoading = false;
          //     print(":>?>?>?>$unmatchedTasks");
          //   });
          //   print("Error fetching second API");
          // }
        }
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

  late VideoPlayerController _controller;

  @override
  void initState() {
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        // title: ImageIcon(AssetImage("assets/extrachildhood.png"),size: 60,color: Colors.black,),
        title: Text(
          "Uploaded Tasks",
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
        ),
        // actions:  [
        //   const ImageIcon(AssetImage("assets/icons8-share-50.png"),size: 35,),
        //   const SizedBox(width: 10,),
        //   GestureDetector(
        //       onTap: () {
        //         Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationPage()));
        //       },
        //       child: Icon(Icons.notifications,size: 35,)),
        //   const SizedBox(width: 10,)
        // ],
      ),
      body: isLoading
          ? ConstantsHelper.loadingIndicator()
          : matchedTasks.isNotEmpty
              ? ListView.builder(
                  itemCount: matchedTasks.length,
                  // reverse: true,
                  itemBuilder: (context, index) {
                    // print(contents[index]['darftStatus']);
                    // String videoUrl = 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';
                    // Initialize the video player controller

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 13, vertical: 5),
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
                                borderSide:
                                    BorderSide(color: Colors.grey.shade200),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Text(
                                              "Channel : ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13),
                                            ),
                                            Flexible(
                                                child: Text(
                                                  " ${matchedTasks[index]["FileType"] ?? " Type is not define"}",
                                                  style: const TextStyle(
                                                      color: Color(0xFF545454),
                                                      fontWeight: FontWeight.w300,
                                                      fontSize: 12),
                                                )),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Task ID : ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13),
                                            ),
                                            Flexible(
                                                child: Text(
                                              "${matchedTasks[index]["TaskId"] ?? ""}",
                                              style: TextStyle(
                                                  color: Color(0xFF545454),
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 12),
                                            )),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Task Name : ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13),
                                            ),
                                            Flexible(
                                                child: Text(
                                              "${matchedTasks[index]["taskTitle"] ?? ""}",
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
                                              " ${matchedTasks[index]["Status"] ?? ''}",
                                              style: const TextStyle(
                                                  color: Color(0xFF545454),
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 12),
                                            )),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "Submitted on : ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13),
                                            ),
                                            Flexible(
                                              child: Text(
                                                matchedTasks[index]
                                                        ["submitDate"]
                                                    .toString(),
                                                // "${content?["submitDate"] != null && content!["submitDate"] is String && content!["submitDate"].isNotEmpty
                                                //     ? DateFormat("yyyy-MM-dd").format(DateFormat("yyyyMMdd").parse(content!["submitDate"].toString()))
                                                //     : 'N/A'}",
                                                style: const TextStyle(
                                                    color: Color(0xFF545454),
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 12),
                                              ),
                                            ),
                                          ],
                                        ),
                                        matchedTasks[index]["publishedDate"] !=
                                                    null &&
                                                matchedTasks[index]
                                                        ["publishedDate"]
                                                    .toString()
                                                    .isNotEmpty
                                            ? Row(
                                                children: [
                                                  const Text(
                                                    "Published on : ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 13),
                                                  ),
                                                  Flexible(
                                                      child: Text(
                                                    " ${matchedTasks[index]["publishedDate"]}",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xFF545454),
                                                        fontWeight:
                                                            FontWeight.w300,
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
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "Caption : ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 13),
                                            ),
                                            Flexible(
                                                child: Text(
                                              " ${matchedTasks[index]["Caption"] ?? ''}",
                                              style: TextStyle(
                                                  color: Color(0xFF545454),
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 12),
                                            )),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            // print(matchedTasks[index]["imgUrl"].toString());
                                            launchUrl(
                                                Uri.parse(matchedTasks[index]
                                                    ["FIleLink"]),
                                                mode: LaunchMode
                                                    .externalApplication);
                                            // launchUrl(Uri.parse(matchedTasks[index]["imgUrl`"].toString()));
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Helper.primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
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
                                        matchedTasks[index]["facebookLink"]
                                                        .toString()
                                                        .isNotEmpty &&
                                                    matchedTasks[index]
                                                            ["facebookLink"] !=
                                                        null ||
                                                matchedTasks[index]["xLink"]
                                                        .toString()
                                                        .isNotEmpty &&
                                                    matchedTasks[index]
                                                            ["xLink"] !=
                                                        null ||
                                                matchedTasks[index]
                                                            ["youtubeLink"]
                                                        .toString()
                                                        .isNotEmpty &&
                                                    matchedTasks[index]
                                                            ["youtubeLink"] !=
                                                        null ||
                                                matchedTasks[index]["InstaLink"]
                                                        .toString()
                                                        .isNotEmpty &&
                                                    matchedTasks[index]
                                                            ["InstaLink"] !=
                                                        null
                                            ? Row(
                                                children: [
                                                  const Text("Broadcast Links :   "),
                                                  Row(
                                                    children: [
                                                      matchedTasks[index][
                                                                      "facebookLink"]
                                                                  .toString()
                                                                  .isNotEmpty &&
                                                              matchedTasks[
                                                                          index]
                                                                      [
                                                                      "facebookLink"] !=
                                                                  null
                                                          ? InkWell(
                                                              onTap: () {
                                                                launchUrl(Uri.parse(
                                                                    matchedTasks[index]
                                                                            [
                                                                            "facebookLink"]
                                                                        .toString()));
                                                              },
                                                              child: Icon(
                                                                Icons
                                                                    .facebook_outlined,
                                                                size: 25,
                                                                color: Helper
                                                                    .primaryColor,
                                                              ))
                                                          : SizedBox(),
                                                      matchedTasks[index][
                                                                      "youtubeLinkxLink"]
                                                                  .toString()
                                                                  .isNotEmpty &&
                                                              matchedTasks[
                                                                          index]
                                                                      [
                                                                      "xLink"] !=
                                                                  null
                                                          ? const SizedBox(
                                                              width: 15,
                                                            )
                                                          : SizedBox(),
                                                      matchedTasks[index]
                                                                      ["xLink"]
                                                                  .toString()
                                                                  .isNotEmpty &&
                                                              matchedTasks[
                                                                          index]
                                                                      [
                                                                      "xLink"] !=
                                                                  null
                                                          ? InkWell(
                                                              onTap: () {
                                                                launchUrl(Uri.parse(
                                                                    matchedTasks[index]
                                                                            [
                                                                            "xLink"]
                                                                        .toString()));
                                                              },
                                                              child:
                                                                  const ImageIcon(
                                                                AssetImage(
                                                                    "assets/twitter.png"),
                                                                size: 22,
                                                                color: Colors
                                                                    .blueAccent,
                                                              ))
                                                          : SizedBox(),
                                                      matchedTasks[index][
                                                                      "youtubeLink"]
                                                                  .toString()
                                                                  .isNotEmpty &&
                                                              matchedTasks[
                                                                          index]
                                                                      [
                                                                      "youtubeLink"] !=
                                                                  null
                                                          ? const SizedBox(
                                                              width: 15,
                                                            )
                                                          : SizedBox(),
                                                      matchedTasks[index][
                                                                      "youtubeLink"]
                                                                  .toString()
                                                                  .isNotEmpty &&
                                                              matchedTasks[
                                                                          index]
                                                                      [
                                                                      "youtubeLink"] !=
                                                                  null
                                                          ? InkWell(
                                                              onTap: () {
                                                                launchUrl(Uri.parse(
                                                                    matchedTasks[index]
                                                                            [
                                                                            "youtubeLink"]
                                                                        .toString()));
                                                              },
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .red,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            2)),
                                                                height: 18,
                                                                width: 22,
                                                                child: Center(
                                                                    child: Icon(
                                                                  Icons
                                                                      .play_arrow,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 15,
                                                                )),
                                                              ),
                                                            )
                                                          : SizedBox(),
                                                      matchedTasks[index][
                                                                      "InstaLink"]
                                                                  .toString()
                                                                  .isNotEmpty &&
                                                              matchedTasks[
                                                                          index]
                                                                      [
                                                                      "InstaLink"] !=
                                                                  null
                                                          ? SizedBox(
                                                              width: 15,
                                                            )
                                                          : SizedBox(),
                                                      matchedTasks[index][
                                                                      "InstaLink"]
                                                                  .toString()
                                                                  .isNotEmpty &&
                                                              matchedTasks[
                                                                          index]
                                                                      [
                                                                      "InstaLink"] !=
                                                                  null
                                                          ? InkWell(
                                                              onTap: () {
                                                                launchUrl(Uri.parse(
                                                                    matchedTasks[index]
                                                                            [
                                                                            "InstaLink"]
                                                                        .toString()));
                                                              },
                                                              child:
                                                                  const ImageIcon(
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
                                  matchedTasks[index]["FileType"].toString() ==
                                          "Magazine"
                                      ? GestureDetector(
                                          onTap: () {
                                            launchUrl(Uri.parse(
                                                matchedTasks[index]["taskDoc"]
                                                    .toString()));
                                          },
                                          child: const Image(
                                            image:
                                                AssetImage("assets/magazine.jpg"),height: 50,
                                          ))
                                      : matchedTasks[index]["FileType"]
                                                  .toString() ==
                                              "Social Media"
                                          ?const Image(
                                              image: AssetImage(
                                                  "assets/social_media.png"),
                                              height: 70,
                                            )
                                          : matchedTasks[index]["FileType"]
                                                      .toString() ==
                                                  "Newspaper"
                                              ?const Image(
                                                  image: AssetImage(
                                                      "assets/newspaper.jpeg"),
                                                  width: 50,
                                                )
                                              : matchedTasks[index]["FileType"]
                                                          .toString() ==
                                                      "TV"
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        launchUrl(Uri.parse(
                                                            matchedTasks[index]
                                                                    ["taskDoc"]
                                                                .toString()));
                                                      },
                                                      child: const Image(
                                                        image: AssetImage(
                                                            "assets/tvImg.jpeg"),
                                                        height: 50,
                                                      ),
                                                    )
                                                  : matchedTasks[index]
                                                                  ["FileType"]
                                                              .toString() ==
                                                          "Radio"
                                                      ? GestureDetector(
                                                          onTap: () {
                                                            launchUrl(Uri.parse(
                                                                matchedTasks[
                                                                            index]
                                                                        [
                                                                        "taskDoc"]
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
                )
              : const Center(child: Text("Not Uploaded Content")),

    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.3,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15,
                ),
                const Text("Select the content you want to upload"),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LoginButton(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UploadContentPage(typeOfUpload: "Magazine"),
                            )).then((value) {
                          setState(() {
                            // _fetchData();
                          });
                        });
                      },
                      borderRadius: BorderRadius.circular(25),
                      height: 43,
                      width: MediaQuery.of(context).size.width * 0.4,
                      color: Helper.primaryColor,
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Magazine"),
                              ImageIcon(AssetImage("assets/book.png"))
                            ],
                          ),
                        ),
                      ),
                    ),
                    LoginButton(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UploadContentPage(typeOfUpload: "NewsPaper"),
                            )).then((value) {
                          setState(() {
                            // _fetchData();
                          });
                        });
                      },
                      borderRadius: BorderRadius.circular(25),
                      height: 43,
                      width: MediaQuery.of(context).size.width * 0.4,
                      color: Helper.primaryColor,
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("NewsPaper"),
                              SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: ImageIcon(
                                    AssetImage("assets/microphone.png"),
                                    size: 35,
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    LoginButton(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UploadContentPage(typeOfUpload: "Radio"),
                            )).then((value) {
                          setState(() {
                            // _fetchData();
                          });
                        });
                      },
                      borderRadius: BorderRadius.circular(25),
                      height: 43,
                      width: MediaQuery.of(context).size.width * 0.4,
                      color: Helper.primaryColor,
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Radio"),
                              ImageIcon(AssetImage("assets/radio.png"))
                            ],
                          ),
                        ),
                      ),
                    ),
                    LoginButton(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UploadContentPage(typeOfUpload: "Television"),
                            )).then((value) {
                          setState(() {
                            // _fetchData();
                          });
                        });
                      },
                      width: MediaQuery.of(context).size.width * 0.4,
                      borderRadius: BorderRadius.circular(25),
                      height: 43,
                      color: Helper.primaryColor,
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Television"),
                              ImageIcon(AssetImage("assets/tv.png"))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoginButton(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  UploadContentPage(typeOfUpload: "Social"),
                            )).then((value) {
                          setState(() {
                            // _fetchData();
                          });
                        });
                      },
                      // width: MediaQuery.of(context).size.width*0.4,
                      borderRadius: BorderRadius.circular(25),
                      height: 43,
                      color: Helper.primaryColor,
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Social Media Post"),
                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: ImageIcon(
                                    AssetImage("assets/social_media.png"),
                                    size: 80,
                                  ))
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
// @override
// void dispose() {
//   _controller.dispose();
//   super.dispose();
// }
}
