// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:todoaiapp/main.dart';
import 'package:todoaiapp/pages/ocr/homePage.dart';
import 'package:todoaiapp/pages/ocr/newCameraScreen.dart';

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

  @override
  void initState() {
    _textController.text = widget.data;
    super.initState();
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

  bool send = false;
  bool edit = true;
  bool camera = false;
  bool save = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/home/0 5.png'), // Replace with your image asset path
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Container(
                    // height: 55,
                    height: size.height * 0.055,
                    // color: Color.fromARGB(255, 223, 14, 14),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            // Navigator.pop(context);
                            Navigator.push(
                              context,
                              PageTransition(
                                child: HomePage(),
                                type: PageTransitionType.fade,
                                isIos: true,
                                duration: Duration(milliseconds: 900),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.arrow_back_ios,
                                color: Colors.black,
                              ),
                              Container(
                                // height: 26,
                                // width: 62,
                                height: size.height * 0.04,
                                width: size.width * 0.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.black,
                                  ),
                                  // color: Colors.white,
                                ),
                                child: Center(
                                  child: Text(
                                    "Back",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                edit
                    ? widget.data == null
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Container(
                            // height: 550,
                            // width: 310,
                            height: size.height * 0.7,
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(width: 0.2),
                              color: Colors.white,
                            ),

                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                onChanged: (value) {
                                  _textController.text = value;
                                },
                                maxLines:
                                    MediaQuery.of(context).size.height.toInt(),
                                controller: _textController,
                                decoration: const InputDecoration(
                                  hintText: "Scanned Text goes here...",
                                ),
                              ),
                            ),
                          )
                    : widget.data == null
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Container(
                            // height: 550,
                            // width: 310,
                            height: size.height * 0.7,
                            width: size.width * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(width: 0.2),
                              color: Colors.white,
                            ),

                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("${_textController.text.toString()}"),
                            ),
                          ),
                SizedBox(
                  height: size.height * 0.07,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(25),
                    //   border: Border.all(width: 0.2),
                    //   color: Color(0xffC3C0C6),
                    // ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/black.png',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    height: size.height * 0.07,
                    width: size.width * 0.85,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            // Navigator.pushAndRemoveUntil(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => EditTextViewer(
                            //       data: _textController.text.toString(),
                            //     ),
                            //   ),
                            //   (route) => false,
                            // );
                            setState(() {
                              send = false;
                              edit = !edit;
                              camera = false;
                              save = false;
                            });
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 800),
                            // height: 27,
                            // width: 27,
                            height: size.height * 0.04,
                            width: size.width * 0.11,
                            decoration: BoxDecoration(
                              color: edit ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              // border: Border.all(
                              //   width: 1,
                              //   color: edit ? Colors.blue : Colors.white,
                              // ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Image.asset(
                                'assets/images/EDIT.png',
                                // scale: 1,
                                color: edit ? Colors.black : Colors.white,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              shareText();
                              send = !send;
                              edit = false;
                              camera = false;
                              save = false;
                            });
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 800),
                            // height: 27,
                            // width: 27,
                            height: size.height * 0.04,
                            width: size.width * 0.11,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: send ? Colors.white : Colors.transparent,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Image.asset(
                                'assets/images/SHARE.png',
                                color: send ? Colors.black : Colors.white,
                                // scale: 1,
                                // color: send ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        // InkWell(
                        //   onTap: () {
                        //     setState(() {
                        //       openCustomCamera();
                        //       send = false;
                        //       edit = false;
                        //       camera = !camera;
                        //       save = false;
                        //     });
                        //   },
                        //   child: AnimatedContainer(
                        //     duration: Duration(milliseconds: 800),
                        //     // height: 27,
                        //     // width: 27,
                        //     height: size.height * 0.04,
                        //     width: size.width * 0.11,
                        //     decoration: BoxDecoration(
                        //       color: camera ? Color(0xff007BF7) : Colors.white,
                        //       borderRadius: BorderRadius.circular(8),
                        //       // border: Border.all(
                        //       //   width: 1,
                        //       // ),
                        //     ),
                        //     child: Image.asset(
                        //       'assets/camera/Photo camera.png',
                        //       // scale: 1,
                        //       color: camera ? Colors.white : Colors.black,
                        //     ),
                        //     // child: Padding(
                        //     //   padding: const EdgeInsets.all(4.0),
                        //     //   child: Transform.scale(
                        //     //     scale: send ? 1 : 0.7,
                        //     //     child: Image.asset(
                        //     //       'assets/viewcontent/Photo camera.png',
                        //     //       // scale: 1,
                        //     //       color: send ? Colors.white : Colors.black,
                        //     //     ),
                        //     //   ),
                        //     // ),
                        //   ),
                        // ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              send = false;
                              edit = false;
                              camera = false;
                              save = !save;
                            });
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return MyDialog(
                                  textcontroller:
                                      _textController.text.toString(),
                                  langcode: widget.langCode,
                                );
                              },
                            );
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 800),
                            // height: 27,
                            // width: 27,
                            height: size.height * 0.04,
                            width: size.width * 0.11,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: save ? Colors.white : Colors.transparent,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Image.asset(
                                'assets/images/SAVE.png',
                                // scale: 1,
                                color: save ? Colors.black : Colors.white,
                              ),
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
      ),
    );
  }
}

