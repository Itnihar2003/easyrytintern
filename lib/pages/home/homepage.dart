import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoaiapp/main.dart';

import 'package:todoaiapp/pages/Aipage.dart';
import 'package:todoaiapp/pages/home/cookingai.dart';
import 'package:todoaiapp/pages/notes/editnotes.dart';
import 'package:todoaiapp/pages/notes/notedata.dart';
import 'package:todoaiapp/pages/notes/notes.dart';

import 'package:todoaiapp/pages/speechtotext/speechtotext.dart';
import 'package:http/http.dart' as http;
import 'package:todoaiapp/pages/home/suggestedpage.dart';
import 'package:todoaiapp/pages/ocrfinal/texttoimage.dart';
import 'package:todoaiapp/pages/todo/tododetail.dart';
import 'package:uuid/uuid.dart';

class home extends StatefulWidget {
  List<data1> datas;
  home({
    super.key,
    required this.datas,
  });

  @override
  State<home> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<home> with TickerProviderStateMixin {
  @override
  void initState() {
    update();
    super.initState();
    // generateDeviceIdentifier();
  }

  bool isLoading = true;
  String baseUrl = 'https://scannerimage-e52f6979766b.herokuapp.com';
  void showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id', // Change this to a unique ID for your app
      'Your Channel Name',
      // 'Your Channel Description',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Change this to a unique notification ID
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }

  List text = [
    "Marketing Strategy Blueprint:",
    "Resume Enhancement Studio:",
    "Cover Letter Composer:",
    "Speechcraft Navigator:",
    "Content Summarization Tool:",
    "Mail Mastery Assistant:",
    "Weekly Planner Generator:",
    "Stand-Up Comedy Companion:",
  ];
  List text4 = [
    "Create impactful ad plans, targeting effectively. ",
    "Optimize content, format, showcase achievements—elevate profile. ",
    "Craft personalized, skill-focused cover letters. ",
    "Master public speaking: key points, impact.",
    " Condense details, maintain clarity—summarize effectively. ",
    "Refine email communication: language, tone, structure. ",
    "Prioritize tasks, set goals—boost productivity weekly. ",
    "Craft hilarious punchlines, witty observations—laughter guaranteed. ",
  ];

//permission for internal storage acess
  Future<bool> _request_per(Permission permission) async {
    AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;
    if (build.version.sdkInt >= 30) {
      var re = await Permission.manageExternalStorage.request();
      if (re.isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      if (await permission.isGranted) {
        return true;
      } else {
        return false;
      }
    }
  }

  //filter operation
  final searchfielter = TextEditingController();
  //convert to docoment

  Future<void> convertToDocx(String doc) async {
    if (isLoading) {
      showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        ),
      );
    } else {
      const Text("");
    }

    print("docx conversion started");

    final String convertUrl = '$baseUrl/doc/textToDoc';

