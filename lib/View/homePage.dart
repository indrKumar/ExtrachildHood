import 'package:extrachildhood/Constants/constants_helper.dart';
import 'package:extrachildhood/Constants/constcolor.dart';
import 'package:extrachildhood/Service/apiservices.dart';
import 'package:extrachildhood/View/Widgets/buttons.dart';
import 'package:extrachildhood/View/notifications.dart';
import 'package:extrachildhood/View/uploadcontent.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



  Map<String, Map<String, dynamic>> contents = {};
  bool isLoading = false;
  Future<void> _fetchData() async {
    ApiServices().getContent().then((value) {
      if (value != null && value["contents"] != null) {
        setState(() {
          isLoading = false;
        });
        setState(() {
          contents = Map<String, Map<String, dynamic>>.from(value["contents"]);
          print("::::::>>>>>>>$contents");
        });
      } Future.delayed(Duration(seconds: 5), () {
        setState(() {
          isLoading = false;
        });
      });
      print(value);
    });
  }



  late VideoPlayerController _controller;

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    _fetchData().then((value) {

    });

    // TODO: implement initState
    // _fetchData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        scrolledUnderElevation: 0,
        automaticallyImplyLeading: false,
        title: ImageIcon(AssetImage("assets/extrachildhood.png"),size: 60,color: Colors.black,),
        actions:  [
          const ImageIcon(AssetImage("assets/icons8-share-50.png"),size: 35,),
          const SizedBox(width: 10,),
          GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationPage()));
              },
              child: Icon(Icons.notifications,size: 35,)),
          const SizedBox(width: 10,)
        ],
      ),
      body: isLoading ? ConstantsHelper.loadingIndicator() : contents.length>0 ? ListView.builder(
        itemCount: contents.length,
        itemBuilder: (context, index) {
          var content = contents[(index + 1).toString()];
          // String videoUrl = 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4';

          // Initialize the video player controller


          return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13,vertical: 5),
          child: Card(
            color: Colors.white,
            elevation: 0.5,
            shape: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade200),borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Row
                        (crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        const Text("Title:",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 13),),
                        Flexible(child: Text("${content?["Caption"] ?? ""}",style: TextStyle(color: Color(0xFF545454),fontWeight: FontWeight.w300,fontSize: 12),)),
                      ],),  Row(children: [
                        const Text("Status:",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 13),),
                        Flexible(child: Text(" ${content?["Status"]??''}",style: TextStyle(color: Color(0xFF545454),fontWeight: FontWeight.w300,fontSize: 12),)),
                      ],),  Row(children: [
                        const Text("Submitted on:",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 13),),
                    Flexible(
                      child: Text(
                        content!["submitDate"].toString(),
                        // "${content?["submitDate"] != null && content!["submitDate"] is String && content!["submitDate"].isNotEmpty
                        //     ? DateFormat("yyyy-MM-dd").format(DateFormat("yyyyMMdd").parse(content!["submitDate"].toString()))
                        //     : 'N/A'}",
                        style: const TextStyle(color: Color(0xFF545454), fontWeight: FontWeight.w300, fontSize: 12),
                      ),
                    ),

                      ],),   Row(children: [
                        Text("Published on:",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 13),),
                          Flexible(child: Text(" ${contents["publishedDate"] ?? "Under Review" }",style: TextStyle(color: Color(0xFF545454),fontWeight: FontWeight.w300,fontSize: 12),)),
                      ],),  Row(children: [
                        const Text("Type:",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 13),),
                          Flexible(child: Text(" ${content["FileType"]??" Type is not define"}",style: TextStyle(color: Color(0xFF545454),fontWeight: FontWeight.w300,fontSize: 12),)),
                      ],),Row(children: [
                        const Text("By:",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 13),),
                          Flexible(child: Text(" ${content["CreatorName"]??''}( Class ${content["Class"]??''}, ${content?["Sec"]??''})",style: TextStyle(color: Color(0xFF545454),fontWeight: FontWeight.w300,fontSize: 12),)),
                      ],),
                         SizedBox(height: 15,),
                        content["facebookLink"] != null|| content["xLink"] != null || content["youtubeLink"]!= null || content["InstaLink"] != null ? Row(children: [
                           Text("Links:   "),
                          Row(children: [
                           content["facebookLink"] != null ? InkWell(
                               onTap:(){
                                 launchUrl(Uri.parse(content["facebookLink"]));
                               },
                               child: Icon(Icons.facebook_outlined,size: 20,color: Helper.primaryColor,)):SizedBox(),
                            SizedBox(width: 2,),
                            content["xLink"] != null ? InkWell(
                                onTap: () {
                                  launchUrl(Uri.parse(content["xLink"]));
                                },
                                child: ImageIcon(AssetImage("assets/twitter.png"),size: 15,color: Colors.blueAccent,)):SizedBox(),
                            SizedBox(width: 3,),
                            content["youtubeLink"] != null ? InkWell(
                              onTap: () {
                                launchUrl(Uri.parse(content["youtubeLink"]));
                              },
                              child: Container(
                                decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(2)),
                                height: 10,width: 15,
                              child: Center(child:Icon( Icons.play_arrow,color: Colors.white,size: 10,)),
                              ),
                            ):SizedBox(),
                            SizedBox(width: 4,),
                            content["InstaLink"] != null ?  InkWell(
                                onTap: () {
                                  launchUrl(Uri.parse(content["InstaLink"]));
                                },
                                child: ImageIcon(AssetImage("assets/instagram.png"),size: 15,)):SizedBox(),
                          ],)
                        ],):SizedBox()
                    ],),
                  ),
                  SizedBox(width: 10,),

                  content["FileType"].toString() == "Magazine" || content["FileType"].toString() == "NewsPaper" ?
                  Container(
                    height: 70,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      image: content["FIleLink"] != null && content["FIleLink"].isNotEmpty
                          ? DecorationImage(
                        image: NetworkImage("${content["FIleLink"]}"),
                        fit: BoxFit.fill,
                      )
                          : null, // Set image to null if URL is invalid or empty
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ) : content["FileType"].toString() == "Television" ? SizedBox() : CircularProgressIndicator()

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
              ],),
            ),
          ),
        );
      },):const Center(child: Text("Not Uploaded Content")),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: LoginButton(
        onTap: () {
          _showBottomSheet(context);
        },
        height: 40,width: 160,
        borderRadius: BorderRadius.circular(20),
        child: Center(child: Text("Add Content",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),)),color: Helper.primaryColor,),
    );
  }
  void _showBottomSheet(BuildContext context){
    showModalBottomSheet(context: context, builder: (context) {
      return Container(
        height: MediaQuery.of(context).size.height*0.3,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15,),
            Text("Select the content you want to upload"),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                LoginButton(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UploadContentPage(typeOfUpload: "Magazine"),)).then((value) {
                      setState(() {
                        _fetchData();

                      });
                    });
                  },
                  borderRadius: BorderRadius.circular(25),
                  height: 43,
                  width: MediaQuery.of(context).size.width*0.4,
                  color: Helper.primaryColor,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      Text("Magazine"),
                          ImageIcon(AssetImage("assets/book.png"))
                        ],),
                    ),
                  ),), LoginButton(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => UploadContentPage(typeOfUpload: "NewsPaper"),)).then((value) {
                        setState(() {
                          _fetchData();
                        });
                      });
                    },
                  borderRadius: BorderRadius.circular(25),
                  height: 43,
                    width: MediaQuery.of(context).size.width*0.4,
                  color: Helper.primaryColor,
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25,vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      Text("NewsPaper"),
                          SizedBox(height:20,width:20,child: ImageIcon(AssetImage("assets/microphone.png"),size: 35,))
                ],),
                    ),
                  ),),
              ],),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                LoginButton(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UploadContentPage(typeOfUpload: "Radio"),)).then((value) {
                      setState(() {
                        _fetchData();

                      });
                    });
                  },
                  borderRadius: BorderRadius.circular(25),
                  height: 43,
                  width: MediaQuery.of(context).size.width*0.4,
                  color: Helper.primaryColor,
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25,vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      Text("Radio"),
                          ImageIcon(AssetImage("assets/radio.png"))
                ],),
                    ),
                  ),), LoginButton(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => UploadContentPage(typeOfUpload: "Television"),)).then((value) {
                      setState(() {
                        _fetchData();

                      });
                      });
                    },
                    width: MediaQuery.of(context).size.width*0.4,
                  borderRadius: BorderRadius.circular(25),
                  height: 43,
                  color: Helper.primaryColor,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                      Text("Television"),
                          ImageIcon(AssetImage("assets/tv.png"))
                        ],),
                    ),
                  ),),
              ],),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,  // Set the color of the border
                        width: 3.0,           // Set the width of the border
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Icon(Icons.close, color: Colors.black,weight: 10,size: 35,),
                    ),
                  ),
                )

              ],)
          ],),
        ),
      );
    },);

  }
  //
  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }
}