class MyDialog extends StatefulWidget {
  String textcontroller;
  var langcode;
  MyDialog({
    Key? key,
    required this.textcontroller,
    required this.langcode,
  }) : super(key: key);

  @override
  State<MyDialog> createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  bool wordselected = false;
  bool textselected = false;
  bool pdfselected = false;
  bool isLoading = true;

  late List<String> storedList;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

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

  Future<void> convertToPDF() async {
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
    String text = widget.textcontroller.toString();

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
        final userData = {"text": text, "langCode": 'eng'};
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
                          child: HomePage(),
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

  Future<void> convertToDocx() async {
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
    String text = widget.textcontroller.toString();
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
                          child: HomePage(),
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

  Future<void> downloadTxt() async {
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
    String text = widget.textcontroller;
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
                          child: HomePage(),
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

  @override
  Widget build(BuildContext context) {
    print("in mydialog");
    print(widget.langcode);
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Container(
        // height: 100,
        // width: 312,
        height: size.height * 0.13,
        width: size.width * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(
                'assets/images/DRIVE BOX.png'), // Replace with your image asset path
            fit: BoxFit.cover,
          ),
        ),

        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  wordselected = !wordselected;
                  textselected = false;
                  pdfselected = false;
                  print("word");
                  print('pdf $pdfselected');
                  print('word $wordselected');
                  print('text $textselected');
                });
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, left: 4, right: 4),
                    child: Container(
                      height: 69,
                      width: 69,
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: wordselected
                                ? Colors.black
                                : Colors.transparent,
                          ),
                          // color:
                          //     wordselected ? Colors.blue : Colors.transparent,
                          borderRadius: BorderRadius.circular(6)),
                      child: Image.asset(
                        'assets/images/DOC.png',
                        // 'assets/home/doc.png',
                        height: 69,
                        width: 69,
                        // color: wordselected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Word',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: size.width * 0.01),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    textselected = !textselected;
                    wordselected = false;
                    pdfselected = false;
                    print("text");
                    print('pdf $pdfselected');
                    print('word $wordselected');
                    print('text $textselected');
                  });
                },
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 4.0,
                      ),
                      child: Container(
                        height: 69,
                        width: 69,
                        decoration: BoxDecoration(
                          // color: textselected ? Colors.blue : Colors.white,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            width: 1,
                            color: textselected
                                ? Colors.black
                                : Colors.transparent,
                          ),
                        ),
                        child: Image.asset(
                          'assets/images/TXT.png',
                          // 'assets/home/txt.png',
                          height: 69,
                          width: 69,
                          // color: textselected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Text',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: size.width * 0.01),
            Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    pdfselected = !pdfselected;
                    wordselected = false;
                    textselected = false;
                    print("pdf");
                    print('pdf $pdfselected');
                    print('word $wordselected');
                    print('text $textselected');
                  });
                },
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 4.0, left: 4, right: 4),
                      child: Container(
                        // color: Colors.red,
                        height: 69,
                        width: 65,
                        decoration: BoxDecoration(
                          // color: pdfselected ? Colors.blue : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            width: 1,
                            color:
                                pdfselected ? Colors.black : Colors.transparent,
                          ),
                        ),
                        child: Image.asset(
                          'assets/images/PDF.png',
                          // 'assets/home/pdf.png',
                          height: 59,
                          width: 59,
                          // color: pdfselected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Pdf',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
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
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                height: size.height * 0.05,
                width: size.width * 0.26,
                decoration: BoxDecoration(
                  // color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/DRIVE BOX.png'), // Replace with your image asset path
                    fit: BoxFit.cover,
                  ),
                ),
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(12),
                //   color: Colors.white,
                // ),
                child: Center(
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 19,
            ),
            InkWell(
              onTap: () {
                //this is edit text page
                print("while generation");
                print('pdf $pdfselected');
                print('word $wordselected');
                print('text $textselected');
                if (pdfselected == true) {
                  convertToPDF();
                } else if (textselected == true) {
                  downloadTxt();
                } else if (wordselected == true) {
                  convertToDocx();
                }
              },
              child: Container(
                // height: 36,
                // width: 120,
                height: size.height * 0.05,
                width: size.width * 0.26,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(
                        'assets/images/DRIVE BOX.png'), // Replace with your image asset path
                    fit: BoxFit.cover,
                  ),
                ),
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(12),
                //   color: Colors.white,
                // ),
                child: Center(
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
