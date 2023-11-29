import 'package:extrachildhood/Constants/constcolor.dart';
import 'package:extrachildhood/View/uploadcontent.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Constants/constants_helper.dart';
import '../../Constants/sharedPrefConst.dart';
import '../../Service/apiservices.dart';
import '../Aouth/login.dart';

class TaskTab extends StatefulWidget {
  const TaskTab({super.key});

  @override
  State<TaskTab> createState() => _TaskTabState();
}

class _TaskTabState extends State<TaskTab> {
  List<Map<String, dynamic>> apiResponse = [
    // Your API response data here
  ];
  // Map<String, Map<String, dynamic>> tasks = {};
  // List<dynamic> task = [];

  bool isLoading = false;
  // Future<void> _fetchTasks() async {
  //   ApiServices().getTaskApi().then((value) {
  //     if (value != null && value["tasks"] != null) {
  //       setState(() {
  //         isLoading = false;
  //       });
  //       setState(() {
  //         tasks = Map<String, Map<String, dynamic>>.from(value["tasks"]);
  //         var taskId = value["TaskId"];
  //         print(taskId);
  //         print("::::::>>>>>>>$tasks");
  //         print(value);
  //       });
  //     } else {
  //       Future.delayed(Duration(seconds: 2), () {
  //         setState(() {
  //           isLoading = false;
  //         });
  //       });
  //     }
  //     print(value);
  //   });
  // }
  List<dynamic> matchedTasks = [];
  List<dynamic> unmatchedTasks = [];

  String htmlContent =
      "<p><strong>Descp Ck Editor</strong></p>\r\n\r\n<p>&nbsp;</p>\r\n\r\n<h2 style=\"font-style:italic;\"><strong>Welcome to ExtraChildhood</strong></h2>\r\n";

  Future<void> _fetchTasks() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<dynamic> tasks = [];
      List<dynamic> contents = [];

      // Fetch the first API
      final firstApiResponse = await ApiServices().getTaskApi();
      print("FietsLL:::${firstApiResponse["is_validUser"]}");


