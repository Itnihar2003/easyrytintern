import 'dart:convert';
import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';

import 'package:share_plus/share_plus.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoaiapp/main.dart';

import 'package:todoaiapp/pages/home/homepage.dart';
import 'package:todoaiapp/pages/notes/notedata.dart';
import 'dart:math' as math show sin, pi, sqrt;
import 'package:http/http.dart' as http;

TextEditingController editController = TextEditingController();
TextEditingController editwritingController = TextEditingController();

class editnotes extends StatefulWidget {
  final String tittle;
  final String content;
  final int id;
  final List<data1> edit;
  const editnotes(
      {super.key,
      required this.tittle,
      required this.content,
      required this.id,
      required this.edit});

  @override
  _editnotesState createState() => _editnotesState();
}

class _editnotesState extends State<editnotes> {
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

  //converted to docs
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

  //converted to txt
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

  int selectedindex = -1;

  setdata1() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> data2list =
        widget.edit.map((data1) => jsonEncode(data1.toJson())).toList();
    pref.setStringList('myData2', data2list);
  }

  String tit = "";
  String finalvalue = "";
  String con = "";
  String finalcontent = "";
  @override
  Widget build(BuildContext context) {
    tit = widget.tittle;
    con = widget.content;
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Stack(
        children: [
          WaveAnimation(
            size: 60.0,
            color: Color.fromARGB(255, 172, 172, 172),
            centerChild: Stack(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle button tap
                    if (finalcontent != "" && finalvalue != "") {
                      setState(() {
                        selectedindex = widget.id;
                        widget.edit[widget.id].tittle1 = finalvalue;
                        widget.edit[widget.id].content1 = finalcontent;
                        setdata1();
                      });
                    } else if (finalcontent != "" && finalvalue == "") {
                      setState(() {
                        selectedindex = widget.id;
                        widget.edit[widget.id].tittle1 = tit;
                        widget.edit[widget.id].content1 = finalcontent;
                        setdata1();
                      });
                    } else if (finalcontent == "" && finalvalue != "") {
                      setState(() {
                        selectedindex = widget.id;
                        widget.edit[widget.id].tittle1 = finalvalue;
                        widget.edit[widget.id].content1 = con;
                        setdata1();
                      });
                    } else {
                      setState(() {
                        selectedindex = widget.id;
                        widget.edit[widget.id].tittle1 = tit;
                        widget.edit[widget.id].content1 = con;
                        setdata1();
                      });
                    }
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => home(
                            datas: const [],
                          ),
                        ));
                  },
                  child: Text(""),
                ),
              ],
            ),
          ),
          Positioned(
            top: 17,
            left: 18,
            child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.black,
                child: IconButton(
                    onPressed: () {
                      if (finalcontent != "" && finalvalue != "") {
                        setState(() {
                          selectedindex = widget.id;
                          widget.edit[widget.id].tittle1 = finalvalue;
                          widget.edit[widget.id].content1 = finalcontent;
                          setdata1();
                        });
                      } else if (finalcontent != "" && finalvalue == "") {
                        setState(() {
                          selectedindex = widget.id;
                          widget.edit[widget.id].tittle1 = tit;
                          widget.edit[widget.id].content1 = finalcontent;
                          setdata1();
                        });
                      } else if (finalcontent == "" && finalvalue != "") {
                        setState(() {
                          selectedindex = widget.id;
                          widget.edit[widget.id].tittle1 = finalvalue;
                          widget.edit[widget.id].content1 = con;
                          setdata1();
                        });
                      } else {
                        setState(() {
                          selectedindex = widget.id;
                          widget.edit[widget.id].tittle1 = tit;
                          widget.edit[widget.id].content1 = con;
                          setdata1();
                        });
                      }
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => home(
                              datas: const [],
                            ),
                          ));
                    },
                    icon: const Icon(
                      color: Colors.white,
                      Icons.replay_outlined,
                      size: 30,
                    ))),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 82,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.arrow_back)),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) => SizedBox(
                                        height: 300,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(6),
                                                  topRight: Radius.circular(6),
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
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 10),
                                                      child: TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          "close",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15,
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
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFFF6F6F6),
                                                ),
                                                child: SingleChildScrollView(
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
                                                          onPressed: () {
                                                                 if (finalvalue !=
                                                                    "" &&
                                                                finalcontent !=
                                                                    "") {
                                                                        FlutterClipboard.copy(
                                                                "${finalvalue + "\n" + finalcontent}");
                                                            Get.snackbar(
                                                                "copied", "");
                                                            Navigator.pop(
                                                                context);
                                                            
                                                            } else {
                                                                FlutterClipboard.copy(
                                                                "${widget.tittle + "\n" + widget.content}");
                                                            Get.snackbar(
                                                                "copied", "");
                                                            Navigator.pop(
                                                                context);
                                                             
                                                            }

                                                           
                                                          },
                                                          child: Container(
                                                            height: 30,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                          height:
                                                                              20,
                                                                          width:
                                                                              30,
                                                                          color: Colors
                                                                              .white,
                                                                          child:
                                                                              Image.asset("assets/copy.png")),
                                                                      Text(
                                                                        "copy to clipboard",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.w400),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .arrow_forward_ios,
                                                                        size:
                                                                            20,
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          )),
                                                      TextButton(
                                                          onPressed: () {
                                                             if (finalvalue !=
                                                                    "" &&
                                                                finalcontent !=
                                                                    "") {
                                                              convertToPDF(
                                                                  "${finalvalue + "\n" + finalcontent}");
                                                            } else {
                                                              convertToPDF(
                                                                  "${widget.tittle + "\n" + widget.content}");
                                                            }

                                                            print(
                                                                "permission granted");
                                                          },
                                                          child: Container(
                                                            height: 30,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                          height:
                                                                              20,
                                                                          width:
                                                                              30,
                                                                          color: Colors
                                                                              .white,
                                                                          child:
                                                                              Image.asset("assets/pop.png")),
                                                                      Text(
                                                                        "PDF",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.w400),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .arrow_forward_ios,
                                                                        size:
                                                                            20,
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          )),
                                                      TextButton(
                                                          onPressed: () {
                                                               if (finalvalue !=
                                                                    "" &&
                                                                finalcontent !=
                                                                    "") {
                                                              convertToDocx(
                                                                  "${finalvalue + "\n" + finalcontent}");
                                                            } else {
                                                              convertToDocx(
                                                                  "${widget.tittle + "\n" + widget.content}");
                                                            }

                                                            print(
                                                                "permission granted");
                                                          },
                                                          child: Container(
                                                            height: 30,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                          height:
                                                                              20,
                                                                          width:
                                                                              30,
                                                                          color: Colors
                                                                              .white,
                                                                          child:
                                                                              Image.asset("assets/word.png")),
                                                                      Text(
                                                                        "Word",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.w400),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .arrow_forward_ios,
                                                                        size:
                                                                            20,
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          )),
                                                      TextButton(
                                                          onPressed: () async {
                                                            if (finalvalue !=
                                                                    "" &&
                                                                finalcontent !=
                                                                    "") {
                                                              downloadTxt(
                                                                  "${finalvalue + "\n" + finalcontent}");
                                                            } else {
                                                              downloadTxt(
                                                                  "${widget.tittle + "\n" + widget.content}");
                                                            }

                                                            print(
                                                                "permission granted");
                                                          },
                                                          child: Container(
                                                            height: 30,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                          height:
                                                                              20,
                                                                          width:
                                                                              30,
                                                                          color: Colors
                                                                              .white,
                                                                          child:
                                                                              Image.asset("assets/text.png")),
                                                                      Text(
                                                                        "Txt",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.w400),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .arrow_forward_ios,
                                                                        size:
                                                                            20,
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          )),
                                                      TextButton(
                                                          onPressed: () async {
                                                            if (finalvalue !=
                                                                    "" &&
                                                                finalcontent !=
                                                                    "") {
                                                              await Share.share(
                                                                  finalvalue +
                                                                      "\n" +
                                                                      finalcontent +
                                                                      "\n" +
                                                                      "https://bit.ly/4bk7ZAV");
                                                            } else {
                                                              await Share.share(widget
                                                                      .tittle +
                                                                  "\n" +
                                                                  widget
                                                                      .content +
                                                                  "\n" +
                                                                  "https://bit.ly/4bk7ZAV");
                                                            }
                                                          },
                                                          child: Container(
                                                            height: 30,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          10),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                          height:
                                                                              20,
                                                                          width:
                                                                              30,
                                                                          color: Colors
                                                                              .white,
                                                                          child:
                                                                              Image.asset("assets/share.png")),
                                                                      Text(
                                                                        "Share",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.w400),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .arrow_forward_ios,
                                                                        size:
                                                                            20,
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          )),
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
                                  )),
                            ],
                          ),
                        ),

                        // Padding(
                        //   padding: const EdgeInsets.all(10.0),
                        //   child: Row(
                        //     children: [
                        //       IconButton(
                        //           onPressed: () async {
                        //             if (finalvalue != "" &&
                        //                 finalcontent != "") {
                        //               await Share.share(
                        //                   finalvalue + "\n" + finalcontent);
                        //             } else {
                        //               await Share.share(widget.tittle +
                        //                   "\n" +
                        //                   widget.content);
                        //             }
                        //           },
                        //           icon: const Icon(Icons.share)),
                        //     ],
                        //   ),
                        // )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                    child: TextFormField(
                      maxLength: 100,
                      initialValue: tit,
                      onChanged: (value) {
                        setState(() {
                          if (value != "") {
                            tit = value;
                            finalvalue = value;
                          } else {
                            finalvalue = widget.tittle;
                          }
                        });
                      },
                      maxLines: 2,
                      autofocus: true,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: "tittle",
                        hintStyle: TextStyle(
                          color: const Color(0xFFBFBFBF),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 610,
                      decoration: const BoxDecoration(),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                        child: TextFormField(
                          initialValue: con,
                          onChanged: (value1) {
                            setState(() {
                              if (value1 != "") {
                                con = value1;
                                finalcontent = value1;
                              } else {
                                finalcontent = widget.content;
                              }
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Start Writing..',
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
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WaveAnimation extends StatefulWidget {
  final double size;
  final Color color;
  final Widget centerChild;

  const WaveAnimation({
    this.size = 80.0,
    this.color = Colors.red,
    required this.centerChild,
    Key? key,
  }) : super(key: key);

  @override
  WaveAnimationState createState() => WaveAnimationState();
}

class WaveAnimationState extends State<WaveAnimation>
    with TickerProviderStateMixin {
  late AnimationController animCtr;

  @override
  void initState() {
    super.initState();
    animCtr = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  Widget getAnimatedWidget() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.size),
          gradient: RadialGradient(
            colors: [
              widget.color,
              Color.lerp(widget.color, Colors.black, .05)!
            ],
          ),
        ),
        child: ScaleTransition(
          scale: Tween(begin: 0.95, end: 1.0).animate(
            CurvedAnimation(
              parent: animCtr,
              curve: CurveWave(),
            ),
          ),
          child: Container(
            width: widget.size * 0.4,
            height: widget.size * 0.4,
            margin: const EdgeInsets.all(6),
            child: widget.centerChild,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(context) {
    return CustomPaint(
      painter: CirclePainter(animCtr, color: widget.color),
      child: SizedBox(
        width: widget.size * 1.6,
        height: widget.size * 1.6,
        child: getAnimatedWidget(),
      ),
    );
  }

  @override
  void dispose() {
    animCtr.dispose();
    super.dispose();
  }
}

class CirclePainter extends CustomPainter {
  final Color color;
  final Animation<double> animation;

  CirclePainter(
    this.animation, {
    required this.color,
  }) : super(repaint: animation);

  void circle(Canvas canvas, Rect rect, double value) {
    final double opacity = (1.0 - (value / 4.0)).clamp(0.0, 1.0);
    final Color rippleColor = color.withOpacity(opacity);
    final double size = rect.width / 2;
    final double area = size * size;
    final double radius = math.sqrt(area * value / 4);
    final Paint paint = Paint()..color = rippleColor;
    canvas.drawCircle(rect.center, radius, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    for (int wave = 3; wave >= 0; wave--) {
      circle(canvas, rect, wave + animation.value);
    }
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) => true;
}

class CurveWave extends Curve {
  @override
  double transform(double t) {
    if (t == 0 || t == 1) {
      return 0.01;
    }
    return math.sin(t * math.pi);
  }
}
