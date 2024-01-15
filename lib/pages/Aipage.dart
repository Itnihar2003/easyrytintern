// import 'package:flutter/material.dart';

// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

// import 'dart:convert';

// import 'package:http/http.dart' as http;

// class aiask extends StatefulWidget {
//   const aiask({super.key});

//   @override
//   State<aiask> createState() => _AskAiScreenState();
// }

// class _AskAiScreenState extends State<aiask> {
//     final List<Message> _messages = [];

//   final TextEditingController _textEditingController = TextEditingController();

//   void onSendMessage() async {
//     Message message = Message(text: _textEditingController.text, isMe: true);

//     _textEditingController.clear();

//     setState(() {
//       _messages.insert(0, message);
//     });

//     String response = await sendMessageToChatGpt(message.text);

//     Message chatGpt = Message(text: response, isMe: false);

//     setState(() {
//       _messages.insert(0, chatGpt);
//     });
//   }

//     Future<String> sendMessageToChatGpt(String message) async {
//     final userData = {"userPrompt": message};

//     http.Response response = await http.post(
//       Uri.parse("https://chatgpt-xb9q.onrender.com/gpt"),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(userData),
//     );
//     print(response.body);
//     Map<String, dynamic> parsedresponce = json.decode(response.body);
//     String reply = parsedresponce["data"];

//     print(response.body);
//     return reply;
//   }
//     Widget _buildMessage(Message message) {
//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 10.0),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
//         child: Column(
//           crossAxisAlignment:
//               message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//           children: <Widget>[
//             Text(
//               message.isMe ? 'You' : 'GPT',
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//             Text(message.text),
//           ],
//         ),
//       ),
//     );
//   }
//   String chatReply =
//       "d in your arms and be held as if I could break.I WISH TO REST INTO YOU my love possibly collapse and I know we mustn't fall for we must hold our selves before we hold each other's warm bodies in the night that bites where lovers lay but tonight my love I would like to collapse I would like to exhale and with it let go of all my fireall the do's I would like to be a child in your arms and be held as if I could break. I WISH TO REST INTO YOU my love possibly collapse and I know we mustn't fall for we must hold our selves before we hold each other's warm bodies in the night that bites where lovers lay but tonight my love I would like to collapse I would like to exhale and with it let go of all my fire all the do's. I would like to be a child in your arms and be held as if I could break.";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           height: MediaQuery.of(context).size.height,
//           width: MediaQuery.of(context).size.width,
//           padding: const EdgeInsets.symmetric(horizontal: 5),
//           child: Column(
//             children: [
//               appbar(),
//               Expanded(
//                 child: ListView.builder(
//                     itemCount: 1,
//                     itemBuilder: (context, index) {
//                       return singleSenderChatTile();
//                     }),
//               ),
//               const SizedBox(height: 2.5),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Container(
//                   // height: 60,
//                   width: MediaQuery.of(context).size.width,
//                   padding: const EdgeInsets.symmetric(vertical: 2.5),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [

//                       Expanded(
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 3),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(10),
//                             boxShadow: const [
//                               BoxShadow(
//                                 color: Color.fromRGBO(99, 99, 99, 0.2),
//                                 blurRadius: 8,
//                                 spreadRadius: 0,
//                                 offset: Offset(0, 2),
//                               ),
//                             ],
//                           ),