     if(firstApiResponse["is_validUser"] == true){
       if (firstApiResponse != null && firstApiResponse["tasks"] != null) {
         setState(() {
           tasks = List.from(firstApiResponse["tasks"]);
           print("Tasks: $tasks");
         });

         // Fetch the second API
         final secondApiResponse = await ApiServices().getContent();

         if (secondApiResponse != null && secondApiResponse["content"] != null) {
           setState(() {
             isLoading = false;
             contents = List.from(secondApiResponse["content"]);
             print("Contents: $contents");
           });

           // Compare data based on TaskId
           List<dynamic> matchedTaskss = [];
           List<dynamic> unmatchedTaskss = [];
           tasks.forEach((task) {
             var taskId1 = task["TaskId"];
             int i = 0;
             // Check if there is a matching taskId in the second API response
             bool isMatched = contents.any((content) => content["TaskId"] == taskId1);
             if (isMatched) {
               matchedTaskss.add(task);
               String img = contents[i]["FIleLink"];

// Check if the index is within the bounds of the list
               for (int i = 0; i < matchedTaskss.length && i < contents.length; i++) {
                 // Insert or update the value at the "imgUrl" key
                 matchedTaskss[i]["imgUrl"] = img;
                 print("matched::::${matchedTaskss[i]["imgUrl"]}");
               }
               setState(() {
                 matchedTasks = matchedTaskss;

                 print("Matched Tasks: $matchedTaskss");
               });
             } else {
               unmatchedTaskss.add(task);
               setState(() {
                 unmatchedTasks = unmatchedTaskss;
                 print("Matched Tasks: $unmatchedTaskss");
               });
             }
           });
           // Perform actions with matched and unmatched tasks as needed
           print("Matched Tasks: $matchedTaskss");
           print("Unmatched Tasks: $unmatchedTasks");
         } else {
           setState(() {
             unmatchedTasks = List.from(firstApiResponse["tasks"]);
             setState(() {
               isLoading = false;
             });
             print(":>?>?>?>$unmatchedTasks");
           });
           print("Error fetching second API");

         }
       } else {
         Future.delayed(Duration(seconds: 5), () {
           setState(() {
             isLoading = false;
           });
         });
         print("Error fetching first API");
       }

     }else{
       setState(() {
         SharedPref.setBoolSp(SharedPref.SP_ISLOGIN, false);
         Navigator.pushAndRemoveUntil(
           context,
           MaterialPageRoute(builder: (context) => const LoginPage()),
               (route) => false,
         );
       });

     }
    } catch (e) {
      print("Error: $e");
    }
  }

  // tasks.forEach((key, task) {
  // print("::::::$task");
  // secondApiResponse["content"].forEach((secondApiTask) {
  // var secondApiTaskId = secondApiTask["TaskId"];
  // if (task != null && task.containsKey("TaskId") && task["TaskId"] == secondApiTaskId) {
  // // Task IDs match, add to matched tasks list
  // matchedTasks.add(task);
  // print("Matched Task: $task");
  // } else {
  // unmatchedTasks.add(task);
  // }
  // });
  // });

  // Sample API responses
  // Map<String, dynamic> response1 = {
  //   "is_error": false,
  //   "message": "Task available",
  //   "tasks": {
  //     "1": {
  //       "TaskId": "T003",
  //       "taskTitle": "Republic Day", /* ... */
  //     },
  //     "2": {
  //       "TaskId": "T002",
  //       "taskTitle": "New Year", /* ... */
  //     },
  //     "3": {
  //       "TaskId": "T001",
  //       "taskTitle": "Christmas", /* ... */
  //     }
  //   }
  // };
  //
  // Map<String, dynamic> response2 = {
  //   "is_error": false,
  //   "message": "Content available",
  //   "content": [
  //     {
  //       "id": "63",
  //       "TaskId": "T001",
  //       "Caption": "chrimusday", /* ... */
  //     },
  //     {
  //       "id": "64",
  //       "TaskId": "T002",
  //       "Caption": "magzine", /* ... */
  //     }
  //   ]
  // };

  // List<Map<String, dynamic>> matchingTasks = [];
  //
  // void compareTasks() {
  //   // Extract task IDs from the first response
  //   Set<String> taskIdsInResponse1 =
  //       response1['tasks'].keys.cast<String>().toSet();
  //
  //   // Filter items from the second response based on matching task IDs
  //   matchingTasks = response2['content']
  //       .where((item) => item["TaskId"] == taskIdsInResponse1.contains(item['TaskId']))
  //       .toList();
  //   print(matchingTasks);
  // }

  // void filterAndPrintList() {
  //   // Example condition: filter items with 'due_amount' not equal to 0 or null
  //   List<Map<String, dynamic>> filteredList = tasks.values
  //       .where((element) =>
  //           element['taskType'] != 'Magaziene' && element['taskType'] != null)
  //       .toList();
  //
  //   // Convert the filteredList to a Map
  //   Map<String, Map<String, dynamic>> filteredMap =
  //       Map.fromIterable(filteredList, key: (item) => item['key']);
  //
  //   // Now, filteredMap contains only the items with 'due_amount' not equal to 0 or null
  //   print("FILTERED MAP: $filteredMap");
  // }
  //
  // List<Map<String, dynamic>> apiResponseList = [
  //   // Your API response data here
  // ];

  @override
  void initState() {
    // compareTasks();
    _fetchTasks();
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
     var mediaQuery = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: Row(
            children: [
              const SizedBox(
                width: 5,
              ),
              const ImageIcon(
                AssetImage("assets/extrachildhood.png"),
                size: 60,
                color: Colors.black,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
              ),
              const Text(
                "Media Task",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          // backgroundColor: Colors.blueGrey[900],
          // bottom:   TabBar(labelStyle: TextStyle(color: Helper.primaryColor),
          //   indicatorColor: Helper.primaryColor,
          //   tabs: [
          //     Tab(
          //       text: "Pending Task",
          //     ),
          //     Tab(
          //       text: "Completed Task",
          //     ),
          //   ],
          // ),
        ),
        body:
            // children: [
            isLoading
                ? ConstantsHelper.loadingIndicator():
            unmatchedTasks.length>0 ?
                 ListView.builder(
                    // reverse: true,
                    itemCount: unmatchedTasks.length,
                    itemBuilder: (context, index) {
                      // var task = tasks.values.elementAt(index);
                      // var content = tasks[(index + 1).toString()];
                      // String videoUrl = 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';
                      // Initialize the video player controller
                      return Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UploadContentPage(
                                      taskid: unmatchedTasks[index]["TaskId"]
                                          .toString(),
                                      taskType: unmatchedTasks[index]
                                              ["taskType"]
                                          .toString(),
                                      taskSubject: unmatchedTasks[index]
                                              ["taskSubject"]
                                          .toString(),
                                      draft: "0",
                                      creator: unmatchedTasks[index]["TaskFor"]
                                          .toString(),
                                      contentTags: unmatchedTasks[index]
                                              ["contentTags"]
                                          .toString()),
                                )).then((value) {
                              setState(() {
                                unmatchedTasks.clear();
                                _fetchTasks();
                              });
                            });
                          },
                          child: Card(
                            color: Colors.white,
                            elevation: 0.5,
                            shape: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey.shade200),
                                borderRadius: BorderRadius.circular(10)),
                            child: Stack(children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 15),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                                        " ${unmatchedTasks[index]["taskType"] ?? " Type is not define"}",
                                                        style: const TextStyle(
                                                            color: Color(0xFF545454),
                                                            fontWeight: FontWeight.w300,
                                                            fontSize: 12),
                                                      )),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 1,
                                              ),Row(
                                                children: [
                                                  const Text(
                                                    "Task For : ",
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 13),
                                                  ),
                                                  Flexible(
                                                      child: Text(
                                                        " ${unmatchedTasks[index]["TaskFor"] ?? " Type is not define"}",
                                                        style: TextStyle(
                                                            color: Color(0xFF545454),
                                                            fontWeight: FontWeight.w300,
                                                            fontSize: 12),
                                                      )),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 1,
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
                                                    "${unmatchedTasks[index]["TaskId"] ?? ""}",
                                                    style: TextStyle(
                                                        color: Color(0xFF545454),
                                                        fontWeight: FontWeight.w300,
                                                        fontSize: 12),
                                                  )),
                                                ],
                                              ),
                                              // SizedBox(
                                              //   height: 1,
                                              // ),
                                              // const SizedBox(
                                              //   height: 15,
                                              // ),
                                              // unmatchedTasks[index]
                                              //                 ["facebookLink"] !=
                                              //             null ||
                                              //         unmatchedTasks[index]
                                              //                 ["xLink"] !=
                                              //             null ||
                                              //         unmatchedTasks[index]
                                              //                 ["youtubeLink"] !=
                                              //             null ||
                                              //         unmatchedTasks[index]
                                              //                 ["InstaLink"] !=
                                              //             null
                                              //     ? const Row(
                                              //         children: [
                                              //           Text("Links:   "),
                                              //         ],
                                              //       )
                                              //     : const SizedBox()
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),

                                        // GestureDetector(
                                        //   onTap: () {
                                        //     unmatchedTasks[index]["taskDoc"]
                                        //                 .toString()
                                        //                 .isNotEmpty &&
                                        //             unmatchedTasks[index]
                                        //                     ["taskDoc"] !=
                                        //                 null
                                        //         ? launchUrl(Uri.parse(
                                        //             unmatchedTasks[index]["taskDoc"]
                                        //                 .toString()))
                                        //         : null;
                                        //   },
                                        //   child: Container(
                                        //     height: 70,
                                        //     width: 70,
                                        //     decoration: const BoxDecoration(
                                        //         image: DecorationImage(
                                        //             image: AssetImage(
                                        //                 "assets/ectratran.png"))),
                                        //   ),
                                        // ),
                                        unmatchedTasks[index]["taskType"].toString() == "Magazine"?
                                        GestureDetector(
                                          onTap: () {
                                            launchUrl(Uri.parse(unmatchedTasks[index]["taskDoc"].toString()));
                                          },
                                          child: const Image(
                                            image: AssetImage("assets/magazine.jpg"),height: 60, // Provide a placeholder image or handle the case when "taskDoc" is null or empty
                                          ),
                                        )
                                            :  unmatchedTasks[index]["taskType"]
                                            .toString() ==
                                            "Social Media"
                                            ?const Image(
                                          image: AssetImage(
                                              "assets/social_media.png"),
                                          height: 70,
                                        ):unmatchedTasks[index]["taskType"].toString() == "Social Media"?  const Image(image: AssetImage("assets/social_media.png"),height: 70,) :unmatchedTasks[index]["taskType"].toString() == "Newspaper" ? const Image(image: AssetImage("assets/newspaper.jpeg"),height: 50,): unmatchedTasks[index]["taskType"].toString() == "TV" ?  GestureDetector(onTap: () {
                                          launchUrl(Uri.parse(unmatchedTasks[index]["taskDoc"].toString()));
                                        },
                                          child:const Image(image: AssetImage("assets/tvImg.jpeg"),height: 65,),
                                        ) :
                                        unmatchedTasks[index]["taskType"].toString() == "Radio" ? GestureDetector(
                                            onTap: () {
                                              launchUrl(Uri.parse(unmatchedTasks[index]["taskDoc"].toString()));
                                            },
                                            child: const Image(image: AssetImage("assets/radio.png"),height: 55,)) : Container(),

                                        // Container(
                                        //   height: 70,
                                        //   width: 80,
                                        //   decoration: BoxDecoration(
                                        //     color: Colors.grey.shade100,
                                        //     image: unmatchedTasks[index]["taskType"] != null &&
                                        //         unmatchedTasks[index]["taskType"].isNotEmpty
                                        //         ? DecorationImage(
                                        //       image: NetworkImage(
                                        //           "${unmatchedTasks[index]["taskDoc"]}"),
                                        //       fit: BoxFit.fill,
                                        //     )
                                        //         : null, // Set image to null if URL is invalid or empty
                                        //     borderRadius:
                                        //     BorderRadius.circular(10),
                                        //   ),
                                        // )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Task Name : ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13),
                                        ),
                                        Flexible(
                                            child: Text(
                                              "${unmatchedTasks[index]["taskTitle"] ?? ""}",
                                              style:const TextStyle(
                                                  color: Color(0xFF545454),
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 12),
                                            )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 1,
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Theme : ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13),
                                        ),
                                        Flexible(
                                            child: Text(
                                              " ${unmatchedTasks[index]["taskSubject"] ?? " Type is not define"}",
                                              style: TextStyle(
                                                  color: Color(0xFF545454),
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 12),
                                            )),
                                      ],
                                    ),
                                    // Row(
                                    //   children: [
                                    //     const Text(
                                    //       "Start Date : ",
                                    //       style: TextStyle(
                                    //           fontWeight:
                                    //           FontWeight.w500,
                                    //           fontSize: 13),
                                    //     ),
                                    //     Flexible(
                                    //       child: Text(
                                    //         unmatchedTasks[index]["StartDate"]
                                    //             .toString(),
                                    //         // "${content?["submitDate"] != null && content!["submitDate"] is String && content!["submitDate"].isNotEmpty
                                    //         //     ? DateFormat("yyyy-MM-dd").format(DateFormat("yyyyMMdd").parse(content!["submitDate"].toString()))
                                    //         //     : 'N/A'}",
                                    //         style: const TextStyle(
                                    //             color:
                                    //             Color(0xFF545454),
                                    //             fontWeight:
                                    //             FontWeight.w300,
                                    //             fontSize: 12),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    Row(
                                      children: [
                                        const Text(
                                          "End Date : ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13),
                                        ),
                                        Flexible(
                                          child: Text(
                                            unmatchedTasks[index]
                                            ["DueDate"]
                                                .toString(),
                                            // "${content?["submitDate"] != null && content!["submitDate"] is String && content!["submitDate"].isNotEmpty
                                            //     ? DateFormat("yyyy-MM-dd").format(DateFormat("yyyyMMdd").parse(content!["submitDate"].toString()))
                                            //     : 'N/A'}",
                                            style: const TextStyle(
                                                color: Colors.red,
                                                fontWeight:
                                                FontWeight.w300,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Row(
                                    //   children: [
                                    //     Text(
                                    //       "Added Date on:",
                                    //       style: TextStyle(
                                    //           fontWeight:
                                    //           FontWeight.w500,
                                    //           fontSize: 13),
                                    //     ),
                                    //     Flexible(
                                    //         child: Text(
                                    //           " ${unmatchedTasks[index]["AddedDate"] ?? "Under Review"}",
                                    //           style: TextStyle(
                                    //               color: Color(0xFF545454),
                                    //               fontWeight:
                                    //               FontWeight.w300,
                                    //               fontSize: 12),
                                    //         )),
                                    //   ],
                                    // ),
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Description : ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13),
                                        ),
                                        Flexible(
                                            child: Text(
                                              " ${unmatchedTasks[index]?["taskDescp"] ?? ''}",
                                              style: TextStyle(
                                                  color: Color(0xFF545454),
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 12),
                                            )),
                                      ],
                                    ),

                                    // const SizedBox(
                                    //   height: 3,
                                    // ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                               Text(
                                                "Links : ",
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.w500,
                                                    fontSize: mediaQuery*0.035),
                                              ),
                                              // SizedBox(width: 10,),
                                              Row(
                                                children: [
                                                  TextButton(
                                                      onPressed: () {
                                                        launchUrl(Uri.parse(
                                                            unmatchedTasks[
                                                            index]
                                                            [
                                                            "taskDoc"]
                                                                .toString()));
                                                      },
                                                      child: Text(
                                                        "Task Doc",
                                                        style: GoogleFonts.roboto(decoration: TextDecoration.underline),)),
                                                  Container(
                                                    height: 20,
                                                    color: Colors.black38,
                                                    width: 1.5,
                                                  ),
                                                  TextButton(
                                                      onPressed: () {
                                                        launchUrl(Uri.parse(
                                                            unmatchedTasks[
                                                            index]
                                                            [
                                                            "TaskRefrlLink"]
                                                                .toString()));
                                                      },
                                                      child: Text(
                                                        "Help Link",
                                                        style: GoogleFonts.roboto(decoration: TextDecoration.underline),)),
                                                ],
                                              ),
                                              // Flexible(
                                              //     child: GestureDetector(
                                              //       onTap: () {
                                              //         launchUrl(Uri.parse(unmatchedTasks[index]["TaskRefrlLink"].toString()));
                                              //       },
                                              //       child:  Card(
                                              //           color: Helper.primaryColor,
                                              //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3),side: BorderSide(color: Helper.primaryColor.withOpacity(0.4))),
                                              //         child: const Padding(
                                              //           padding: EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                                              //           child: Text(
                                              //             "View",
                                              //             // " ${unmatchedTasks[index]["TaskRefrlLink"] ?? " Type is not define"}",
                                              //             style: TextStyle(
                                              //                 color: Colors.black,
                                              //                 fontWeight:
                                              //                 FontWeight.w500,
                                              //                 fontSize: 13,
                                              //                 // decoration: TextDecoration.underline,
                                              //                 // decorationColor: Colors.black,
                                              //
                                              //             ),
                                              //           ),
                                              //         ),
                                              //       ),
                                              //     )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                  ],
                                ),
                              ),

                              Positioned(
                                bottom: 5,
                                right: 10,
                                child: Row(
                                  children: [
                                    Card(
                                      color: Helper.primaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          side: BorderSide(
                                              color: Helper.primaryColor
                                                  .withOpacity(0.4))),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => UploadContentPage(
                                                    taskid:
                                                        unmatchedTasks[index]
                                                                ["TaskId"]
                                                            .toString(),
                                                    taskType:
                                                        unmatchedTasks[index]
                                                                ["taskType"]
                                                            .toString(),
                                                    taskSubject:
                                                        unmatchedTasks[index]
                                                                ["taskSubject"]
                                                            .toString(),
                                                    draft: "0",
                                                    creator:
                                                        unmatchedTasks[index]
                                                                ["TaskFor"]
                                                            .toString(),
                                                    contentTags:
                                                        unmatchedTasks[index]
                                                                ["contentTags"]
                                                            .toString()),
                                              )).then((value) {
                                            // setState(() {
                                            //   isLoading = true;
                                            // });
                                            unmatchedTasks.clear();
                                            setState(() {
                                              // Call _fetchTasks to update the data
                                              _fetchTasks();
                                            });
                                          }); // Handle the upload action
                                        },
                                        child:  Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 7, vertical: 4),
                                          child: Text(
                                            "Upload Content",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: mediaQuery*0.035,
                                              color: Colors.black,
                                              // decoration: TextDecoration.underline,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        ),
                      );
                    },
                  ):Center(child: const Text("No pending task found !")),

        // isLoading
        //     ? ConstantsHelper.loadingIndicator()
        //     : matchedTasks.isNotEmpty
        //     ? ListView.builder(
        //   // reverse: true,
        //   itemCount: matchedTasks.length,
        //   itemBuilder: (context, index) {
        //     // int index = 0; // Replace with the desired index
        //             // var content = tasks[(index + 1).toString()];
        //     // String videoUrl = 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';
        //     // Initialize the video player controller
        //     return Padding(
        //       padding: const EdgeInsets.symmetric(
        //           horizontal: 13, vertical: 10),
        //       child: GestureDetector(
        //         onTap: () {
        //           // Navigator.push(
        //           //     context,
        //           //     MaterialPageRoute(
        //           //       builder: (context) => UploadContentPage(
        //           //           taskid: matchedTasks[index]["TaskId"].toString(),
        //           //           taskType:
        //           //           matchedTasks[index]["taskType"].toString(),
        //           //           taskSubject:
        //           //           matchedTasks[index]["taskSubject"].toString(),
        //           //           draft: "0",
        //           //           creator:
        //           //           matchedTasks[index]["TaskFor"].toString(),
        //           //           contentTags: matchedTasks[index]["contentTags"]
        //           //               .toString()),
        //           //     ));
        //         },
        //         child: Card(
        //           color: Colors.white,
        //           elevation: 0.5,
        //           shape: OutlineInputBorder(
        //               borderSide:
        //               BorderSide(color: Colors.grey.shade200),
        //               borderRadius: BorderRadius.circular(10)),
        //           child:Stack(children: [
        //             Padding(
        //               padding: const EdgeInsets.symmetric(
        //                   horizontal: 10, vertical: 15),
        //               child: Row(
        //                 mainAxisAlignment:
        //                 MainAxisAlignment.spaceBetween,
        //                 crossAxisAlignment:
        //                 CrossAxisAlignment.start,
        //                 children: [
        //                   Expanded(
        //                     child: Column(
        //                       crossAxisAlignment:
        //                       CrossAxisAlignment.start,
        //                       children: [
        //                         Row(
        //                           crossAxisAlignment:
        //                           CrossAxisAlignment.start,
        //                           children: [
        //                             const Text(
        //                               "Title : ",
        //                               style: TextStyle(
        //                                   fontWeight:
        //                                   FontWeight.w500,
        //                                   fontSize: 13),
        //                             ),
        //                             Flexible(
        //                                 child: Text(
        //                                   "${matchedTasks[index]?["taskTitle"] ?? ""}",
        //                                   style: const TextStyle(
        //                                       color: Color(0xFF545454),
        //                                       fontWeight:
        //                                       FontWeight.w300,
        //                                       fontSize: 12),
        //                                 )),
        //                           ],
        //                         ),
        //                         Row(
        //                           children: [
        //                             const Text(
        //                               "Channel : ",
        //                               style: TextStyle(
        //                                   fontWeight:
        //                                   FontWeight.w500,
        //                                   fontSize: 13),
        //                             ),
        //                             Flexible(
        //                                 child: Text(
        //                                   " ${matchedTasks[index]["taskType"] ?? " Type is not define"}",
        //                                   style: const TextStyle(
        //                                       color: Color(0xFF545454),
        //                                       fontWeight:
        //                                       FontWeight.w300,
        //                                       fontSize: 12),
        //                                 )),
        //                           ],
        //                         ),
        //                         SizedBox(height: 1,),
        //                         Row(
        //                           children: [
        //                             const Text(
        //                               "Theme : ",
        //                               style: TextStyle(
        //                                   fontWeight:
        //                                   FontWeight.w500,
        //                                   fontSize: 13),
        //                             ),
        //                             Flexible(
        //                                 child: Text(
        //                                   " ${matchedTasks[index]["taskSubject"] ?? " Type is not define"}",
        //                                   style: TextStyle(
        //                                       color: Color(0xFF545454),
        //                                       fontWeight:
        //                                       FontWeight.w300,
        //                                       fontSize: 12),
        //                                 )),
        //                           ],
        //                         ),
        //                         Row(
        //                           children: [
        //                             const Text(
        //                               "Start Date : ",
        //                               style: TextStyle(
        //                                   fontWeight:
        //                                   FontWeight.w500,
        //                                   fontSize: 13),
        //                             ),
        //                             Flexible(
        //                               child: Text(
        //                                 matchedTasks[index]!["StartDate"]
        //                                     .toString(),
        //                                 // "${content?["submitDate"] != null && content!["submitDate"] is String && content!["submitDate"].isNotEmpty
        //                                 //     ? DateFormat("yyyy-MM-dd").format(DateFormat("yyyyMMdd").parse(content!["submitDate"].toString()))
        //                                 //     : 'N/A'}",
        //                                 style: const TextStyle(
        //                                     color:
        //                                     Color(0xFF545454),
        //                                     fontWeight:
        //                                     FontWeight.w300,
        //                                     fontSize: 12),
        //                               ),
        //                             ),
        //                           ],
        //                         ),
        //                         Row(
        //                           children: [
        //                             const Text(
        //                               "End Date : ",
        //                               style: TextStyle(
        //                                   fontWeight:
        //                                   FontWeight.w500,
        //                                   fontSize: 13),
        //                             ),
        //                             Flexible(
        //                               child: Text(
        //                                 matchedTasks[index]!["DueDate"]
        //                                     .toString(),
        //                                 // "${content?["submitDate"] != null && content!["submitDate"] is String && content!["submitDate"].isNotEmpty
        //                                 //     ? DateFormat("yyyy-MM-dd").format(DateFormat("yyyyMMdd").parse(content!["submitDate"].toString()))
        //                                 //     : 'N/A'}",
        //                                 style: const TextStyle(
        //                                     color:
        //                                     Color(0xFF545454),
        //                                     fontWeight:
        //                                     FontWeight.w300,
        //                                     fontSize: 12),
        //                               ),
        //                             ),
        //                           ],
        //                         ),
        //                         // Row(
        //                         //   children: [
        //                         //     Text(
        //                         //       "Added Date on:",
        //                         //       style: TextStyle(
        //                         //           fontWeight:
        //                         //           FontWeight.w500,
        //                         //           fontSize: 13),
        //                         //     ),
        //                         //     Flexible(
        //                         //         child: Text(
        //                         //           " ${matchedTasks[index]["AddedDate"] ?? "Under Review"}",
        //                         //           style: TextStyle(
        //                         //               color: Color(0xFF545454),
        //                         //               fontWeight:
        //                         //               FontWeight.w300,
        //                         //               fontSize: 12),
        //                         //         )),
        //                         //   ],
        //                         // ),
        //                         SizedBox(height: 2,),
        //                         Row(
        //                           crossAxisAlignment:
        //                           CrossAxisAlignment.start,
        //                           children: [
        //                             const Text(
        //                               "Description : ",
        //                               style: TextStyle(
        //                                   fontWeight:
        //                                   FontWeight.w500,
        //                                   fontSize: 13),
        //                             ),
        //                             Flexible(
        //                                 child: Text(
        //                                   " ${matchedTasks[index]?["taskDescp"] ?? ''}",
        //                                   style: const TextStyle(
        //                                       color: Color(0xFF545454),
        //                                       fontWeight:
        //                                       FontWeight.w300,
        //                                       fontSize: 12),
        //                                 )),
        //                           ],
        //                         ),
        //                         SizedBox(
        //                           height: 3,
        //                         ),
        //                         Row(
        //                           children: [
        //                             Expanded(
        //                               child: Row(
        //                                 children: [
        //                                   const Text(
        //                                     "Help link : ",
        //                                     style: TextStyle(
        //                                         fontWeight:
        //                                         FontWeight.w500,
        //                                         fontSize: 13),
        //                                   ),
        //                                   SizedBox(width: 10,),
        //                                   Flexible(
        //                                       child: GestureDetector(
        //                                         onTap: () {
        //                                           launchUrl(Uri.parse(unmatchedTasks[index]["TaskRefrlLink"].toString()));
        //                                         },
        //                                         child:  Card(
        //                                           color: Helper.primaryColor,
        //                                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3),side: BorderSide(color: Helper.primaryColor.withOpacity(0.4))),
        //                                           child: const Padding(
        //                                             padding: EdgeInsets.symmetric(horizontal: 12,vertical: 4),
        //                                             child: Text(
        //                                               "View",
        //                                               // " ${unmatchedTasks[index]["TaskRefrlLink"] ?? " Type is not define"}",
        //                                               style: TextStyle(
        //                                                 color: Colors.black,
        //                                                 fontWeight:
        //                                                 FontWeight.w500,
        //                                                 fontSize: 13,
        //                                                 // decoration: TextDecoration.underline,
        //                                                 // decorationColor: Colors.black,
        //
        //                                               ),
        //                                             ),
        //                                           ),
        //                                         ),
        //                                       )),
        //                                 ],
        //                               ),
        //                             ),
        //                           ],
        //                         ),
        //                         const  SizedBox(
        //
        //                           height: 15,
        //                         ),
        //                         matchedTasks[index]["facebookLink"] != null ||
        //                             matchedTasks[index]["xLink"] != null ||
        //                             matchedTasks[index]["youtubeLink"] !=
        //                                 null ||
        //                             matchedTasks[index]["InstaLink"] != null
        //                             ? const Row(
        //                           children: [
        //                             Text("Links :   "),
        //                           ],
        //                         )
        //                             : SizedBox()
        //                       ],
        //                     ),
        //                   ),
        //                   SizedBox(
        //                     width: 10,
        //                   ),
        //                   GestureDetector(
        //                     onTap: () {
        //                       print(matchedTasks[index]["taskDoc"].toString());
        //                       matchedTasks[index]["taskDoc"].toString().isNotEmpty && matchedTasks[index]["taskDoc"] != null?   launchUrl(Uri.parse(unmatchedTasks[index]["taskDoc"].toString())):null;
        //                     },
        //                     child: Container(
        //                       height: 70,
        //                       width: 70,
        //                       decoration: const BoxDecoration(
        //                           image: DecorationImage(image: AssetImage("assets/ectratran.png"))
        //                       ),
        //                     ),
        //                   )
        //                   // content["taskType"].toString() == "Magazine" || content["FileType"].toString() == "NewsPaper" ?
        //                   // GestureDetector(
        //                   //   onTap: () {
        //                   //     launchUrl(Uri.parse(matchedTasks[index]["taskDoc"].toString()));
        //                   //   },
        //                   //   child: Container(
        //                   //     height: 70,
        //                   //     width: 80,
        //                   //     decoration: BoxDecoration(
        //                   //       color: Colors.grey.shade100,
        //                   //       image: matchedTasks[index]["taskType"] != null &&
        //                   //           matchedTasks[index]["taskType"].isNotEmpty
        //                   //           ? DecorationImage(
        //                   //         image: NetworkImage(
        //                   //             "${matchedTasks[index]["taskDoc"]}"),
        //                   //         fit: BoxFit.fill,
        //                   //       )
        //                   //           : null, // Set image to null if URL is invalid or empty
        //                   //       borderRadius:
        //                   //       BorderRadius.circular(10),
        //                   //     ),
        //                   //   ),
        //                   // ),
        //
        //                   // Container(
        //                   //   height: 70,
        //                   //   width: 80,
        //                   //   decoration: BoxDecoration(
        //                   //     color: Colors.grey.shade100,
        //                   //     image: matchedTasks[index]["taskType"] != null &&
        //                   //         matchedTasks[index]["taskType"].isNotEmpty
        //                   //         ? DecorationImage(
        //                   //             image: NetworkImage(
        //                   //                 "${matchedTasks[index]["taskDoc"]}"),
        //                   //             fit: BoxFit.fill,
        //                   //           )
        //                   //         : null, // Set image to null if URL is invalid or empty
        //                   //     borderRadius:
        //                   //         BorderRadius.circular(10),
        //                   //   ),
        //                   // )
        //                   // : content["taskType"].toString() == "Television" ? SizedBox() : CircularProgressIndicator()
        //
        //                   // SizedBox(
        //                   //   height: 50,
        //                   //   width: 50,
        //                   //   child: Center(
        //                   //     child: _controller.value.isInitialized
        //                   //         ? AspectRatio(
        //                   //       aspectRatio: _controller.value.aspectRatio,
        //                   //       child: VideoPlayer(_controller),
        //                   //     )
        //                   //         : CircularProgressIndicator(),
        //                   //   ),
        //                   //
        //                   // )
        //                 ],
        //               ),
        //             ),
        //           // ListWheelScrollView(itemExtent: itemExtent, children: children)
        //           //   const Draggable(child: Text("data"), feedback: Column()),
        //             Positioned(
        //                 bottom: 32,
        //                 right: 10,
        //                 child: GestureDetector(
        //                   onTap: () {
        //                     print(matchedTasks[index]["imgUrl"].toString());
        //                     launchUrl(Uri.parse(matchedTasks[index]["imgUrl"].toString()), mode: LaunchMode.externalApplication);
        //                     // launchUrl(Uri.parse(matchedTasks[index]["imgUrl`"].toString()));
        //                   },
        //                   child: Container(
        //                     decoration: BoxDecoration(color: Helper.primaryColor,borderRadius: BorderRadius.circular(5)),
        //                     child: const Padding(
        //                       padding: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
        //                       child: Text("View Uploaded File"),
        //                     ),),
        //                 ))
        //
        //           ],),
        //         )
        //       ),
        //     );
        //   },
        // )
        //     : const Center(child: Text("Not Uploaded Content")
        // ),
        // ],
        // ),
      ),
    );
  }
}
// class Car {
//   String? make;
//   String? model;
//   int? year;
//   bool? isRunning;
//
//   // Constructor
//   Car(this.make, this.model, this.year) {
//     isRunning = false;
//   }
//
//   // Methods
//   void start() {
//     isRunning = true;
//     print('$year $make $model is started.');
//   }
//
//   void drive() {
//     if (isRunning!) {
//       print('$year $make $model is moving.');
//     } else {
//       print('Please start the car first.');
//     }
//   }
//
//   void stop() {
//     isRunning = false;
//     print('$year $make $model is stopped.');
//   }
// }
