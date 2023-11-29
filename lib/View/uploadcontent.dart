import 'dart:convert';
import 'dart:io';
import 'package:extrachildhood/Constants/constants_helper.dart';
import 'package:extrachildhood/Constants/constcolor.dart';
import 'package:extrachildhood/Constants/sharedPrefConst.dart';
import 'package:extrachildhood/Service/apiservices.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:super_bullet_list/bullet_list.dart';

import 'Widgets/buttons.dart';

class UploadContentPage extends StatefulWidget {
  String? contentId;
  String? typeOfUpload;
  String? caption;
  String? draft;
  String? taskid;
  String? taskType;
  String? taskSubject;
  String? creator;
  String? contentTags;
  String? filename;
  UploadContentPage({Key? key,this.filename, this.typeOfUpload,this.draft,this.taskid,this.taskSubject,this.taskType,this.contentId,this.creator,this.contentTags,this.caption}) : super(key: key);

  @override
  State<UploadContentPage> createState() => _UploadContentPageState();
}

class _UploadContentPageState extends State<UploadContentPage> {
  FilePickerResult? result;
  String? fileName;
  PlatformFile? pickedfile;
  bool isLoading = false;
  File? fileToDisplay;


  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _featuringController = TextEditingController();
  final TextEditingController _projectSubController = TextEditingController();
  String? licencePath;
  var teacherId;
  var schoolId;
  var sectionN;
  bool _isLoading = false;
  bool _isLoadingDraft = false;

