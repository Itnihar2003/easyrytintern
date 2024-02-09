import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoaiapp/main.dart';
import 'package:todoaiapp/pages/home/homepage.dart';
import 'package:todoaiapp/pages/notes/notedata.dart';

class ai2 extends StatefulWidget {
  final String givendata;
  final String givencontent;
  const ai2({super.key, required this.givendata, required this.givencontent});
  @override
  _aiState createState() => _aiState();
}

class _aiState extends State<ai2> {
  List<data1> allnote = [];
  bool issend = false;
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
    startrewardad();
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
            tittle1: messages[0].toString() +
                "(" +
                DateFormat.yMMMMEEEEd().format(DateTime.now()) +
                ")",
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
  //rewardbanner

  late RewardedAd _rewardedAd;
  startrewardad() {
    RewardedAd.load(
        adUnitId: "ca-app-pub-3940256099942544/5224354917",
        // adUnitId: "ca-app-pub-1396556165266132/1772804526",
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (RewardedAd ad) {
              this._rewardedAd = ad;
            },
            onAdFailedToLoad: (LoadAdError error) {}));
  }

  showreward() {
    _rewardedAd.show(
      onUserEarnedReward: (ad, reward) {
        print("Rewarded money${reward.amount}");
      },
    );
    _rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {},
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
      },
      onAdWillDismissFullScreenContent: (ad) {
        ad.dispose();
      },
      onAdImpression: (ad) {
        print("$ad impression occure");
      },
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

  final TextEditingController _textEditingController = TextEditingController();
  final TextEditingController edittext = TextEditingController();
  void onSendMessage() async {
    Message message = Message(
        text: _textEditingController.text + " " + widget.givendata, isMe: true);

    _textEditingController.clear();

    setState(() {
      issend = true;
      _messages.insert(0, message);
    });

    String response = await sendMessageToChatGpt(message.text);

    Message chatGpt = Message(text: response, isMe: false);

    setState(() {
      _messages.insert(0, chatGpt);
      issend = false;
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
    return Column(
      children: [
        Container(
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
                            width: 38, child: Image.asset("assets/gpt4.png")),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      message.isMe ? 'You' : "Nota Ai",
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
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            title: Text("Suggestions"),
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
                                              onPressed: () {
                                                showreward();
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          home(
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
                                                      height: 20,
                                                      width: 30,
                                                      color: Colors.white,
                                                      child: Icon(
                                                        Icons.add_box_outlined,
                                                        size: 30,
                                                      )),
                                                  title: const Text(
                                                    "Save",
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
                                                      height: 20,
                                                      width: 30,
                                                      color: Colors.white,
                                                      child: Image.asset(
                                                          "assets/copy.png")),
                                                  title: const Text(
                                                    "Copy to clipboard",
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
                                                showreward();
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
                                                showreward();
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
                                                showreward();
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
                                                      height: 20,
                                                      width: 30,
                                                      color: Colors.white,
                                                      child: Image.asset(
                                                          "assets/share.png")),
                                                  title: const Text(
                                                    "Share",
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
                        width: 15,
                        height: 15,
                        child: Image.asset("assets/dot.png"),
                      ))
                ],
              ),
            ],
            leading: IconButton(
                onPressed: () {
                  showreward();
                  int a = messages.length;
                  for (int i = 0; i < a; i++) {
                    all = all + "\n" + messages[i];
                  }
                  save1(all);
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
                  size: 30,
                  color: Colors.black,
                )),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: Text(
                  widget.givendata,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          maxLines: 5,
                          controller: _textEditingController,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Colors.white)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(color: Colors.white)),
                              filled: true,
                              fillColor: Color.fromARGB(255, 248, 246, 246),
                              contentPadding: EdgeInsets.all(15.0),
                              hintText: 'Write your requirement here.',
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: const Color.fromARGB(
                                      255, 185, 185, 185))),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Center(
                child: Text(
                  widget.givencontent,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  controller: _scrollController,
                  itemCount: _messages.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == _messages.length) {
                      return Container(
                        height: 300,
                      );
                    }
                    int reversedIndex = _messages.length - 1 - index;
                    return _buildMessage(_messages[reversedIndex]);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  issend ? "Ai is Writing..." : "",
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: ElevatedButton(
                    child: Text(
                      "Generate",
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      if (issend == false &&
                          _textEditingController.text != "") {
                        onSendMessage();
                      }
                      FocusScopeNode focus = FocusScope.of(context);
                      if (!focus.hasPrimaryFocus) {
                        focus.unfocus();
                      }
                    },
                  ),
                ),
              ),
            ],
          )),
    );
    // floatingActionButton: Padding(
    //   padding: const EdgeInsets.only(bottom: 50),
    //   child: CircleAvatar(
    //     radius: 25,
    //     backgroundColor: const Color.fromARGB(255, 218, 218, 218),
    //     child: IconButton(
    //         onPressed: () {
    //           int a = messages.length;
    //           for (int i = 0; i < a; i++) {
    //             all = all + "\n" + messages[i];
    //           }
    //           save1(all);
    //           Navigator.push(
    //               context,
    //               MaterialPageRoute(
    //                 builder: (context) => home(datas: []),
    //               ));
    //         },
    //         icon: Padding(
    //           padding: const EdgeInsets.only(bottom: 60),
    //           child: Icon(
    //             Icons.save_alt_outlined,
    //             size: 30,
    //             color: Colors.black,
    //           ),
    //         )),
    //   ),
    // ));
  }
}

class Message {
  final String text;
  final bool isMe;

  Message({required this.text, required this.isMe});
}