//                           child: TextFormField(
//                             maxLines: 1,
//                             style: GoogleFonts.poppins(
//                               color: Colors.grey,
//                               fontSize: 16,
//                             ),
//                             cursorColor: Colors.black,
//                             decoration: const InputDecoration(
//                               enabledBorder: InputBorder.none,
//                               focusedBorder: InputBorder.none,
//                               focusedErrorBorder: InputBorder.none,
//                               hintText: "Type message..",
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Container(
//                         height: 50,
//                         width: 50,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(10),
//                           boxShadow: const [
//                             BoxShadow(
//                               color: Color.fromRGBO(99, 99, 99, 0.2),
//                               blurRadius: 8,
//                               spreadRadius: 0,
//                               offset: Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                         child: const Center(
//                           child: Icon(
//                             Icons.send_sharp,
//                             size: 20,
//                             color: Colors.black,
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 2.5)
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget singleSenderChatTile() {
//     return Column(
//       children: [
//         Row(
//           children: [
//             Container(
//               height: 25,
//               width: 25,
//               decoration: const BoxDecoration(
//                 shape: BoxShape.rectangle,
//                 image: DecorationImage(
//                   image: AssetImage("assets/notes.png"),
//                   fit: BoxFit.contain,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 2.5),
//             Text(
//               "You",
//               style: GoogleFonts.poppins(
//                 color: Colors.black,
//                 fontSize: 14,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//         Row(
//           children: [
//             const SizedBox(
//               height: 25,
//               width: 25,
//             ),
//             const SizedBox(width: 2.5),
//             Text(
//               "Write About AI",
//               style: GoogleFonts.poppins(
//                 color: Colors.black,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//         Row(
//           children: [
//             const SizedBox(
//               height: 25,
//               width: 25,
//             ),
//             const SizedBox(width: 2.5),
//             Expanded(
//               child: Text(
//                 chatReply,
//                 style: GoogleFonts.poppins(
//                   color: Colors.black,
//                   fontSize: 15,
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget appbar() {
//     return SizedBox(
//       height: AppBar().preferredSize.height,
//       width: MediaQuery.of(context).size.width,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           InkWell(
//             overlayColor: MaterialStateProperty.all(Colors.transparent),
//             onTap: () {
//               Get.back();
//             },
//             child: const Icon(
//               Icons.arrow_back,
//               color: Colors.black,
//               size: 30,
//             ),
//           ),
//           const Row(
//             children: [
//               Icon(
//                 Icons.edit,
//                 size: 30,
//                 color: Colors.black,
//               ),
//               SizedBox(width: 10),
//               Icon(
//                 Icons.menu,
//                 size: 30,
//                 color: Colors.black,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoaiapp/main.dart';
import 'package:todoaiapp/pages/homepage.dart';
import 'package:todoaiapp/pages/notes/notedata.dart';

class ai extends StatefulWidget {
  @override
  _aiState createState() => _aiState();
}

class _aiState extends State<ai> {
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
    _scrollController = ScrollController();
    super.initState();
  }

  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
            tittle1: "Ai" + "(" + DateTime.now().toString() + ")",
            content1: aimessage));
      });
      setdata1();
    } else {
      Get.snackbar("Error", "Plese fill all data",
          backgroundColor: Colors.grey);
    }
  }

  late ScrollController _scrollController;
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

//covertion to pdf
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