  Future<void> getPrefs() async {

    teacherId = await SharedPref.getStringSp(SharedPref.SP_KEY_TEACHER_ID);
    schoolId = await SharedPref.getStringSp(SharedPref.SCHOOL_ID);

    print(schoolId.toString());
  }
bool check = false;
  @override
  void initState() {
    setState(() {
      _noteController.text = widget.caption ?? "";
      _tagsController.text = widget.contentTags.toString();

    });
    print(widget.taskSubject);
    print("TASKTYPE:::::${widget.taskType}");
    print(widget.taskid);
    print(widget.draft);
    // print(widget.typeOfUpload);
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
          "Upload Content For ${widget.taskType}",
          style:  TextStyle(fontSize: MediaQuery.of(context).size.width*0.045, fontWeight: FontWeight.bold),
        ),
        // actions: [
        //   GestureDetector(
        //       onTap: () {
        //         Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //               builder: (context) => NotificationPage(),
        //             ));
        //       },
        //       child: Icon(Icons.notifications, size: 30)),
        //   SizedBox(width: 10),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               // widget.creator == "Students" ? Text("Uploading of behalf of"),
              // SizedBox(height: 7,),
              // SizedBox(
              //   height: 50,
              //   child: InputDecorator(
              //     decoration: InputDecoration(
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //       contentPadding: const EdgeInsets.all(15),
              //     ),
              //     child: DropdownButtonHideUnderline(
              //       child: DropdownButton<String>(
              //         icon: const Icon(
              //           Icons.keyboard_arrow_down_sharp,
              //         ),
              //         value: selectedStudentorValue1.isNotEmpty ? selectedStudentorValue1 : dropDownStudentorTecherData.first['value'],
              //         isDense: true,
              //         isExpanded: true,
              //         menuMaxHeight: 350,
              //         items: dropDownStudentorTecherData.map<DropdownMenuItem<String>>((data) {
              //           return DropdownMenuItem(
              //             value: data['value'],
              //             child: Text(data['title']!),
              //           );
              //         }).toList(),
              //         onChanged: (newValue) {
              //           setState(() {
              //             selectedStudentorValue1 = newValue!;
              //             selectedStudentorTitle1 =
              //             dropDownStudentorTecherData.firstWhere(
              //                     (data) => data['value'] == newValue)['title'];
              //             print("HJH$selectedStudentorValue1");
              //             print(selectedStudentorTitle1);
              //           });
              //         },
              //       ),
              //     ),
              //   ),
              // ),
              widget.creator == "Teachers" ? SizedBox() : SizedBox(height: 10,),
              widget.creator == "Students" ?SizedBox(height: 10,): SizedBox(),
              widget.creator == "Students" ?  SizedBox(
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
                          enabled: true,
                          value: "",
                          child: Text(
                            "Select Class ",
                            style: TextStyle(),
                          ),
                        ),
                        ...dropDownClassListData.map<DropdownMenuItem<String>>((data) {
                          return DropdownMenuItem(
                            value: data['value'],
                            child: Text(data['title']),
                          );
                        }).toList(),
                      ],
                      onChanged: (newValue) {
                        setState(() {
                          selectedCourseValue1 = newValue!;
                          selectedCourseTitle1 = dropDownClassListData.firstWhere(
                                (data) => data['value'] == newValue,
                            orElse: () => {'title': 'Default Title'},
                          )['title'];
                          print("HJH$selectedCourseValue1");
                          print(selectedCourseTitle1);
                        });
                      },
                    ),
                  ),
                ),
              )

            :SizedBox(),
              // selectedStudentorTitle1 == "Student" ? SizedBox(): SizedBox(height: 20),
              //
              // selectedStudentorTitle1 == "Student" ? SizedBox():  SizedBox(
              //   height: 50,
              //   child: InputDecorator(
              //     decoration: InputDecoration(
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //       contentPadding: const EdgeInsets.all(15),
              //     ),
              //     child: DropdownButtonHideUnderline(
              //       child: DropdownButton<String>(
              //         icon: const Icon(
              //           Icons.keyboard_arrow_down_sharp,
              //         ),
              //         value: selectedSectionValue1,
              //         isDense: true,
              //         isExpanded: true,
              //         menuMaxHeight: 350,
              //         items: [
              //           const DropdownMenuItem(
              //             value: "",
              //             child: Text(
              //               "Select Section ",
              //               style: TextStyle(),
              //             ),
              //           ),
              //           ...dropDownSectionListData
              //               .map<DropdownMenuItem<String>>((data) {
              //             return DropdownMenuItem(
              //               value: data['value'],
              //               child: Text(data['title']),
              //             );
              //           }).toList(),
              //         ],
              //         onChanged: (newValue) {
              //           setState(() {
              //             selectedSectionValue1 = newValue!;
              //             selectedSectionTitle1 =
              //                 dropDownSectionListData.firstWhere(
              //                     (data) => data['value'] == newValue)['title'];
              //
              //             if (selectedSectionTitle1 == "Section A") {
              //               setState(() {
              //                 sectionN = "A";
              //               });
              //               // Add your code here to handle the case when the selected value is 0
              //             } else if (selectedSectionTitle1 == "Section B") {
              //               setState(() {
              //                 sectionN = "B";
              //               });
              //               // Add your code here to handle the case when the selected value is 0
              //             } else if (selectedSectionTitle1 == "Section C") {
              //               setState(() {
              //                 sectionN = "C";
              //               });
              //               // Add your code here to handle the case when the selected value is 0
              //             } else if (selectedSectionTitle1 == "Section D") {
              //               setState(() {
              //                 sectionN = "D";
              //               });
              //               // Add your code here to handle the case when the selected value is 0
              //             } else {
              //               // Add code here for other cases if needed
              //             }
              //             print("SEC::::$selectedSectionValue1");
              //             print(selectedSectionTitle1);
              //           });
              //         },
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(height: 20),
              // SizedBox(
              //   height: 50,
              //   child: InputDecorator(
              //     decoration: InputDecoration(
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //       contentPadding: const EdgeInsets.all(15),
              //     ),
              //     child: DropdownButtonHideUnderline(
              //       child: DropdownButton<String>(
              //         icon: const Icon(
              //           Icons.keyboard_arrow_down_sharp,
              //         ),
              //         value: selectedCreatorValue1,
              //         isDense: true,
              //         isExpanded: true,
              //         menuMaxHeight: 350,
              //         items: [
              //           const DropdownMenuItem(
              //             value: "",
              //             child: Text(
              //               "Select Creator ",
              //               style: TextStyle(),
              //             ),
              //           ),
              //           ...dropDownCreatorData
              //               .map<DropdownMenuItem<String>>((data) {
              //             return DropdownMenuItem(
              //               value: data['value'],
              //               child: Text(data['title']),
              //             );
              //           }).toList(),
              //         ],
              //         onChanged: (newValue) {
              //           setState(() {
              //             selectedCreatorValue1 = newValue!;
              //             selectedCreatorTitle1 =
              //             dropDownCreatorData.firstWhere(
              //                     (data) => data['value'] == newValue)['title'];
              //             print("HJH$selectedCreatorTitle1");
              //             print(selectedCreatorTitle1);
              //           });
              //         },
              //       ),
              //     ),
              //   ),
              // ),
              // selectedStudentorTitle1 == "" ||selectedStudentorTitle1 == "Student" ?   SizedBox(height: 20):SizedBox(),
              // selectedStudentorTitle1 == "" ||selectedStudentorTitle1 == "Student" ?
              // SizedBox(
              //   height: 50,
              //   child: TextFormField(
              //     textAlign: TextAlign.start,
              //     keyboardType: TextInputType.name,
              //     controller: _nameController,
              //     // inputFormatters: inputFormatters ?? [],
              //     decoration: InputDecoration(
              //       contentPadding:
              //           EdgeInsets.only(left: 16, top: 15, bottom: 15),
              //       // prefixStyle: prefixTextStyle,
              //       // prefixText: prefix,
              //       hintText: "Enter Student Name",
              //       focusedBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10),
              //         borderSide: BorderSide(color: Colors.black),
              //       ),
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10),
              //         borderSide: BorderSide(color: Colors.grey),
              //       ),
              //     ),
              //   ),
              // ):SizedBox(),
              // SizedBox(height: 20),
              // SizedBox(
              //   height: 50,
              //   child: TextFormField(
              //     textAlign: TextAlign.start,
              //     keyboardType: TextInputType.name,
              //     controller: _projectSubController,
              //     // inputFormatters: inputFormatters ?? [],
              //     decoration: InputDecoration(
              //       contentPadding:
              //           EdgeInsets.only(left: 16, top: 15, bottom: 15),
              //       // prefixStyle: prefixTextStyle,
              //       // prefixText: prefix,
              //       hintText: "Project/Subject",
              //       focusedBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10),
              //         borderSide: BorderSide(color: Colors.black),
              //       ),
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(10),
              //         borderSide: BorderSide(color: Colors.grey),
              //       ),
              //     ),
              //   ),
              // ),

              widget.creator == "Students" ?  const SizedBox(height: 20):const SizedBox(),
              widget.creator == "Students" ?  SizedBox(

                height: 160,
                child: TextField(
                  controller:_featuringController,
                  textAlignVertical: TextAlignVertical.top,
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade400)
                  ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade400)),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Participants Name",
                    labelStyle: TextStyle(color: Colors.black),
                    alignLabelWithHint: true,
                  ),

                ),

              ):SizedBox(),
              const SizedBox(height: 20),
              SizedBox(
                height: 160,
                child: TextField(
                  controller: _noteController,
                  textAlignVertical: TextAlignVertical.top,
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade400)
                  ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade400)),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Caption",
                    labelStyle: TextStyle(color: Colors.black),
                    alignLabelWithHint: true,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 160,
                child: TextField(
                  readOnly: true,
                  controller: _tagsController,
                  textAlignVertical: TextAlignVertical.top,
                  maxLines: null,
                  expands: true,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey.shade400)
                  ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade400)),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "#Tags",
                    labelStyle: TextStyle(color: Colors.black),
                    alignLabelWithHint: true,
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  widget.taskType == "Magazine" ? FickFileImage():widget.taskType == "Newspaper" ? FickFileImage():widget.taskType == "Radio" ? FickFilAudio():widget.taskType == "TV" ? FickFilVedio():widget.taskType == "Social Media"?FickFileImage(): SizedBox();
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
                          "Upload ${widget.taskType} File",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600),
                        ):Expanded(
                          child: Text(

                            "${widget.filename??fileName}",
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,

                                color: Colors.grey.shade600),
                          ),
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
              SizedBox(height: 5,),
              Text("Supported File  ${widget.taskType == "Newspaper" ||widget.taskType == "Magazine" || widget.taskType == "Social Media" ?"JPG/PNG":widget.taskType == "Radio" ? "MP3" : widget.taskType == "TV" ? "MP4":""  }"),
              // const SizedBox(height: 30),
              // const Text(
              //   "Important tips:",
              //   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              // ),
              // const SuperBulletList(isOrdered: false, items: [
              //   Text(
              //       "Lorem ipsum dolor sit amet, consectetuer adipiscing elit.",
              //       style: TextStyle(fontSize: 13)),
              //   Text("Aliquam tincidunt mauris eu risus.",
              //       style: TextStyle(fontSize: 13)),
              //   Text("Vestibulum auctor dapibus neque.",
              //       style: TextStyle(fontSize: 13)),
              //   Text("Nunc dignissim risus id metus.",
              //       style: TextStyle(fontSize: 13)),
              // ]),
             const SizedBox(height: 20),
               // Text(
               //  "By Submitting the ${widget.taskType}, you agrees to our",
               //  style: TextStyle(fontSize: 12),
              // ),
              // Text(
              //   "Terms & Conditions",
              //   style: TextStyle(
              //       color: Colors.blue,
              //       fontWeight: FontWeight.w600,
              //       fontSize: 12),
              // ),
              
               Row(children: [
                Checkbox(
                  // focusColor: Colors.orange,
                  activeColor: Helper.primaryColor,
                  value: check, onChanged: (value) {
                  setState(() {
                    check =! check;
                  });
                },),
               const Flexible(child: Text("This is to acknowledge that I have reviewed & verified the content before submission."))
              ],),
             const SizedBox(
                height: 80,
              ),

            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        width: double.infinity,
        color: Colors.white,
        height: 70,
        child: Padding(
          padding: const EdgeInsets.only(left: 30),
          child:Row(children: [
            // Flexible(
            //   child: LoginButton(
            //     border: Border.all(
            //       width: 2,
            //       color: const Color(0xFFFFBB12),
            //     ),
            //     // color: const Color(0xFFFFBB12),
            //     height: 45,
            //     width: double.infinity,
            //     borderRadius: BorderRadius.circular(10),
            //     child: Center(
            //         child:_isLoadingDraft ? ConstantsHelper.loadingIndicator() : const Text(
            //           "Save Draft",
            //           style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            //         )),
            //     onTap: () {
            //       setState(() {
            //         _isLoadingDraft = true;
            //       });
            //       // Validate content type and perform specific actions
            //       if (widget.typeOfUpload == "Newspaper" ||
            //           widget.typeOfUpload == "Magazine") {
            //         _validateAndUploadImage();
            //       } else if (widget.typeOfUpload == "Television") {
            //         _validateAndUploadVideo();
            //       } else {
            //         // Handle other content types if needed
            //       }
            //       ApiServices()
            //       .uploadContent(
            //         taskId: widget.taskid,
            //         darftStatus: "1",
            //         schoolId: schoolId,
            //         teacherId: teacherId,
            //         classN: selectedCourseValue1,
            //         fileLink: fileToDisplay!.path,
            //         creatorName: selectedStudentorTitle1 == "Teachers" ? "":_featuringController.text,
            //         caption: _noteController.text,
            //         tags: _tagsController.text,
            //         fileUploadType: widget.taskType,
            //         projectSubject: _projectSubController.text,
            //         creator: widget.creator == "Teachers" ? "Teacher":"Student",
            //       )
            //           .then((resp) {
            //
            //         if (resp != null) {
            //           int indexOfJson = resp.indexOf('{');
            //           if (indexOfJson != -1) {
            //             // setState(() {
            //             //   _isLoading = false;
            //             // });
            //             String jsonPart = resp.substring(indexOfJson);
            //             try {
            //               Map<String, dynamic> resp = jsonDecode(jsonPart);
            //               if (resp != null && resp['is_error'] == false) {
            //                 setState(() {
            //                   _isLoadingDraft = false;
            //                 });
            //                 Navigator.pop(context);
            //                 Fluttertoast.showToast(msg: resp['message'].toString());
            //               }else{
            //                 Future.delayed(Duration(seconds: 2), () {
            //                   setState(() {
            //                     _isLoadingDraft = false;
            //                   });
            //                 });
            //               }
            //             } catch (e) {
            //               Future.delayed(Duration(seconds: 2), () {
            //                 setState(() {
            //                   _isLoadingDraft = false;
            //                 });
            //               });
            //               print('Error decoding JSON: $e');
            //             }
            //           } else {
            //             Future.delayed(Duration(seconds: 2), () {
            //               setState(() {
            //                 _isLoadingDraft = false;
            //               });
            //             });
            //             print('JSON not found in the response');
            //           }
            //         }else{
            //           Future.delayed(Duration(seconds: 2), () {
            //             setState(() {
            //               _isLoadingDraft = false;
            //             });});
            //         }
            //
            //         if (kDebugMode) {
            //           print("::::$resp");
            //         }
            //       });
            //     },
            //   ),
            // ),
            // SizedBox(width: 15,),
            Flexible(
              child: LoginButton(
                color: const Color(0xFFFFBB12),
                height: 45,
                width: double.infinity,
                borderRadius: BorderRadius.circular(10),
                child: Center(
                    child:_isLoading ? ConstantsHelper.loadingIndicator() : Text(
                      "Submit",
                      style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                    )),
                onTap: () {
                  setState(() {
                    _isLoading = true;
                  });
                  // Validate content type and perform specific actions
                  // if (widget.typeOfUpload == "Newspaper" ||
                  //     widget.typeOfUpload == "Magazine") {
                  //   _validateAndUploadImage();
                  // } else if (widget.typeOfUpload == "Television") {
                  //   _validateAndUploadVideo();
                  // } else {
                  //   // Handle other content types if needed
                  // }
                  if(widget.creator == "Students"){
                    if(fileName.toString().isEmpty|| selectedCourseTitle1.isEmpty || _featuringController.text.isEmpty||_noteController.text.isEmpty||check == false){
                      Fluttertoast.showToast(msg: "Please fill the all fields ");
                      setState(() {
                        _isLoading = false;
                      });
                    }else{
                      ApiServices()
                          .uploadContent(
                        taskId: widget.taskid,
                        darftStatus: "0",
                        schoolId: schoolId,
                        teacherId: teacherId,
                        classN: selectedCourseTitle1,
                        fileLink: fileToDisplay!.path,
                        creatorName: selectedStudentorTitle1 == "Teachers" ? "":_featuringController.text,
                        caption: _noteController.text,
                        tags: _tagsController.text,
                        fileUploadType: widget.taskType,
                        projectSubject: _projectSubController.text,
                        creator: widget.creator == "Teachers" ? "Teacher":"Student",
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
                                // Navigator.pop(context);
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
                    }
                  }else{
                    if(fileName.toString().isEmpty&& fileName == null || _noteController.text.isEmpty||check == false){
                      Fluttertoast.showToast(msg: "Please fill the all fields ");
                      setState(() {
                        _isLoading = false;
                      });
                    }else{
                      ApiServices()
                          .uploadContent(
                        taskId: widget.taskid,
                        darftStatus: "0",
                        schoolId: schoolId,
                        teacherId: teacherId,
                        classN: selectedCourseTitle1,
                        fileLink: fileToDisplay!.path,
                        creatorName: selectedStudentorTitle1 == "Teachers" ? "":_featuringController.text,
                        caption: _noteController.text,
                        tags: _tagsController.text,
                        fileUploadType: widget.taskType,
                        projectSubject: _projectSubController.text,
                        creator: widget.creator == "Teachers" ? "Teacher":"Student",
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
                                // Navigator.pop(context);
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
                    }
                  }

                },
              ),
            )
          ],),
        ),
      ),
    );
  }
  void FickFileImage()async{
    try {
      setState(() {
        isLoading = true;
      });
      result = await FilePicker.platform.pickFiles(
        type: FileType.image,
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
      print("::::$e");
    }
  }
  void FickFilVedio()async{
    try {
      setState(() {
        isLoading = true;
      });
      result = await FilePicker.platform.pickFiles(
        type: FileType.video,
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
  void FickFilAudio()async{
    try {
      setState(() {
        isLoading = true;
      });
      result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
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
  } void FickFilPdf()async{
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

  List dropDownClassListData = [
    {"title": "Pre-Nursery", "value": "1"},
    {"title": "Nursery", "value": "2"},
    {"title": "KG ", "value": "3"},
    {"title": "LKG", "value": "4"},
    {"title": "UKG", "value": "5"},
    {"title": "Class 1", "value": "6"},
    {"title": "Class 2 ", "value": "7"},
    {"title": "Class 3 ", "value": "8"},
    {"title": "Class 4 ", "value": "9"},
    {"title": "Class 5 ", "value": "10"},
    {"title": "Class 6 ", "value": "11"},
    {"title": "Class 7 ", "value": "12"},
    {"title": "Class 8 ", "value": "13"},
    {"title": "Class 9 ", "value": "14"},
    {"title": "Class 10 ", "value": "15"},
    {"title": "Class 11 ", "value": "16"},
    {"title": "Class 12 ", "value": "17"},
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
  String selectedCreatorTitle1 = '';

  List dropDownStudentorTecherData = [
    {"title": "Student", "value": "1"},
    {"title": "You", "value": "2"},

    // {"title": "Section D", "value": "4"},
  ];
  late String selectedStudentorValue1 = "";
  String selectedStudentorTitle1 = ''; //


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



