import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:extrachildhood/Constants/constants_helper.dart';
import 'package:extrachildhood/Constants/sharedPrefConst.dart';
import 'package:extrachildhood/Service/apiservices.dart';
import 'package:extrachildhood/View/notifications.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:super_bullet_list/bullet_list.dart';

import 'Widgets/buttons.dart';

class UploadContentPage extends StatefulWidget {
  String? typeOfUpload;
  UploadContentPage({Key? key, this.typeOfUpload}) : super(key: key);

  @override
  State<UploadContentPage> createState() => _UploadContentPageState();
}

class _UploadContentPageState extends State<UploadContentPage> {
  FilePickerResult? result;
  String? fileName;
  PlatformFile? pickedfile;
  bool isLoading = false;
  File? fileToDisplay;

  void FickFile()async{
    try {
      setState(() {
        isLoading = true;
      });
      result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );
      if(result != null){
        fileName = result!.files.first.name;
        pickedfile = result!.files.first;
        fileToDisplay = File(pickedfile!.path.toString());
        print("file name $fileName");
        print("file picked $pickedfile");
        print("file disply $fileToDisplay");
      }
      setState(() {
        isLoading = true;
      });
    }catch (e){
      print(e);
    }
  }
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _projectSubController = TextEditingController();
  String? licencePath;
  var teacherId;
  var schoolId;
  var sectionN;
  bool _isLoading = false;

  Future<void> getPrefs() async {
    teacherId = await SharedPref.getStringSp(SharedPref.SP_KEY_TEACHER_ID);
    schoolId = await SharedPref.getStringSp(SharedPref.SCHOOL_ID);

    print(schoolId.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    getPrefs().then((value) {
      print(teacherId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          widget.typeOfUpload.toString(),
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
        ),
        actions: [
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationPage(),
                    ));
              },
              child: Icon(Icons.notifications, size: 30)),
          SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.all(15),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      icon: const Icon(
                        Icons.keyboard_arrow_down_sharp,
                      ),
                      value: selectedCourseValue1,
                      isDense: true,
                      isExpanded: true,
                      menuMaxHeight: 350,
                      items: [
                        const DropdownMenuItem(
                          value: "",
                          child: Text(
                            "Select Class ",
                            style: TextStyle(),
                          ),
                        ),
                        ...dropDownClassListData
                            .map<DropdownMenuItem<String>>((data) {
                          return DropdownMenuItem(
                            value: data['value'],
                            child: Text(data['title']),
                          );
                        }).toList(),
                      ],
                      onChanged: (newValue) {
                        setState(() {
                          selectedCourseValue1 = newValue!;
                          selectedCourseTitle1 =
                              dropDownClassListData.firstWhere(
                                  (data) => data['value'] == newValue)['title'];
                          print("HJH$selectedCourseValue1");
                          print(selectedCourseTitle1);
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              SizedBox(
                height: 50,
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.all(15),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      icon: const Icon(
                        Icons.keyboard_arrow_down_sharp,
                      ),
                      value: selectedSectionValue1,
                      isDense: true,
                      isExpanded: true,
                      menuMaxHeight: 350,
                      items: [
                        const DropdownMenuItem(
                          value: "",
                          child: Text(
                            "Select Section ",
                            style: TextStyle(),
                          ),
                        ),
                        ...dropDownSectionListData
                            .map<DropdownMenuItem<String>>((data) {
                          return DropdownMenuItem(
                            value: data['value'],
                            child: Text(data['title']),
                          );
                        }).toList(),
                      ],
                      onChanged: (newValue) {
                        setState(() {
                          selectedSectionValue1 = newValue!;
                          selectedSectionTitle1 =
                              dropDownSectionListData.firstWhere(
                                  (data) => data['value'] == newValue)['title'];

                          if (selectedSectionTitle1 == "Section A") {
                            setState(() {
                              sectionN = "A";
                            });
                            // Add your code here to handle the case when the selected value is 0
                          } else if (selectedSectionTitle1 == "Section B") {
                            setState(() {
                              sectionN = "B";
                            });
                            // Add your code here to handle the case when the selected value is 0
                          } else if (selectedSectionTitle1 == "Section C") {
                            setState(() {
                              sectionN = "C";
                            });
                            // Add your code here to handle the case when the selected value is 0
                          } else if (selectedSectionTitle1 == "Section D") {
                            setState(() {
                              sectionN = "D";
                            });
                            // Add your code here to handle the case when the selected value is 0
                          } else {
                            // Add code here for other cases if needed
                          }
                          print("SEC::::$selectedSectionValue1");
                          print(selectedSectionTitle1);
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),

              SizedBox(
                height: 50,
                child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.all(15),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      icon: const Icon(
                        Icons.keyboard_arrow_down_sharp,
                      ),
                      value: selectedCreatorValue1,
                      isDense: true,
                      isExpanded: true,
                      menuMaxHeight: 350,
                      items: [
                        const DropdownMenuItem(
                          value: "",
                          child: Text(
                            "Select Creator ",
                            style: TextStyle(),
                          ),
                        ),
                        ...dropDownCreatorData
                            .map<DropdownMenuItem<String>>((data) {
                          return DropdownMenuItem(
                            value: data['value'],
                            child: Text(data['title']),
                          );
                        }).toList(),
                      ],
                      onChanged: (newValue) {
                        setState(() {
                          selectedCreatorValue1 = newValue!;
                          selectedCreatorTitle1 =
                          dropDownCreatorData.firstWhere(
                                  (data) => data['value'] == newValue)['title'];
                          print("HJH$selectedCreatorTitle1");
                          print(selectedCreatorTitle1);
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: TextFormField(
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.name,
                  controller: _nameController,
                  // inputFormatters: inputFormatters ?? [],
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(left: 16, top: 15, bottom: 15),
                    // prefixStyle: prefixTextStyle,
                    // prefixText: prefix,
                    hintText: "Enter Student Name",
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: TextFormField(
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.name,
                  controller: _projectSubController,
                  // inputFormatters: inputFormatters ?? [],
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.only(left: 16, top: 15, bottom: 15),
                    // prefixStyle: prefixTextStyle,
                    // prefixText: prefix,
                    hintText: "Project/Subject",
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  FickFile();
                  // try {
                  //   final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                  //   final video = await ImagePicker().pickVideo(source: ImageSource.gallery);
                  //
                  //   if (widget.typeOfUpload == "NewsPaper" || widget.typeOfUpload == "Magazine") {
                  //     if (image != null) {
                  //       var file = File(image.path);
                  //
                  //       setState(() {
                  //         licencePath = image.path;
                  //         fileName = basename(file.path); // Get the file name
                  //       });
                  //
                  //       print(licencePath.toString());
                  //     }
                  //   } else if (widget.typeOfUpload == "Television") {
                  //     if (video != null) {
                  //       var file = File(video.path);
                  //
                  //       setState(() {
                  //         licencePath = video.path;
                  //         fileName = basename(file.path); // Get the file name
                  //       });
                  //
                  //       print(licencePath.toString());
                  //     }
                  //   }
                  // } catch (e) {
                  //   print("Error: $e");
                  //   Fluttertoast.showToast(msg: "Error occurred");
                  // }
                }
                ,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                       fileName == null ? Text(
                          "Upload ${widget.typeOfUpload} File",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600),
                        ):Text(
                          "$fileName",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600),
                        ),
                        Icon(
                          Icons.arrow_upward,
                          size: 24,
                          color: Colors.grey.shade600,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 160,
                child: TextField(
                  controller: _noteController,
                  textAlignVertical: TextAlignVertical.top,
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Caption',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                height: 160,
                child: TextField(
                  controller: _tagsController,
                  textAlignVertical: TextAlignVertical.top,
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: '#Tags',
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Important tips:",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SuperBulletList(isOrdered: false, items: [
                Text(
                    "Lorem ipsum dolor sit amet, consectetuer adipiscing elit.",
                    style: TextStyle(fontSize: 13)),
                Text("Aliquam tincidunt mauris eu risus.",
                    style: TextStyle(fontSize: 13)),
                Text("Vestibulum auctor dapibus neque.",
                    style: TextStyle(fontSize: 13)),
                Text("Nunc dignissim risus id metus.",
                    style: TextStyle(fontSize: 13)),
              ]),
              SizedBox(height: 20),
              const Text(
                "By Submitting the Magazine, you agrees to our",
                style: TextStyle(fontSize: 12),
              ),
              Text(
                "Terms & Conditions",
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                    fontSize: 12),
              ),
              SizedBox(
                height: 80,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        width: double.infinity,
        height: 50,
        child: Padding(
          padding: const EdgeInsets.only(left: 30),
          child: LoginButton(
            color: const Color(0xFFFFBB12),
            height: 45,
            width: double.infinity,
            borderRadius: BorderRadius.circular(10),
            child: Center(
                child:_isLoading ? ConstantsHelper.loadingIndicator() : Text(
              "Submit ${widget.typeOfUpload}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
            onTap: () {
              setState(() {
                _isLoading = true;
              });
              // Validate content type and perform specific actions
              if (widget.typeOfUpload == "NewsPaper" ||
                  widget.typeOfUpload == "Magazine") {
                _validateAndUploadImage();
              } else if (widget.typeOfUpload == "Television") {
                _validateAndUploadVideo();
              } else {
                // Handle other content types if needed
              }
              ApiServices()
                  .uploadContent(
                      schoolId: schoolId,
                      teacherId: teacherId,
                      classN: selectedCourseValue1,
                      fileLink: fileToDisplay!.path,
                      creatorName: _nameController.text,
                      caption: _noteController.text,
                      tags: _tagsController.text,
                      fileUploadType: widget.typeOfUpload,
                      section: sectionN,
                projectSubject: _projectSubController.text,
                creator: selectedCreatorTitle1

              )
                  .then((resp) {

                if (resp != null) {
                  int indexOfJson = resp.indexOf('{');
                  if (indexOfJson != -1) {
                    // setState(() {
                    //   _isLoading = false;
                    // });
                    String jsonPart = resp.substring(indexOfJson);
                    try {
                      Map<String, dynamic> resp = jsonDecode(jsonPart);
                      if (resp != null && resp['is_error'] == false) {
                        setState(() {
                          _isLoading = false;
                        });
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Fluttertoast.showToast(msg: resp['message'].toString());
                      }
                    } catch (e) {
                      setState(() {
                      _isLoading = false;
                      });
                      print('Error decoding JSON: $e');
                    }
                  } else {
                    // setState(() {
                    //   _isLoading = false;
                    // });
                    print('JSON not found in the response');
                  }
                }

                if (kDebugMode) {
                  print("::::$resp");
                }
              });
            },
          ),
        ),
      ),
    );
  }

  List dropDownClassListData = [
    {"title": "Class 1", "value": "1"},
    {"title": "Class 2", "value": "2"},
    {"title": "Class 3 ", "value": "3"},
    {"title": "Class 4 ", "value": "4"},
    {"title": "Class 5 ", "value": "5"},
    {"title": "Class 6 ", "value": "6"},
    {"title": "Class 7 ", "value": "7"},
    {"title": "Class 8 ", "value": "8"},
    {"title": "Class 9 ", "value": "9"},
    {"title": "Class 10 ", "value": "10"},
  ];
  late String selectedCourseValue1 = "";
  String selectedCourseTitle1 = ''; //
  List dropDownSectionListData = [
    {"title": "Section A", "value": "1"},
    {"title": "Section B", "value": "2"},
    {"title": "Section C ", "value": "3"},
    {"title": "Section D", "value": "4"},
  ];
  late String selectedSectionValue1 = "";
  String selectedSectionTitle1 = '';

  List dropDownCreatorData = [
    {"title": "Student", "value": "1"},
    {"title": "Teacher", "value": "2"},
    {"title": "Content Editor ", "value": "3"},
    // {"title": "Section D", "value": "4"},
  ];
  late String selectedCreatorValue1 = "";
  String selectedCreatorTitle1 = ''; //


  void _validateAndUploadImage() async {
    // ... (your existing image pick code remains the same)

    // Validate file type
    if (fileName != null && !fileName!.toLowerCase().endsWith('.jpg')) {
      Fluttertoast.showToast(msg: 'Invalid image file type.');
      setState(() {
        _isLoading = false;
      });
      return;
    }

  }

  void _validateAndUploadVideo() async {
    // ... (your existing video pick code remains the same)

    // Validate file type
    if (fileName != null && !fileName!.toLowerCase().endsWith('.mp4')) {
      Fluttertoast.showToast(msg: 'Invalid video file type.');
      setState(() {
        _isLoading = false;
      });
      return;
    }

  }

}