    try {
      // Directory? directory = await getExternalStorageDirectory();

      Directory directory = Directory('/storage/emulated/0/Download');
      if (await directory.exists()) {
        String directoryPath = directory.path;
        String fileName =
            'converted_text_${DateTime.now().millisecondsSinceEpoch}.docx';

        final userData = {"text": doc};
        print(doc);
        http.Response response = await http.post(
          Uri.parse(convertUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(userData),
        );
        print(response.statusCode);
        if (response.statusCode == 200) {
          List<int> docxBytes = response.bodyBytes;
          String filePath = '$directoryPath/$fileName';
          await File(filePath).writeAsBytes(docxBytes);
          showNotification(
              'DOC Conversion Successful', 'Successfully converted to Doc');

          // await OpenFile.open(filePath);
          Future.delayed(const Duration(seconds: 5), () async {
            Navigator.of(context).pop();
            await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Success'),
                content: const Text('Successfully converted to Doc '),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        PageTransition(
                          child: home(datas: const []),
                          type: PageTransitionType.fade,
                          isIos: true,
                          duration: const Duration(milliseconds: 900),
                        ),
                        (route) => false),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          });
        } else {
          setState(() {
            isLoading = false;
          });
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: Text('Failed to convert to DOCX ${response.statusCode}'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );

          print('Failed to convert to DOCX: ${response.statusCode}');
        }
      } else {
        print('External storage directory not available');
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to convert to DOCX'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

//convert to text

  Future<void> downloadTxt(String txt) async {
    if (isLoading) {
      showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        ),
      );
    } else {
      const Text("");
    }
    print("text conversion started");

    // final String convertUrl = 'https://ocr-xj19.onrender.com/txt/textTotxt';
    final String convertUrl = '$baseUrl/txt/textTotxt';

    try {
      // Directory? directory = await getExternalStorageDirectory();
      // if (directory != null) {
      Directory directory = Directory('/storage/emulated/0/Download');
      if (await directory.exists()) {
        String directoryPath = directory.path;
        String fileName =
            'converted_text_${DateTime.now().millisecondsSinceEpoch}.txt';
        final userData = {"text": txt};
        http.Response response = await http.post(
          Uri.parse(convertUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(userData),
        );
        print(response.statusCode);
        if (response.statusCode == 200) {
          List<int> txtBytes = response.bodyBytes;
          String filePath = '$directoryPath/$fileName';
          await File(filePath).writeAsBytes(txtBytes);
          showNotification(
              'TXT Conversion Successful', 'Successfully converted to txt');

          // await OpenFile.open(filePath);
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(context).pop();
            // Close the dialog

            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Success'),
                content: const Text('Successfully converted to txt '),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        PageTransition(
                          child: home(datas: const []),
                          type: PageTransitionType.fade,
                          isIos: true,
                          duration: const Duration(milliseconds: 900),
                        ),
                        (route) => false),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
            print("loading");
            setState(() {
              isLoading = false;
            });
          });
        } else {
          setState(() {
            isLoading = false;
          });
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: Text('Failed to convert to TXT ${response.statusCode}'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
          // throw 'Failed to convert to TXT: ${response.statusCode}';
        }
      } else {
        print('External storage directory not available');
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to convert to TXT'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
//convert to pdf

  Future<void> convertToPDF(String pdf) async {
    if (isLoading) {
      showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        ),
      );
    } else {
      const Text("");
    }

    print("pdf conversion started");
    // final String convertUrl = 'https://ocr-xj19.onrender.com/pdf/textToPdf';
    final String convertUrl = '$baseUrl/pdf/textToPdf';

    try {
      // Directory? directory = await getExternalStorageDirectory();
      Directory directory = Directory('/storage/emulated/0/Download');
      print(directory);
      if (await directory.exists()) {
        String directoryPath = directory.path;
        String fileName =
            'converted_text_${DateTime.now().millisecondsSinceEpoch}.pdf';

        // here in body add langcode same as language code selected
        final userData = {"text": pdf, "langCode": 'eng'};
        http.Response response = await http.post(
          Uri.parse(convertUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(userData),
        );

        print(response.statusCode);
        if (response.statusCode == 200) {
          List<int> pdfBytes = response.bodyBytes;
          String filePath = '$directoryPath/$fileName';
          await File(filePath).writeAsBytes(pdfBytes);
          // await OpenFile.open(filePath);
          showNotification(
              'PDF Conversion Successful', 'Successfully converted to PDF');
          Future.delayed(const Duration(seconds: 5), () {
            Navigator.of(context).pop();

            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Success'),
                content: const Text('Successfully converted to pdf '),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        PageTransition(
                          child: home(datas: const []),
                          type: PageTransitionType.fade,
                          isIos: true,
                          duration: const Duration(milliseconds: 900),
                        ),
                        (route) => false),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );

            print("loading");
            setState(() {
              isLoading = false;
            });
          });
        } else {
          setState(() {
            isLoading = false;
          });

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: Text('Failed to convert to pdf ${response.statusCode}'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
          print('Failed to convert to PDF: ${response.statusCode}');
        }
      } else {
        print('External storage directory not available');
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to convert to pdf'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  setdata1() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> data2list =
        widget.datas.map((data1) => jsonEncode(data1.toJson())).toList();
    pref.setStringList('myData2', data2list);
  }

  getdata() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String>? data2list = pref.getStringList('myData2');
    if (data2list != null) {
      List<data1> finaldata2 = data2list
          //here data and data1 are not same
          .map((data2) => data1.fromJson(json.decode(data2)))
          .toList();
      return finaldata2;
    }
  }

  update() async {
    List<data1> sdata = await getdata();
    setState(() {
      widget.datas = sdata;
    });
  }

  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 10))
        ..repeat();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int num = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: AppBar().preferredSize.height,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 55,
                                    width: 200,
                                    padding: const EdgeInsets.only(right: 2),
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 244, 243, 243),
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: TextField(
                                      onChanged: (String value) {
                                        setState(() {});
                                      },
                                      controller: searchfielter,
                                      cursorColor: Colors.black,
                                      style: GoogleFonts.poppins(fontSize: 12),
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: Colors.black,
                                        ),
                                        hintText: "Search",
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // ElevatedButton(
                                  //     style: ElevatedButton.styleFrom(
                                  //         backgroundColor: Colors.amber),
                                  //     onPressed: () {
                                  //       num++;
                                  //       setState(() {});
                                  //     },
                                  //     child: Row(
                                  //       children: [
                                  //         Text(num.toString()),
                                  //         Container(
                                  //             height: 25,
                                  //             width: 22,
                                  //             child: Image.asset(
                                  //                 "assets/popw.png")),
                                  //       ],
                                  //     )),

                                  IconButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) => SizedBox(
                                            height: 350,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 5),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(6),
                                                      topRight:
                                                          Radius.circular(6),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const SizedBox(
                                                              height: 50,
                                                              width: 10),
                                                          Text(
                                                            "Quick Note",
                                                            style: GoogleFonts
                                                                .poppins(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 17,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 10),
                                                          child: ElevatedButton(
                                                            style: ElevatedButton
                                                                .styleFrom(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .black),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                              "close",
                                                              style: GoogleFonts
                                                                  .poppins(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color(0xFFF6F6F6),
                                                    ),
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          const SizedBox(
                                                              height: 2.5),
                                                          const Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                              horizontal: 5,
                                                              vertical: 2.5,
                                                            ),
                                                          ),
                                                          TextButton(
                                                              onPressed: () {},
                                                              child: ListTile(
                                                                  leading: Container(
                                                                      height:
                                                                          30,
                                                                      width: 30,
                                                                      color: Colors
                                                                          .white,
                                                                      child: Image
                                                                          .asset(
                                                                              "assets/1.png")),
                                                                  title:
                                                                      const Text(
                                                                    "share the App",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  trailing:
                                                                      const Icon(
                                                                          Icons
                                                                              .arrow_forward_ios))),
                                                          TextButton(
                                                              onPressed: () {},
                                                              child: ListTile(
                                                                  leading: Container(
                                                                      height:
                                                                          30,
                                                                      width: 30,
                                                                      color: Colors
                                                                          .white,
                                                                      child: Image
                                                                          .asset(
                                                                              "assets/2.png")),
                                                                  title:
                                                                      const Text(
                                                                    "Rate us",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  trailing:
                                                                      const Icon(
                                                                          Icons
                                                                              .arrow_forward_ios))),
                                                          TextButton(
                                                              onPressed: () {},
                                                              child: ListTile(
                                                                  leading: Container(
                                                                      height:
                                                                          30,
                                                                      width: 30,
                                                                      color: Colors
                                                                          .white,
                                                                      child: Image
                                                                          .asset(
                                                                              "assets/3.png")),
                                                                  title:
                                                                      const Text(
                                                                    "Terms of Use",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  trailing:
                                                                      const Icon(
                                                                          Icons
                                                                              .arrow_forward_ios))),
                                                          TextButton(
                                                              onPressed: () {},
                                                              child: ListTile(
                                                                  leading: Container(
                                                                      height:
                                                                          30,
                                                                      width: 30,
                                                                      color: Colors
                                                                          .white,
                                                                      child: Image
                                                                          .asset(
                                                                              "assets/4.png")),
                                                                  title:
                                                                      const Text(
                                                                    "Privacy Policy",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  trailing:
                                                                      const Icon(
                                                                          Icons
                                                                              .arrow_forward_ios))),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.settings)),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      // const SizedBox(height: 15),
                      // Padding(
                      //   padding: const EdgeInsets.all(16.0),
                      //   child: Container(
                      //     child: ImageChanger(),
                      //     height: 140,
                      //     width: MediaQuery.of(context).size.width,
                      //     margin: const EdgeInsets.symmetric(horizontal: 5),
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(12),
                      //       color: Colors.white,
                      //       boxShadow: const [
                      //         BoxShadow(
                      //           color: Color.fromRGBO(100, 100, 111, 0.1),
                      //           blurRadius: 10,
                      //           spreadRadius: 0,
                      //           offset: Offset(0, 7),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // Quick Tools
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            "Quick Tools",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            quickTools("assets/np.png", "Notes", 1),
                            const SizedBox(width: 10),
                            quickTools("assets/tp1.png", "To-do", 2),
                            // const SizedBox(width: 10),
                            // quickTools(
                            //     "assets/diary.png", "speech\nto text", 3),
                            const SizedBox(width: 10),
                            quickTools("assets/confetti.png", "OCR", 3),
                            const SizedBox(width: 10),
                            quickTools("assets/l3.png", "AI Notes", 4),
                          ],
                        ),
                      ),
                      //
                      // Recents
                      SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            "Suggested",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: suggesion(text, text4),
                      ),
                      SizedBox(
                        height: 30,
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            "Recents",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: (widget.datas.length % 2 == 0)
                              ? (widget.datas.length / 2) * 207
                              : widget.datas.length * 180,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisExtent: 200,
                              crossAxisCount: 2,
                              mainAxisSpacing: 10.0,
                            ),
                            itemCount: widget
                                .datas.length, // Total number of containers
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => editnotes(
                                            tittle: widget.datas[index].tittle1,
                                            content:
                                                widget.datas[index].content1,
                                            id: index,
                                            edit: widget.datas,
                                          ),
                                        ));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color.fromRGBO(0, 0, 0, 0.09),
                                          blurRadius: 1,
                                          spreadRadius: 0,
                                          offset: Offset(-4, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 50,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 2),
                                          width: double.infinity,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 98,
                                                height: 22,
                                                child: Text(
                                                  widget.datas[index].tittle1,
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    showModalBottomSheet(
                                                      context: context,
                                                      builder: (context) =>
                                                          SizedBox(
                                                        height: 400,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          5),
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: Colors
                                                                    .black,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          6),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          6),
                                                                ),
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      const SizedBox(
                                                                          height:
                                                                              50,
                                                                          width:
                                                                              10),
                                                                      Text(
                                                                        "Quick Note",
                                                                        style: GoogleFonts
                                                                            .poppins(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              17,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              10),
                                                                      child:
                                                                          ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                            backgroundColor:
                                                                                Colors.black),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          "close",
                                                                          style:
                                                                              GoogleFonts.poppins(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                20,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                        ),
                                                                      )),
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  color: Color(
                                                                      0xFFF6F6F6),
                                                                ),
                                                                child:
                                                                    SingleChildScrollView(
                                                                  child: Column(
                                                                    children: [
                                                                      const SizedBox(
                                                                          height:
                                                                              2.5),
                                                                      const Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              5,
                                                                          vertical:
                                                                              2.5,
                                                                        ),
                                                                      ),
                                                                      TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            FlutterClipboard.copy("${widget.datas[index].tittle1}\n${widget.datas[index].content1}");
                                                                            Get.snackbar("copied",
                                                                                "${widget.datas[index].tittle1}\n${widget.datas[index].content1}");
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child: ListTile(
                                                                              leading: Container(height: 20, width: 30, color: Colors.white, child: Image.asset("assets/copy.png")),
                                                                              title: const Text(
                                                                                "copy to clipboard",
                                                                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                                              ),
                                                                              trailing: const Icon(
                                                                                Icons.arrow_forward_ios,
                                                                                size: 20,
                                                                              ))),
                                                                      TextButton(
                                                                          onPressed:
                                                                              () async {
                                                                            // if (await _request_per(Permission.storage) ==
                                                                            //     true) {
                                                                            convertToPDF("${widget.datas[index].tittle1}\n\n${widget.datas[index].content1}");
                                                                            print("permission granted");
                                                                            // } else {
                                                                            //   print("permission not granted");
                                                                            // }
                                                                          },
                                                                          child: ListTile(
                                                                              leading: Container(height: 20, width: 30, color: Colors.white, child: Image.asset("assets/pop.png")),
                                                                              title: const Text(
                                                                                "PDF",
                                                                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                                              ),
                                                                              trailing: const Icon(
                                                                                Icons.arrow_forward_ios,
                                                                                size: 20,
                                                                              ))),
                                                                      TextButton(
                                                                          onPressed:
                                                                              () async {
                                                                            // if (await _request_per(Permission.storage) ==
                                                                            //     true) {
                                                                            convertToDocx("${widget.datas[index].tittle1}\n\n${widget.datas[index].content1}");
                                                                            print("permission granted");
                                                                            // } else {
                                                                            //   print("permission not granted");
                                                                            // }
                                                                          },
                                                                          child: ListTile(
                                                                              leading: Container(height: 20, width: 30, color: Colors.white, child: Image.asset("assets/word.png")),
                                                                              title: const Text(
                                                                                "Word",
                                                                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                                              ),
                                                                              trailing: const Icon(
                                                                                Icons.arrow_forward_ios,
                                                                                size: 20,
                                                                              ))),
                                                                      TextButton(
                                                                          onPressed:
                                                                              () async {
                                                                            // if (await _request_per(Permission.storage) ==
                                                                            //     true) {
                                                                            downloadTxt("${widget.datas[index].tittle1}\n\n${widget.datas[index].content1}");
                                                                            print("permission granted");
                                                                            // } else {
                                                                            //   print("permission not granted");
                                                                            // }
                                                                          },
                                                                          child: ListTile(
                                                                              leading: Container(height: 20, width: 30, color: Colors.white, child: Image.asset("assets/text.png")),
                                                                              title: const Text(
                                                                                "Txt",
                                                                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                                              ),
                                                                              trailing: const Icon(
                                                                                Icons.arrow_forward_ios,
                                                                                size: 20,
                                                                              ))),
                                                                      TextButton(
                                                                          onPressed:
                                                                              () async {
                                                                            await Share.share(widget.datas[index].tittle1 +
                                                                                "\n" +
                                                                                widget.datas[index].content1);
                                                                          },
                                                                          child: ListTile(
                                                                              leading: Container(height: 20, width: 30, color: Colors.white, child: Image.asset("assets/share.png")),
                                                                              title: const Text(
                                                                                "Share",
                                                                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                                              ),
                                                                              trailing: const Icon(
                                                                                Icons.arrow_forward_ios,
                                                                                size: 20,
                                                                              ))),
                                                                      TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            setState(() {
                                                                              widget.datas.removeAt(index);
                                                                              setdata1();
                                                                            });
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child: ListTile(
                                                                              leading: Container(
                                                                                height: 20,
                                                                                width: 30,
                                                                                color: Colors.white,
                                                                                child: Image.asset("assets/delete.png"),
                                                                              ),
                                                                              title: const Text(
                                                                                "Delete",
                                                                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                                              ),
                                                                              trailing: const Icon(
                                                                                Icons.arrow_forward_ios,
                                                                                size: 20,
                                                                              ))),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  icon: SizedBox(
                                                    width: 12,
                                                    height: 12,
                                                    child: Image.asset(
                                                        "assets/dot.png"),
                                                  ))
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: SizedBox(
                                              height: 120,
                                              child: SingleChildScrollView(
                                                  child: Text(widget
                                                      .datas[index].content1))),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CupertinoButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ai(),
              ));
        },
        child: AnimatedBuilder(
          animation: _controller,
          child: const SizedBox(
            width: 130,
            child: Image(
              image: AssetImage("assets/ai.png"),
              fit: BoxFit.cover,
            ),
          ),
          builder: (context, child) {
            return Transform.rotate(
              angle: _controller.value * 2 * 3.141,
              child: child,
            );
          },
        ),
      ),
    );
  }

  Widget suggesion(List text, List text4) {
    return SizedBox(
      height: 135,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: text.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == text.length) {
            return Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(15)),
              child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => suggesiondetail(),
                        ));
                  },
                  icon: Icon(Icons.send)),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ai2(),
                      ));
                },
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        ListView(
                          children: [
                            Text(
                              text[index],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              text4[index],
                              style:
                                  TextStyle(color: Colors.black, fontSize: 9),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.18),
                        blurRadius: 1,
                        spreadRadius: 1,
                        offset: Offset(-2, 2),
                      ),
                    ],
                  ),
                  height: 135,
                  width: 121.59,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget quickTools(String imageUrl, String title, int index) {
    return Expanded(
      child: InkWell(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        onTap: () {
          if (index == 1) {
            Get.to(() => const notes());
          } else if (index == 2) {
            Get.to(() => const detail());
          } else if (index == 3) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => App(),
                ));
          } else if (index == 4) {
            Get.to(() => ai());
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 57,
              height: 57,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.18),
                    blurRadius: 2,
                    spreadRadius: 0.6,
                    offset: Offset(-2, 1.5),
                  ),
                ],
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder<Object>(
                      stream: null,
                      builder: (context, snapshot) {
                        return Container(
                          height: 38,
                          width: 38,
                          child: Image(
                            image: AssetImage(imageUrl),
                            fit: BoxFit.cover,
                          ),
                        );
                      }),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageChanger extends StatefulWidget {
  const ImageChanger({
    Key? key,
  }) : super(key: key);

  @override
  _ImageChangerState createState() => _ImageChangerState();
}

class _ImageChangerState extends State<ImageChanger> {
  int _index = 0; // the current index of the image list
  late Timer _timer; // the timer object
  List images = [
    "assets/all3.png",
    "assets/g.png",
    "assets/s.png",
    "assets/speech.png",
    "assets/to.png"
  ];

  @override
  void initState() {
    super.initState();
    // initialize the timer with the given duration and a callback function
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      // update the index and wrap around if necessary
      setState(() {
        _index = (_index + 1) % images.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // set the decoration property with the image at the current index
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(images[_index]),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  @override
  void dispose() {
    // cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }
}
