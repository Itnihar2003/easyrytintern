// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoaiapp/main.dart';
import 'package:todoaiapp/pages/home/homepage.dart';
import 'package:todoaiapp/pages/notes/notedata.dart';
import 'package:todoaiapp/pages/ocrfinal/ocr3.dart';
import 'package:todoaiapp/pages/ocrfinal/ocrhome.dart';

class TextViewer extends StatefulWidget {
  var data;
  var langCode;
  TextViewer({
    Key? key,
    required this.data,
    required this.langCode,
  }) : super(key: key);

  @override
  State<TextViewer> createState() => _TextViewerState();
}

class _TextViewerState extends State<TextViewer> {
  TextEditingController _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  //notification
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

  String baseUrl = 'https://scannerimage-e52f6979766b.herokuapp.com';
  //covert to pdf
  Future<void> convertToPDF(String textcontroller, String langcode) async {
    if (isLoading) {
      showDialog(
        context: context,
        builder: (context) => Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        ),
      );
    } else {
      Text("");
    }
    String text = textcontroller.toString();

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
        final userData = {"text": text, "langCode": langcode};
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
          Future.delayed(Duration(seconds: 5), () {
            Navigator.of(context).pop();

            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Success'),
                content: Text('Successfully converted to pdf '),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        PageTransition(
                          child: ocrhome(),
                          type: PageTransitionType.fade,
                          isIos: true,
                          duration: Duration(milliseconds: 900),
                        ),
                        (route) => false),
                    child: Text('OK'),
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
              title: Text('Error'),
              content: Text('Failed to convert to pdf ${response.statusCode}'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
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
          title: Text('Error'),
          content: Text('Failed to convert to pdf'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

//convert to word
  Future<void> convertToDocx(String textcontroller) async {
    if (isLoading) {
      showDialog(
        context: context,
        builder: (context) => Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        ),
      );
    } else {
      Text("");
    }
    String text = textcontroller.toString();
    print("docx conversion started");

    final String convertUrl = '$baseUrl/doc/textToDoc';

    try {
      // Directory? directory = await getExternalStorageDirectory();
      Directory directory = Directory('/storage/emulated/0/Download');
      if (await directory.exists()) {
        String directoryPath = directory.path;
        String fileName =
            'converted_text_${DateTime.now().millisecondsSinceEpoch}.docx';

        final userData = {"text": text};
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
          Future.delayed(Duration(seconds: 5), () async {
            Navigator.of(context).pop();
            await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Success'),
                content: Text('Successfully converted to Doc '),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        PageTransition(
                          child: ocrhome(),
                          type: PageTransitionType.fade,
                          isIos: true,
                          duration: Duration(milliseconds: 900),
                        ),
                        (route) => false),
                    child: Text('OK'),
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
              title: Text('Error'),
              content: Text('Failed to convert to DOCX ${response.statusCode}'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
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
          title: Text('Error'),
          content: Text('Failed to convert to DOCX'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

//convert to txt
  Future<void> downloadTxt(String textcontroller) async {
    if (isLoading) {
      showDialog(
        context: context,
        builder: (context) => Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        ),
      );
    } else {
      Text("");
    }
    print("text conversion started");
    String text = textcontroller;
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
        final userData = {"text": text};
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
          Future.delayed(Duration(seconds: 2), () {
            Navigator.of(context).pop();
            // Close the dialog

            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Success'),
                content: Text('Successfully converted to txt '),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        PageTransition(
                          child: ocrhome(),
                          type: PageTransitionType.fade,
                          isIos: true,
                          duration: Duration(milliseconds: 900),
                        ),
                        (route) => false),
                    child: Text('OK'),
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
              title: Text('Error'),
              content: Text('Failed to convert to TXT ${response.statusCode}'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
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
          title: Text('Error'),
          content: Text('Failed to convert to TXT'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void openCustomCamera() async {
    List<CameraDescription> cameras = await availableCameras();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(cameras: cameras),
      ),
    );
  }

  void shareText() {
    Share.share(_textController.text.toString());
  }

  List<data1> allnote = [];

  setdata1() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> data2list =
        allnote.map((data1) => jsonEncode(data1.toJson())).toList();
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

  @override
  void initState() {
    update();
    _textController.text = widget.data;
    super.initState();
  }

  update() async {
    List<data1> sdata = await getdata();
    setState(() {
      allnote = sdata;
    });
  }

  save1(String aimessage) {
    if (aimessage != "") {
      setState(() {
        allnote.add(data1(
            tittle1: tittlecontroler.text != ""
                ? tittlecontroler.text
                : "OCR" +
                    "(" +
                    DateFormat.yMMMMEEEEd().format(DateTime.now()) +
                    ")",
            content1: aimessage));
      });
      setdata1();
    } else {
      Get.snackbar("Error", "No data", backgroundColor: Colors.grey);
    }
  }

  bool send = false;
  bool edit = true;
  bool camera = false;
  bool save = false;
  bool wordselected = false;
  bool textselected = false;
  bool pdfselected = false;
  bool isLoading = true;
  TextEditingController tittlecontroler = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                save1("${_textController.text.toString()}");
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => home(
                        datas: [],
                      ),
                    ),
                    (Route) => false);
              },
              icon: Icon(
                Icons.arrow_back,
                size: 25,
                color: Colors.black,
              )),
          actions: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        shareText();
                        send = !send;
                        edit = false;
                        camera = false;
                        save = false;
                      });
                      // Share.share(data);
                    },
                    icon: Icon(
                      Icons.share,
                      color: Colors.black,
                      size: 20,
                    )),
                IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => SizedBox(
                          height: 300,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(6),
                                    topRight: Radius.circular(6),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(height: 50, width: 10),
                                        Text(
                                          "Quick Note",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "close",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF6F6F6),
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 2.5),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 5,
                                            vertical: 2.5,
                                          ),
                                        ),
                                        TextButton(
                                            onPressed: () async {
                                              convertToPDF(
                                                _textController.text.toString(),
                                                widget.langCode,
                                              );
                                            },
                                            child: ListTile(
                                                leading: Container(
                                                    height: 20,
                                                    width: 30,
                                                    color: Colors.white,
                                                    child: Image.asset(
                                                        "assets/pop.png")),
                                                title: const Text(
                                                  "PDF",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                trailing: const Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 20,
                                                ))),
                                        TextButton(
                                            onPressed: () async {
                                              convertToDocx(_textController.text
                                                  .toString());
                                            },
                                            child: ListTile(
                                                leading: Container(
                                                    height: 20,
                                                    width: 30,
                                                    color: Colors.white,
                                                    child: Image.asset(
                                                        "assets/word.png")),
                                                title: const Text(
                                                  "Word",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                                trailing: const Icon(
                                                  Icons.arrow_forward_ios,
                                                  size: 20,
                                                ))),
                                        TextButton(
                                            onPressed: () async {
                                              downloadTxt(_textController.text
                                                  .toString());
                                            },
                                            child: ListTile(
                                                leading: Container(
                                                    height: 20,
                                                    width: 30,
                                                    color: Colors.white,
                                                    child: Image.asset(
                                                        "assets/text.png")),
                                                title: const Text(
                                                  "Txt",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400),
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
                      child: Image.asset("assets/dot.png"),
                    ))
              ],
            )
          ],
          title: Row(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.undo)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.redo)),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              edit
                  ? widget.data == null
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextFormField(
                                controller: tittlecontroler,
                                decoration: InputDecoration(
                                  hintText: 'Enter tittle..',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 198, 195, 195),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                ),
                                maxLines: 1,
                                maxLength: 50,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 620,
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.all(30.0),
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    hintText: 'Reasults..',
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                      color: const Color(0xFFBFBFBF),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    focusedErrorBorder: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    _textController.text = value;
                                  },
                                  maxLines: MediaQuery.of(context)
                                      .size
                                      .height
                                      .toInt(),
                                  controller: _textController,
                                ),
                              ),
                            ),
                          ],
                        )
                  // Container(
                  //     // height: 550,
                  //     // width: 310,
                  //     height: size.height * 0.7,
                  //     width: size.width * 0.8,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(20),
                  //       border: Border.all(width: 0.2),
                  //       color: Colors.white,
                  //     ),

                  //     child: Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: TextFormField(
                  //         onChanged: (value) {
                  //           _textController.text = value;
                  //         },
                  //         maxLines:
                  //             MediaQuery.of(context).size.height.toInt(),
                  //         controller: _textController,
                  //         decoration: const InputDecoration(
                  //           hintText: "Scanned Text goes here...",
                  //         ),
                  //       ),
                  //     ),
                  //   )
                  : widget.data == null
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 30,
                              padding: const EdgeInsets.all(30.0),
                              child: TextFormField(
                                controller: tittlecontroler,
                                decoration: InputDecoration(
                                  hintText: 'Enter tittle..',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    color: const Color(0xFFBFBFBF),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                ),
                                maxLines: 2,
                                maxLength: 100,
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height / 2,
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.all(30.0),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: 'Reasults..',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    color: const Color(0xFFBFBFBF),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                ),
                                maxLines: null,
                                initialValue:
                                    "${_textController.text.toString()}",
                              ),
                            ),
                          ],
                        ),

              //             Container(
              //   padding: const EdgeInsets.all(20),
              //   margin: const EdgeInsets.all(20),
              //   decoration: BoxDecoration(
              //       color: Colors.white,
              //       borderRadius: BorderRadius.circular(10),
              //      ),
              //   child: Center(
              //     child: SelectableText(
              //       "${_textController.text.toString()}",
              //       style: const TextStyle(
              //           color: Colors.black,
              //           fontSize: 15,
              //           fontWeight: FontWeight.w500),
              //     ),
              //   ),
              // ),
              // : Container(
              //     // height: 550,
              //     // width: 310,
              //     height: MediaQuery.of(context).size.height,
              //     width: MediaQuery.of(context).size.width,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(20),
              //       border: Border.all(width: 0.2),
              //       color: Colors.white,
              //     ),

              //     child: Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Text("${_textController.text.toString()}"),
              //     ),
              //   ),
              // SizedBox(
              //   height: size.height * 0.07,
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //   child: Container(
              //     // decoration: BoxDecoration(
              //     //   borderRadius: BorderRadius.circular(25),
              //     //   border: Border.all(width: 0.2),
              //     //   color: Color(0xffC3C0C6),
              //     // ),
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(25),
              //       image: DecorationImage(
              //         image: AssetImage(
              //           'assets/images/black.png',
              //         ),
              //         fit: BoxFit.cover,
              //       ),
              //     ),
              //     height: size.height * 0.07,
              //     width: size.width * 0.85,
              //     child: Row(
              //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //       children: [
              //         // InkWell(
              //         //   onTap: () {
              //         //     // Navigator.pushAndRemoveUntil(
              //         //     //   context,
              //         //     //   MaterialPageRoute(
              //         //     //     builder: (context) => EditTextViewer(
              //         //     //       data: _textController.text.toString(),
              //         //     //     ),
              //         //     //   ),
              //         //     //   (route) => false,
              //         //     // );
              //         //     setState(() {
              //         //       send = false;
              //         //       edit = !edit;
              //         //       camera = false;
              //         //       save = false;
              //         //     });
              //         //   },
              //         //   child: AnimatedContainer(
              //         //     duration: Duration(milliseconds: 800),
              //         //     // height: 27,
              //         //     // width: 27,
              //         //     height: size.height * 0.04,
              //         //     width: size.width * 0.11,
              //         //     decoration: BoxDecoration(
              //         //       color: edit ? Colors.white : Colors.transparent,
              //         //       borderRadius: BorderRadius.circular(8),
              //         //       // border: Border.all(
              //         //       //   width: 1,
              //         //       //   color: edit ? Colors.blue : Colors.white,
              //         //       // ),
              //         //     ),
              //         //     child: Padding(
              //         //       padding: const EdgeInsets.all(5.0),
              //         //       child: Image.asset(
              //         //         'assets/images/EDIT.png',
              //         //         // scale: 1,
              //         //         color: edit ? Colors.black : Colors.white,
              //         //       ),
              //         //     ),
              //         //   ),
              //         // ),
              //         // InkWell(
              //         //   onTap: () {
              //         //     setState(() {
              //         //       shareText();
              //         //       send = !send;
              //         //       edit = false;
              //         //       camera = false;
              //         //       save = false;
              //         //     });
              //         //   },
              //         //   child: AnimatedContainer(
              //         //     duration: Duration(milliseconds: 800),
              //         //     // height: 27,
              //         //     // width: 27,
              //         //     height: size.height * 0.04,
              //         //     width: size.width * 0.11,
              //         //     decoration: BoxDecoration(
              //         //       borderRadius: BorderRadius.circular(8),
              //         //       color: send ? Colors.white : Colors.transparent,
              //         //     ),
              //         //     child: Padding(
              //         //       padding: const EdgeInsets.all(5.0),
              //         //       child: Image.asset(
              //         //         'assets/images/SHARE.png',
              //         //         color: send ? Colors.black : Colors.white,
              //         //         // scale: 1,
              //         //         // color: send ? Colors.white : Colors.black,
              //         //       ),
              //         //     ),
              //         //   ),
              //         // ),
              //         // InkWell(
              //         //   onTap: () {
              //         //     setState(() {
              //         //       openCustomCamera();
              //         //       send = false;
              //         //       edit = false;
              //         //       camera = !camera;
              //         //       save = false;
              //         //     });
              //         //   },
              //         //   child: AnimatedContainer(
              //         //     duration: Duration(milliseconds: 800),
              //         //     // height: 27,
              //         //     // width: 27,
              //         //     height: size.height * 0.04,
              //         //     width: size.width * 0.11,
              //         //     decoration: BoxDecoration(
              //         //       color: camera ? Color(0xff007BF7) : Colors.white,
              //         //       borderRadius: BorderRadius.circular(8),
              //         //       // border: Border.all(
              //         //       //   width: 1,
              //         //       // ),
              //         //     ),
              //         //     child: Image.asset(
              //         //       'assets/camera/Photo camera.png',
              //         //       // scale: 1,
              //         //       color: camera ? Colors.white : Colors.black,
              //         //     ),
              //         //     // child: Padding(
              //         //     //   padding: const EdgeInsets.all(4.0),
              //         //     //   child: Transform.scale(
              //         //     //     scale: send ? 1 : 0.7,
              //         //     //     child: Image.asset(
              //         //     //       'assets/viewcontent/Photo camera.png',
              //         //     //       // scale: 1,
              //         //     //       color: send ? Colors.white : Colors.black,
              //         //     //     ),
              //         //     //   ),
              //         //     // ),
              //         //   ),
              //         // ),
              //         // InkWell(
              //         //   onTap: () {
              //         //     setState(() {
              //         //       send = false;
              //         //       edit = false;
              //         //       camera = false;
              //         //       save = !save;
              //         //     });
              //         //     showDialog(
              //         //       context: context,
              //         //       builder: (BuildContext context) {
              //         //         return MyDialog(
              //         //           textcontroller:
              //         //               _textController.text.toString(),
              //         //           langcode: widget.langCode,
              //         //         );
              //         //       },
              //         //     );
              //         //   },
              //         //   child: AnimatedContainer(
              //         //     duration: Duration(milliseconds: 800),
              //         //     // height: 27,
              //         //     // width: 27,
              //         //     height: size.height * 0.04,
              //         //     width: size.width * 0.11,
              //         //     decoration: BoxDecoration(
              //         //       borderRadius: BorderRadius.circular(8),
              //         //       color: save ? Colors.white : Colors.transparent,
              //         //     ),
              //         //     child: Padding(
              //         //       padding: const EdgeInsets.all(5.0),
              //         //       child: Image.asset(
              //         //         'assets/images/SAVE.png',
              //         //         // scale: 1,
              //         //         color: save ? Colors.black : Colors.white,
              //         //       ),
              //         //     ),
              //         //   ),
              //         // ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        floatingActionButton: InkWell(
            onTap: () {
              save1("${_textController.text.toString()}");
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => home(
                      datas: [],
                    ),
                  ),
                  (Route) => false);
            },
            child: const CircleAvatar(
              radius: 25,
              backgroundColor: Colors.black,
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
            )),
      ),
    );
  }
}