//convertion to txt
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

  //convertion to docs
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

  final List<Message> _messages = [];
  bool _isLoading = true;
  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController edittext = TextEditingController();
  void onSendMessage() async {
    Message message = Message(text: _textEditingController.text, isMe: true);

    _textEditingController.clear();

    setState(() {
      _messages.insert(0, message);
    });

    String response = await sendMessageToChatGpt(message.text);

    Message chatGpt = Message(text: response, isMe: false);

    setState(() {
      _messages.insert(0, chatGpt);
    });
  }

  void scrolltoend() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(seconds: 2), curve: Curves.easeInOutCubic);
  }

  String all = "";
  String data = "";
  String editdata = "";
  List messages = [];
  Future<String> sendMessageToChatGpt(String message) async {
    final userData = {"userPrompt": message};

    http.Response response = await http.post(
      Uri.parse("https://chatgpt-xb9q.onrender.com/gpt"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(userData),
    );
    print(response.body);
    Map<String, dynamic> parsedresponce = json.decode(response.body);
    String reply = parsedresponce["data"];

    print(response.body);
    data = reply;
    messages.add(message);
    messages.add(reply);
    print(response.statusCode);
    setState(() {
      scrolltoend();
    });

    return reply;
  }

  Widget _buildMessage(Message message) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          // crossAxisAlignment:
          //     message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                message.isMe
                    ? Container(
                        width: 15, child: Image.asset("assets/person.png"))
                    : Container(
                        width: 20, child: Image.asset("assets/gpt.png")),
                SizedBox(
                  width: 10,
                ),
                Text(
                  message.isMe ? 'You' : 'GPT',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black),
                ),
              ],
            ),
            SizedBox(
              height: 6,
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: AnimatedTextKit(
                          repeatForever: false,
                          isRepeatingAnimation: false,
                          animatedTexts: [
                            TypewriterAnimatedText(message.text)
                          ]),
                    ),
                  ),
                  message.isMe
                      ? Row(
                          children: [
                            // IconButton(
                            //     onPressed: () {
                            //       showDialog(
                            //         context: context,
                            //         builder: (context) => AlertDialog(
                            //           actions: [
                            //             ElevatedButton(
                            //                 onPressed: () {
                            //                   if (editdata == "") {
                            //                     _textEditingController.text =
                            //                         message.text;
                            //                     onSendMessage();
                            //                   } else {
                            //                     _textEditingController.text =
                            //                         editdata;
                            //                     onSendMessage();
                            //                   }
                            //                   Navigator.pop(context);
                            //                 },
                            //                 child: Text("send"))
                            //           ],
                            //           title: Text("Edit"),
                            //           content: Container(
                            //             height: 500,
                            //             child: TextFormField(
                            //               decoration: InputDecoration(
                            //                   border: OutlineInputBorder()),
                            //               maxLines: 100,
                            //               initialValue: message.text,
                            //               onChanged: (value) {
                            //                 editdata = value;
                            //                 _textEditingController.text =
                            //                     value;
                            //               },
                            //             ),
                            //           ),
                            //         ),
                            //       );
                            //     },
                            //     icon: Icon(
                            //       Icons.edit,
                            //       size: 15,
                            //     )),
                          ],
                        )
                      : Container(
                          width: 150,
                          height: 30,
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    FlutterClipboard.copy(message.text);
                                  },
                                  icon: Icon(
                                    Icons.copy,
                                    size: 15,
                                  )),
                              // IconButton(
                              //     onPressed: () {
                              //       showModalBottomSheet(
                              //         context: context,
                              //         builder: (context) => SizedBox(
                              //           height: 400,
                              //           child: Column(
                              //             mainAxisAlignment:
                              //                 MainAxisAlignment.start,
                              //             children: [
                              //               Container(
                              //                 padding:
                              //                     const EdgeInsets.symmetric(
                              //                         horizontal: 5),
                              //                 decoration: const BoxDecoration(
                              //                   color: Colors.black,
                              //                   borderRadius: BorderRadius.only(
                              //                     topLeft: Radius.circular(6),
                              //                     topRight: Radius.circular(6),
                              //                   ),
                              //                 ),
                              //                 child: Row(
                              //                   mainAxisAlignment:
                              //                       MainAxisAlignment
                              //                           .spaceBetween,
                              //                   children: [
                              //                     Row(
                              //                       children: [
                              //                         const SizedBox(
                              //                             height: 60,
                              //                             width: 10),
                              //                         Text(
                              //                           "Quick Note",
                              //                           style:
                              //                               GoogleFonts.poppins(
                              //                             color: Colors.white,
                              //                             fontSize: 17,
                              //                             fontWeight:
                              //                                 FontWeight.w400,
                              //                           ),
                              //                         ),
                              //                       ],
                              //                     ),
                              //                     Padding(
                              //                         padding:
                              //                             const EdgeInsets.only(
                              //                                 right: 40),
                              //                         child: ElevatedButton(
                              //                           style: ElevatedButton
                              //                               .styleFrom(
                              //                                   backgroundColor:
                              //                                       Colors
                              //                                           .black),
                              //                           onPressed: () {
                              //                             Navigator.pop(
                              //                                 context);
                              //                           },
                              //                           child: Text(
                              //                             "X",
                              //                             style: GoogleFonts
                              //                                 .poppins(
                              //                               color: Colors.white,
                              //                               fontSize: 20,
                              //                               fontWeight:
                              //                                   FontWeight.w500,
                              //                             ),
                              //                           ),
                              //                         )),
                              //                   ],
                              //                 ),
                              //               ),
                              //               Expanded(
                              //                 child: Container(
                              //                   decoration: const BoxDecoration(
                              //                     color: Color(0xFFF6F6F6),
                              //                   ),
                              //                   child: SingleChildScrollView(
                              //                     child: Column(
                              //                       children: [
                              //                         const SizedBox(
                              //                             height: 2.5),
                              //                         const Padding(
                              //                           padding: EdgeInsets
                              //                               .symmetric(
                              //                             horizontal: 5,
                              //                             vertical: 2.5,
                              //                           ),
                              //                         ),
                              //                         TextButton(
                              //                             onPressed: () {
                              //                               Navigator.push(
                              //                                   context,
                              //                                   MaterialPageRoute(
                              //                                     builder:
                              //                                         (context) =>
                              //                                             home(
                              //                                       datas:
                              //                                           allnote,
                              //                                     ),
                              //                                   ));
                              //                               save1(message.text);
                              //                             },
                              //                             child: ListTile(
                              //                                 leading:
                              //                                     Container(
                              //                                         height:
                              //                                             30,
                              //                                         width: 30,
                              //                                         color: Colors
                              //                                             .white,
                              //                                         child:
                              //                                             Icon(
                              //                                           Icons
                              //                                               .save,
                              //                                           size:
                              //                                               30,
                              //                                         )),
                              //                                 title: const Text(
                              //                                   "save",
                              //                                   style: TextStyle(
                              //                                       fontSize:
                              //                                           18,
                              //                                       fontWeight:
                              //                                           FontWeight
                              //                                               .bold),
                              //                                 ),
                              //                                 trailing:
                              //                                     const Icon(Icons
                              //                                         .arrow_forward_ios))),
                              //                         TextButton(
                              //                             onPressed: () async {
                              //                               // if (await _request_per(Permission.storage) ==
                              //                               //     true) {
                              //                               convertToPDF(
                              //                                   message.text);
                              //                               print(
                              //                                   "permission granted");
                              //                               // } else {
                              //                               //   print("permission not granted");
                              //                               // }
                              //                             },
                              //                             child: ListTile(
                              //                                 leading: Container(
                              //                                     height: 30,
                              //                                     width: 30,
                              //                                     color: Colors
                              //                                         .white,
                              //                                     child: Image
                              //                                         .asset(
                              //                                             "assets/pop.png")),
                              //                                 title: const Text(
                              //                                   "PDF",
                              //                                   style: TextStyle(
                              //                                       fontSize:
                              //                                           15,
                              //                                       fontWeight:
                              //                                           FontWeight
                              //                                               .bold),
                              //                                 ),
                              //                                 trailing:
                              //                                     const Icon(Icons
                              //                                         .arrow_forward_ios))),
                              //                         TextButton(
                              //                             onPressed: () async {
                              //                               // if (await _request_per(Permission.storage) ==
                              //                               //     true) {
                              //                               convertToDocx(
                              //                                   message.text);
                              //                               print(
                              //                                   "permission granted");
                              //                               // } else {
                              //                               //   print("permission not granted");
                              //                               // }
                              //                             },
                              //                             child: ListTile(
                              //                                 leading: Container(
                              //                                     height: 30,
                              //                                     width: 30,
                              //                                     color: Colors
                              //                                         .white,
                              //                                     child: Image
                              //                                         .asset(
                              //                                             "assets/word.png")),
                              //                                 title: const Text(
                              //                                   "Word",
                              //                                   style: TextStyle(
                              //                                       fontSize:
                              //                                           15,
                              //                                       fontWeight:
                              //                                           FontWeight
                              //                                               .bold),
                              //                                 ),
                              //                                 trailing:
                              //                                     const Icon(Icons
                              //                                         .arrow_forward_ios))),
                              //                         TextButton(
                              //                             onPressed: () async {
                              //                               // if (await _request_per(Permission.storage) ==
                              //                               //     true) {
                              //                               downloadTxt(
                              //                                   message.text);
                              //                               print(
                              //                                   "permission granted");
                              //                               // } else {
                              //                               //   print("permission not granted");
                              //                               // }
                              //                             },
                              //                             child: ListTile(
                              //                                 leading: Container(
                              //                                     height: 30,
                              //                                     width: 30,
                              //                                     color: Colors
                              //                                         .white,
                              //                                     child: Image
                              //                                         .asset(
                              //                                             "assets/text.png")),
                              //                                 title: const Text(
                              //                                   "Txt",
                              //                                   style: TextStyle(
                              //                                       fontSize:
                              //                                           15,
                              //                                       fontWeight:
                              //                                           FontWeight
                              //                                               .bold),
                              //                                 ),
                              //                                 trailing:
                              //                                     const Icon(Icons
                              //                                         .arrow_forward_ios))),
                              //                         TextButton(
                              //                             onPressed: () async {
                              //                               await Share.share(
                              //                                   message.text);
                              //                             },
                              //                             child: ListTile(
                              //                                 leading: Container(
                              //                                     height: 30,
                              //                                     width: 30,
                              //                                     color: Colors
                              //                                         .white,
                              //                                     child: Image
                              //                                         .asset(
                              //                                             "assets/share.png")),
                              //                                 title: const Text(
                              //                                   "Share",
                              //                                   style: TextStyle(
                              //                                       fontSize:
                              //                                           15,
                              //                                       fontWeight:
                              //                                           FontWeight
                              //                                               .bold),
                              //                                 ),
                              //                                 trailing:
                              //                                     const Icon(Icons
                              //                                         .arrow_forward_ios))),
                              //                       ],
                              //                     ),
                              //                   ),
                              //                 ),
                              //               )
                              //             ],
                              //           ),
                              //         ),
                              //       );
                              //     },
                              //     icon: SizedBox(
                              //       width: 12,
                              //       height: 13,
                              //       child: Image.asset("assets/dot.png"),
                              //     ))
                            ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "AI BOT",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Row(
            children: [
              SizedBox(width: 10),
              IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => SizedBox(
                        height: 400,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              decoration: const BoxDecoration(
                                color: Colors.black,
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
                                      const SizedBox(height: 60, width: 10),
                                      Text(
                                        "Quick Note",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(right: 40),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "X",
                                          style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 20,
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
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => home(
                                                    datas: allnote,
                                                  ),
                                                ));
                                            int a = messages.length;
                                            for (int i = 0; i < a; i++) {
                                              all = all +
                                                  "\n" +
                                                  "\n" +
                                                  messages[i];
                                            }
                                            save1(all);
                                          },
                                          child: ListTile(
                                              leading: Container(
                                                  height: 30,
                                                  width: 30,
                                                  color: Colors.white,
                                                  child: Icon(
                                                    Icons.save,
                                                    size: 30,
                                                  )),
                                              title: const Text(
                                                "save",
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              trailing: const Icon(
                                                  Icons.arrow_forward_ios))),
                                      TextButton(
                                          onPressed: () {
                                            int a = messages.length;
                                            for (int i = 0; i < a; i++) {
                                              all = all +
                                                  "\n" +
                                                  "\n" +
                                                  messages[i];
                                            }

                                            FlutterClipboard.copy(all);
                                            Get.snackbar("copied", "");
                                            Navigator.pop(context);
                                          },
                                          child: ListTile(
                                              leading: Container(
                                                  height: 30,
                                                  width: 30,
                                                  color: Colors.white,
                                                  child: Image.asset(
                                                      "assets/copy.png")),
                                              title: const Text(
                                                "copy to clipboard",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              trailing: const Icon(
                                                  Icons.arrow_forward_ios))),
                                      TextButton(
                                          onPressed: () async {
                                            // if (await _request_per(Permission.storage) ==
                                            //     true) {
                                            int a = messages.length;
                                            for (int i = 0; i < a; i++) {
                                              all = all +
                                                  "\n" +
                                                  "\n" +
                                                  messages[i];
                                            }

                                            convertToPDF(all);
                                            print("permission granted");
                                            // } else {
                                            //   print("permission not granted");
                                            // }
                                          },
                                          child: ListTile(
                                              leading: Container(
                                                  height: 30,
                                                  width: 30,
                                                  color: Colors.white,
                                                  child: Image.asset(
                                                      "assets/pop.png")),
                                              title: const Text(
                                                "PDF",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              trailing: const Icon(
                                                  Icons.arrow_forward_ios))),
                                      TextButton(
                                          onPressed: () async {
                                            // if (await _request_per(Permission.storage) ==
                                            //     true) {
                                            int a = messages.length;
                                            for (int i = 0; i < a; i++) {
                                              all = all +
                                                  "\n" +
                                                  "\n" +
                                                  messages[i];
                                            }
                                            save1(all);
                                            convertToDocx(all);
                                            print("permission granted");
                                            // } else {
                                            //   print("permission not granted");
                                            // }
                                          },
                                          child: ListTile(
                                              leading: Container(
                                                  height: 30,
                                                  width: 30,
                                                  color: Colors.white,
                                                  child: Image.asset(
                                                      "assets/word.png")),
                                              title: const Text(
                                                "Word",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              trailing: const Icon(
                                                  Icons.arrow_forward_ios))),
                                      TextButton(
                                          onPressed: () async {
                                            // if (await _request_per(Permission.storage) ==
                                            //     true) {
                                            int a = messages.length;
                                            for (int i = 0; i < a; i++) {
                                              all = all +
                                                  "\n" +
                                                  "\n" +
                                                  messages[i];
                                            }

                                            downloadTxt(all);
                                            print("permission granted");
                                            // } else {
                                            //   print("permission not granted");
                                            // }
                                          },
                                          child: ListTile(
                                              leading: Container(
                                                  height: 30,
                                                  width: 30,
                                                  color: Colors.white,
                                                  child: Image.asset(
                                                      "assets/text.png")),
                                              title: const Text(
                                                "Txt",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              trailing: const Icon(
                                                  Icons.arrow_forward_ios))),
                                      TextButton(
                                          onPressed: () async {
                                            int a = messages.length;
                                            for (int i = 0; i < a; i++) {
                                              all = all +
                                                  "\n" +
                                                  "\n" +
                                                  messages[i];
                                            }

                                            await Share.share(all);
                                          },
                                          child: ListTile(
                                              leading: Container(
                                                  height: 30,
                                                  width: 30,
                                                  color: Colors.white,
                                                  child: Image.asset(
                                                      "assets/share.png")),
                                              title: const Text(
                                                "Share",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              trailing: const Icon(
                                                  Icons.arrow_forward_ios))),
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
                    width: 15,
                    height: 15,
                    child: Image.asset("assets/dot.png"),
                  ))
            ],
          ),
        ],
        leading: IconButton(
            onPressed: () {
              int a = messages.length;
              for (int i = 0; i < a; i++) {
                all = all + "\n" + messages[i];
              }
              save1(all);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => home(datas: []),
                  ));
            },
            icon: Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.black,
            )),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                int reversedIndex = _messages.length - 1 - index;
                return _buildMessage(_messages[reversedIndex]);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(255, 218, 218, 218),
                      contentPadding: EdgeInsets.all(15.0),
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(25)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 218, 218, 218),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      onSendMessage();
                      FocusScopeNode focus = FocusScope.of(context);
                      if (!focus.hasPrimaryFocus) {
                        focus.unfocus();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Message {
  final String text;
  final bool isMe;

  Message({required this.text, required this.isMe});
}
