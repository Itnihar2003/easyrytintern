import 'dart:convert';
import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoaiapp/main.dart';
import 'package:http/http.dart' as http;
import 'package:todoaiapp/pages/home/homepage.dart';
import 'package:todoaiapp/pages/notes/editnotes.dart';
import 'package:todoaiapp/pages/notes/notedata.dart';

class recent extends StatefulWidget {
  List<data1> datas;
  recent({
    super.key,
    required this.datas,
  });

  @override
  State<recent> createState() => _recentState();
}

class _recentState extends State<recent> {
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

  //permission
  Future<bool> _request_per(Permission permission) async {
    AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;
    if (build.version.sdkInt >= 10) {
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
        var result = await permission.request();
        if (result.isGranted) {
          return true;
        } else {
          return false;
        }
      }
    }
  }

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

  TextEditingController searchfilter = TextEditingController();
  List filter = [];
  String search = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recents Notes"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searchfilter,
                onChanged: (String value) {
                  setState(() {
                    search = value.toString();
                  });
                },
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(color: Colors.white)),
                    filled: true,
                    fillColor: Color.fromARGB(255, 236, 235, 235),
                    contentPadding: EdgeInsets.all(15.0),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    hintText: "Search",
                    hintStyle: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 156, 156, 156))),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: widget.datas.length,
                    itemBuilder: (BuildContext context, int index) {
                      String tittle = widget.datas[index].tittle1;
                      if (searchfilter.text.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => editnotes(
                                      tittle: widget.datas[index].tittle1,
                                      content: widget.datas[index].content1,
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
                              child: ListTile(
                                trailing: IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) => SizedBox(
                                          height: 400,
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
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft: Radius.circular(6),
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
                                                            const EdgeInsets
                                                                .only(
                                                                right: 10),
                                                        child: TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            "close",
                                                            style: GoogleFonts
                                                                .poppins(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15,
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
                                                              FlutterClipboard.copy(
                                                                  "${widget.datas[index].tittle1}\n${widget.datas[index].content1}");
                                                              Get.snackbar(
                                                                  "copied",
                                                                  "${widget.datas[index].tittle1}\n${widget.datas[index].content1}");
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: ListTile(
                                                                leading: Container(
                                                                    height: 20,
                                                                    width: 30,
                                                                    color: Colors
                                                                        .white,
                                                                    child: Image
                                                                        .asset(
                                                                            "assets/copy.png")),
                                                                title:
                                                                    const Text(
                                                                  "copy to clipboard",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                                trailing:
                                                                    const Icon(
                                                                  Icons
                                                                      .arrow_forward_ios,
                                                                  size: 20,
                                                                ))),
                                                        TextButton(
                                                            onPressed:
                                                                () async {
                                                              if (await _request_per(
                                                                      Permission
                                                                          .storage) ==
                                                                  true) {
                                                                convertToPDF(
                                                                    "${widget.datas[index].tittle1}\n\n${widget.datas[index].content1}");
                                                                print(
                                                                    "permission granted");
                                                              } else {
                                                                print(
                                                                    "permission not granted");
                                                              }
                                                            },
                                                            child: ListTile(
                                                                leading: Container(
                                                                    height: 20,
                                                                    width: 30,
                                                                    color: Colors
                                                                        .white,
                                                                    child: Image
                                                                        .asset(
                                                                            "assets/pop.png")),
                                                                title:
                                                                    const Text(
                                                                  "PDF",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                                trailing:
                                                                    const Icon(
                                                                  Icons
                                                                      .arrow_forward_ios,
                                                                  size: 20,
                                                                ))),
                                                        TextButton(
                                                            onPressed:
                                                                () async {
                                                              if (await _request_per(
                                                                      Permission
                                                                          .storage) ==
                                                                  true) {
                                                                convertToDocx(
                                                                    "${widget.datas[index].tittle1}\n\n${widget.datas[index].content1}");
                                                                print(
                                                                    "permission granted");
                                                              } else {
                                                                print(
                                                                    "permission not granted");
                                                              }
                                                            },
                                                            child: ListTile(
                                                                leading: Container(
                                                                    height: 20,
                                                                    width: 30,
                                                                    color: Colors
                                                                        .white,
                                                                    child: Image
                                                                        .asset(
                                                                            "assets/word.png")),
                                                                title:
                                                                    const Text(
                                                                  "Word",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                                trailing:
                                                                    const Icon(
                                                                  Icons
                                                                      .arrow_forward_ios,
                                                                  size: 20,
                                                                ))),
                                                        TextButton(
                                                            onPressed:
                                                                () async {
                                                              if (await _request_per(
                                                                      Permission
                                                                          .storage) ==
                                                                  true) {
                                                                downloadTxt(
                                                                    "${widget.datas[index].tittle1}\n\n${widget.datas[index].content1}");
                                                                print(
                                                                    "permission granted");
                                                              } else {
                                                                print(
                                                                    "permission not granted");
                                                              }
                                                            },
                                                            child: ListTile(
                                                                leading: Container(
                                                                    height: 20,
                                                                    width: 30,
                                                                    color: Colors
                                                                        .white,
                                                                    child: Image
                                                                        .asset(
                                                                            "assets/text.png")),
                                                                title:
                                                                    const Text(
                                                                  "Txt",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                                trailing:
                                                                    const Icon(
                                                                  Icons
                                                                      .arrow_forward_ios,
                                                                  size: 20,
                                                                ))),
                                                        TextButton(
                                                            onPressed:
                                                                () async {
                                                              await Share.share(widget
                                                                      .datas[
                                                                          index]
                                                                      .tittle1 +
                                                                  "\n" +
                                                                  widget
                                                                      .datas[
                                                                          index]
                                                                      .content1);
                                                            },
                                                            child: ListTile(
                                                                leading: Container(
                                                                    height: 20,
                                                                    width: 30,
                                                                    color: Colors
                                                                        .white,
                                                                    child: Image
                                                                        .asset(
                                                                            "assets/share.png")),
                                                                title:
                                                                    const Text(
                                                                  "Share",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                                trailing:
                                                                    const Icon(
                                                                  Icons
                                                                      .arrow_forward_ios,
                                                                  size: 20,
                                                                ))),
                                                        TextButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                widget.datas
                                                                    .removeAt(
                                                                        index);
                                                                setdata1();
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: ListTile(
                                                                leading:
                                                                    Container(
                                                                  height: 20,
                                                                  width: 30,
                                                                  color: Colors
                                                                      .white,
                                                                  child: Image
                                                                      .asset(
                                                                          "assets/delete.png"),
                                                                ),
                                                                title:
                                                                    const Text(
                                                                  "Delete",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                                trailing:
                                                                    const Icon(
                                                                  Icons
                                                                      .arrow_forward_ios,
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
                                    )),
                                title: Text(widget.datas[index].tittle1),
                              ),
                            ),
                          ),
                        );
                      } else if (tittle
                          .toLowerCase()
                          .contains(searchfilter.text.toLowerCase())) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => editnotes(
                                      tittle: widget.datas[index].tittle1,
                                      content: widget.datas[index].content1,
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
                              child: ListTile(
                                trailing: IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) => SizedBox(
                                          height: 400,
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
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft: Radius.circular(6),
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
                                                            const EdgeInsets
                                                                .only(
                                                                right: 10),
                                                        child: TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(
                                                            "close",
                                                            style: GoogleFonts
                                                                .poppins(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
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
                                                              FlutterClipboard.copy(
                                                                  "${widget.datas[index].tittle1}\n${widget.datas[index].content1}");
                                                              Get.snackbar(
                                                                  "copied",
                                                                  "${widget.datas[index].tittle1}\n${widget.datas[index].content1}");
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: ListTile(
                                                                leading: Container(
                                                                    height: 20,
                                                                    width: 30,
                                                                    color: Colors
                                                                        .white,
                                                                    child: Image
                                                                        .asset(
                                                                            "assets/copy.png")),
                                                                title:
                                                                    const Text(
                                                                  "copy to clipboard",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                                trailing:
                                                                    const Icon(
                                                                  Icons
                                                                      .arrow_forward_ios,
                                                                  size: 20,
                                                                ))),
                                                        TextButton(
                                                            onPressed:
                                                                () async {
                                                              if (await _request_per(
                                                                      Permission
                                                                          .storage) ==
                                                                  true) {
                                                                convertToPDF(
                                                                    "${widget.datas[index].tittle1}\n\n${widget.datas[index].content1}");
                                                                print(
                                                                    "permission granted");
                                                              } else {
                                                                print(
                                                                    "permission not granted");
                                                              }
                                                            },
                                                            child: ListTile(
                                                                leading: Container(
                                                                    height: 20,
                                                                    width: 30,
                                                                    color: Colors
                                                                        .white,
                                                                    child: Image
                                                                        .asset(
                                                                            "assets/pop.png")),
                                                                title:
                                                                    const Text(
                                                                  "PDF",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                                trailing:
                                                                    const Icon(
                                                                  Icons
                                                                      .arrow_forward_ios,
                                                                  size: 20,
                                                                ))),
                                                        TextButton(
                                                            onPressed:
                                                                () async {
                                                              if (await _request_per(
                                                                      Permission
                                                                          .storage) ==
                                                                  true) {
                                                                convertToDocx(
                                                                    "${widget.datas[index].tittle1}\n\n${widget.datas[index].content1}");
                                                                print(
                                                                    "permission granted");
                                                              } else {
                                                                print(
                                                                    "permission not granted");
                                                              }
                                                            },
                                                            child: ListTile(
                                                                leading: Container(
                                                                    height: 20,
                                                                    width: 30,
                                                                    color: Colors
                                                                        .white,
                                                                    child: Image
                                                                        .asset(
                                                                            "assets/word.png")),
                                                                title:
                                                                    const Text(
                                                                  "Word",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                                trailing:
                                                                    const Icon(
                                                                  Icons
                                                                      .arrow_forward_ios,
                                                                  size: 20,
                                                                ))),
                                                        TextButton(
                                                            onPressed:
                                                                () async {
                                                              if (await _request_per(
                                                                      Permission
                                                                          .storage) ==
                                                                  true) {
                                                                downloadTxt(
                                                                    "${widget.datas[index].tittle1}\n\n${widget.datas[index].content1}");
                                                                print(
                                                                    "permission granted");
                                                              } else {
                                                                print(
                                                                    "permission not granted");
                                                              }
                                                            },
                                                            child: ListTile(
                                                                leading: Container(
                                                                    height: 20,
                                                                    width: 30,
                                                                    color: Colors
                                                                        .white,
                                                                    child: Image
                                                                        .asset(
                                                                            "assets/text.png")),
                                                                title:
                                                                    const Text(
                                                                  "Txt",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                                trailing:
                                                                    const Icon(
                                                                  Icons
                                                                      .arrow_forward_ios,
                                                                  size: 20,
                                                                ))),
                                                        TextButton(
                                                            onPressed:
                                                                () async {
                                                              await Share.share(widget
                                                                      .datas[
                                                                          index]
                                                                      .tittle1 +
                                                                  "\n" +
                                                                  widget
                                                                      .datas[
                                                                          index]
                                                                      .content1);
                                                            },
                                                            child: ListTile(
                                                                leading: Container(
                                                                    height: 20,
                                                                    width: 30,
                                                                    color: Colors
                                                                        .white,
                                                                    child: Image
                                                                        .asset(
                                                                            "assets/share.png")),
                                                                title:
                                                                    const Text(
                                                                  "Share",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                                trailing:
                                                                    const Icon(
                                                                  Icons
                                                                      .arrow_forward_ios,
                                                                  size: 20,
                                                                ))),
                                                        TextButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                widget.datas
                                                                    .removeAt(
                                                                        index);
                                                                setdata1();
                                                              });
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: ListTile(
                                                                leading:
                                                                    Container(
                                                                  height: 20,
                                                                  width: 30,
                                                                  color: Colors
                                                                      .white,
                                                                  child: Image
                                                                      .asset(
                                                                          "assets/delete.png"),
                                                                ),
                                                                title:
                                                                    const Text(
                                                                  "Delete",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400),
                                                                ),
                                                                trailing:
                                                                    const Icon(
                                                                  Icons
                                                                      .arrow_forward_ios,
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
                                    )),
                                title: Text(widget.datas[index].tittle1),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  // child: GridView.builder(
                  //   physics: const NeverScrollableScrollPhysics(),
                  //   gridDelegate:
                  //       const SliverGridDelegateWithFixedCrossAxisCount(
                  //     mainAxisExtent: 200,
                  //     crossAxisCount: 2,
                  //     mainAxisSpacing: 10.0,
                  //   ),
                  //   itemCount:
                  //       widget.datas.length, // Total number of containers
                  //   itemBuilder: (BuildContext context, int index) {
                  //     String tittle = widget.datas[index].tittle1;
                  //     if (searchfilter.text.isEmpty) {
                  //       return Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: InkWell(
                  //           onTap: () {
                  //             Navigator.push(
                  //                 context,
                  //                 MaterialPageRoute(
                  //                   builder: (context) => editnotes(
                  //                     tittle: widget.datas[index].tittle1,
                  //                     content: widget.datas[index].content1,
                  //                     id: index,
                  //                     edit: widget.datas,
                  //                   ),
                  //                 ));
                  //           },
                  //           child: Container(
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(15),
                  //               color: Colors.white,
                  //               boxShadow: const [
                  //                 BoxShadow(
                  //                   color: Color.fromRGBO(0, 0, 0, 0.09),
                  //                   blurRadius: 1,
                  //                   spreadRadius: 0,
                  //                   offset: Offset(-4, 4),
                  //                 ),
                  //               ],
                  //             ),
                  //             child: Column(
                  //               mainAxisAlignment: MainAxisAlignment.start,
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Container(
                  //                   height: 50,
                  //                   padding: const EdgeInsets.symmetric(
                  //                       horizontal: 10, vertical: 2),
                  //                   width: double.infinity,
                  //                   child: Row(
                  //                     mainAxisAlignment:
                  //                         MainAxisAlignment.spaceBetween,
                  //                     children: [
                  //                       Container(
                  //                         width: 98,
                  //                         height: 22,
                  //                         child: Text(
                  //                           widget.datas[index].tittle1,
                  //                           style: GoogleFonts.poppins(
                  //                             color: Colors.black,
                  //                             fontSize: 13,
                  //                             fontWeight: FontWeight.bold,
                  //                           ),
                  //                         ),
                  //                       ),
                  //                       IconButton(
                  //                           onPressed: () {
                  //                             showModalBottomSheet(
                  //                               context: context,
                  //                               builder: (context) => SizedBox(
                  //                                 height: 400,
                  //                                 child: Column(
                  //                                   mainAxisAlignment:
                  //                                       MainAxisAlignment.start,
                  //                                   children: [
                  //                                     Container(
                  //                                       padding:
                  //                                           const EdgeInsets
                  //                                               .symmetric(
                  //                                               horizontal: 5),
                  //                                       decoration:
                  //                                           const BoxDecoration(
                  //                                         color: Colors.black,
                  //                                         borderRadius:
                  //                                             BorderRadius.only(
                  //                                           topLeft:
                  //                                               Radius.circular(
                  //                                                   6),
                  //                                           topRight:
                  //                                               Radius.circular(
                  //                                                   6),
                  //                                         ),
                  //                                       ),
                  //                                       child: Row(
                  //                                         mainAxisAlignment:
                  //                                             MainAxisAlignment
                  //                                                 .spaceBetween,
                  //                                         children: [
                  //                                           Row(
                  //                                             children: [
                  //                                               const SizedBox(
                  //                                                   height: 50,
                  //                                                   width: 10),
                  //                                               Text(
                  //                                                 "Quick Note",
                  //                                                 style: GoogleFonts
                  //                                                     .poppins(
                  //                                                   color: Colors
                  //                                                       .white,
                  //                                                   fontSize:
                  //                                                       17,
                  //                                                   fontWeight:
                  //                                                       FontWeight
                  //                                                           .w400,
                  //                                                 ),
                  //                                               ),
                  //                                             ],
                  //                                           ),
                  //                                           Padding(
                  //                                               padding:
                  //                                                   const EdgeInsets
                  //                                                       .only(
                  //                                                       right:
                  //                                                           10),
                  //                                               child:
                  //                                                   ElevatedButton(
                  //                                                 style: ElevatedButton.styleFrom(
                  //                                                     backgroundColor:
                  //                                                         Colors
                  //                                                             .black),
                  //                                                 onPressed:
                  //                                                     () {
                  //                                                   Navigator.pop(
                  //                                                       context);
                  //                                                 },
                  //                                                 child: Text(
                  //                                                   "close",
                  //                                                   style: GoogleFonts
                  //                                                       .poppins(
                  //                                                     color: Colors
                  //                                                         .white,
                  //                                                     fontSize:
                  //                                                         20,
                  //                                                     fontWeight:
                  //                                                         FontWeight
                  //                                                             .w500,
                  //                                                   ),
                  //                                                 ),
                  //                                               )),
                  //                                         ],
                  //                                       ),
                  //                                     ),
                  //                                     Expanded(
                  //                                       child: Container(
                  //                                         decoration:
                  //                                             const BoxDecoration(
                  //                                           color: Color(
                  //                                               0xFFF6F6F6),
                  //                                         ),
                  //                                         child:
                  //                                             SingleChildScrollView(
                  //                                           child: Column(
                  //                                             children: [
                  //                                               const SizedBox(
                  //                                                   height:
                  //                                                       2.5),
                  //                                               const Padding(
                  //                                                 padding:
                  //                                                     EdgeInsets
                  //                                                         .symmetric(
                  //                                                   horizontal:
                  //                                                       5,
                  //                                                   vertical:
                  //                                                       2.5,
                  //                                                 ),
                  //                                               ),
                  //                                               TextButton(
                  //                                                   onPressed:
                  //                                                       () {
                  //                                                     FlutterClipboard
                  //                                                         .copy(
                  //                                                             "${widget.datas[index].tittle1}\n${widget.datas[index].content1}");
                  //                                                     Get.snackbar(
                  //                                                         "copied",
                  //                                                         "${widget.datas[index].tittle1}\n${widget.datas[index].content1}");
                  //                                                     Navigator.pop(
                  //                                                         context);
                  //                                                   },
                  //                                                   child: ListTile(
                  //                                                       leading: Container(height: 20, width: 30, color: Colors.white, child: Image.asset("assets/copy.png")),
                  //                                                       title: const Text(
                  //                                                         "copy to clipboard",
                  //                                                         style: TextStyle(
                  //                                                             fontSize: 15,
                  //                                                             fontWeight: FontWeight.bold),
                  //                                                       ),
                  //                                                       trailing: const Icon(
                  //                                                         Icons
                  //                                                             .arrow_forward_ios,
                  //                                                         size:
                  //                                                             20,
                  //                                                       ))),
                  //                                               TextButton(
                  //                                                   onPressed:
                  //                                                       () async {
                  //                                                     // if (await _request_per(Permission.storage) ==
                  //                                                     //     true) {
                  //                                                     convertToPDF(
                  //                                                         "${widget.datas[index].tittle1}\n\n${widget.datas[index].content1}");
                  //                                                     print(
                  //                                                         "permission granted");
                  //                                                     // } else {
                  //                                                     //   print("permission not granted");
                  //                                                     // }
                  //                                                   },
                  //                                                   child: ListTile(
                  //                                                       leading: Container(height: 20, width: 30, color: Colors.white, child: Image.asset("assets/pop.png")),
                  //                                                       title: const Text(
                  //                                                         "PDF",
                  //                                                         style: TextStyle(
                  //                                                             fontSize: 15,
                  //                                                             fontWeight: FontWeight.bold),
                  //                                                       ),
                  //                                                       trailing: const Icon(
                  //                                                         Icons
                  //                                                             .arrow_forward_ios,
                  //                                                         size:
                  //                                                             20,
                  //                                                       ))),
                  //                                               TextButton(
                  //                                                   onPressed:
                  //                                                       () async {
                  //                                                     // if (await _request_per(Permission.storage) ==
                  //                                                     //     true) {
                  //                                                     convertToDocx(
                  //                                                         "${widget.datas[index].tittle1}\n\n${widget.datas[index].content1}");
                  //                                                     print(
                  //                                                         "permission granted");
                  //                                                     // } else {
                  //                                                     //   print("permission not granted");
                  //                                                     // }
                  //                                                   },
                  //                                                   child: ListTile(
                  //                                                       leading: Container(height: 20, width: 30, color: Colors.white, child: Image.asset("assets/word.png")),
                  //                                                       title: const Text(
                  //                                                         "Word",
                  //                                                         style: TextStyle(
                  //                                                             fontSize: 15,
                  //                                                             fontWeight: FontWeight.bold),
                  //                                                       ),
                  //                                                       trailing: const Icon(
                  //                                                         Icons
                  //                                                             .arrow_forward_ios,
                  //                                                         size:
                  //                                                             20,
                  //                                                       ))),
                  //                                               TextButton(
                  //                                                   onPressed:
                  //                                                       () async {
                  //                                                     // if (await _request_per(Permission.storage) ==
                  //                                                     //     true) {
                  //                                                     downloadTxt(
                  //                                                         "${widget.datas[index].tittle1}\n\n${widget.datas[index].content1}");
                  //                                                     print(
                  //                                                         "permission granted");
                  //                                                     // } else {
                  //                                                     //   print("permission not granted");
                  //                                                     // }
                  //                                                   },
                  //                                                   child: ListTile(
                  //                                                       leading: Container(height: 20, width: 30, color: Colors.white, child: Image.asset("assets/text.png")),
                  //                                                       title: const Text(
                  //                                                         "Txt",
                  //                                                         style: TextStyle(
                  //                                                             fontSize: 15,
                  //                                                             fontWeight: FontWeight.bold),
                  //                                                       ),
                  //                                                       trailing: const Icon(
                  //                                                         Icons
                  //                                                             .arrow_forward_ios,
                  //                                                         size:
                  //                                                             20,
                  //                                                       ))),
                  //                                               TextButton(
                  //                                                   onPressed:
                  //                                                       () async {
                  //                                                     await Share.share(widget
                  //                                                             .datas[
                  //                                                                 index]
                  //                                                             .tittle1 +
                  //                                                         "\n" +
                  //                                                         widget
                  //                                                             .datas[index]
                  //                                                             .content1);
                  //                                                   },
                  //                                                   child: ListTile(
                  //                                                       leading: Container(height: 20, width: 30, color: Colors.white, child: Image.asset("assets/share.png")),
                  //                                                       title: const Text(
                  //                                                         "Share",
                  //                                                         style: TextStyle(
                  //                                                             fontSize: 15,
                  //                                                             fontWeight: FontWeight.bold),
                  //                                                       ),
                  //                                                       trailing: const Icon(
                  //                                                         Icons
                  //                                                             .arrow_forward_ios,
                  //                                                         size:
                  //                                                             20,
                  //                                                       ))),
                  //                                               TextButton(
                  //                                                   onPressed:
                  //                                                       () {
                  //                                                     setState(
                  //                                                         () {
                  //                                                       widget
                  //                                                           .datas
                  //                                                           .removeAt(index);
                  //                                                       setdata1();
                  //                                                     });
                  //                                                     Navigator.pop(
                  //                                                         context);
                  //                                                   },
                  //                                                   child: ListTile(
                  //                                                       leading: Container(
                  //                                                         height:
                  //                                                             20,
                  //                                                         width:
                  //                                                             30,
                  //                                                         color:
                  //                                                             Colors.white,
                  //                                                         child:
                  //                                                             Image.asset("assets/delete.png"),
                  //                                                       ),
                  //                                                       title: const Text(
                  //                                                         "Delete",
                  //                                                         style: TextStyle(
                  //                                                             fontSize: 15,
                  //                                                             fontWeight: FontWeight.bold),
                  //                                                       ),
                  //                                                       trailing: const Icon(
                  //                                                         Icons
                  //                                                             .arrow_forward_ios,
                  //                                                         size:
                  //                                                             20,
                  //                                                       ))),
                  //                                             ],
                  //                                           ),
                  //                                         ),
                  //                                       ),
                  //                                     )
                  //                                   ],
                  //                                 ),
                  //                               ),
                  //                             );
                  //                           },
                  //                           icon: SizedBox(
                  //                             width: 12,
                  //                             height: 12,
                  //                             child:
                  //                                 Image.asset("assets/dot.png"),
                  //                           ))
                  //                     ],
                  //                   ),
                  //                 ),
                  //                 Padding(
                  //                   padding: const EdgeInsets.symmetric(
                  //                       horizontal: 8),
                  //                   child: SizedBox(
                  //                       height: 120,
                  //                       child: SingleChildScrollView(
                  //                           child: Text(
                  //                               widget.datas[index].content1))),
                  //                 )
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       );
                  //     } else if (tittle
                  //         .toLowerCase()
                  //         .contains(searchfilter.text.toLowerCase())) {
                  //       return Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: InkWell(
                  //           onTap: () {
                  //             Navigator.push(
                  //                 context,
                  //                 MaterialPageRoute(
                  //                   builder: (context) => editnotes(
                  //                     tittle: widget.datas[index].tittle1,
                  //                     content: widget.datas[index].content1,
                  //                     id: index,
                  //                     edit: widget.datas,
                  //                   ),
                  //                 ));
                  //           },
                  //           child: Container(
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(15),
                  //               color: Colors.white,
                  //               boxShadow: const [
                  //                 BoxShadow(
                  //                   color: Color.fromRGBO(0, 0, 0, 0.09),
                  //                   blurRadius: 1,
                  //                   spreadRadius: 0,
                  //                   offset: Offset(-4, 4),
                  //                 ),
                  //               ],
                  //             ),
                  //             child: Column(
                  //               mainAxisAlignment: MainAxisAlignment.start,
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 Container(
                  //                   height: 50,
                  //                   padding: const EdgeInsets.symmetric(
                  //                       horizontal: 10, vertical: 2),
                  //                   width: double.infinity,
                  //                   child: Row(
                  //                     mainAxisAlignment:
                  //                         MainAxisAlignment.spaceBetween,
                  //                     children: [
                  //                       Container(
                  //                         width: 98,
                  //                         height: 22,
                  //                         child: Text(
                  //                           tittle,
                  //                           style: GoogleFonts.poppins(
                  //                             color: Colors.black,
                  //                             fontSize: 13,
                  //                             fontWeight: FontWeight.bold,
                  //                           ),
                  //                         ),
                  //                       ),
                  //                       IconButton(
                  //                           onPressed: () {
                  //                             showModalBottomSheet(
                  //                               context: context,
                  //                               builder: (context) => SizedBox(
                  //                                 height: 400,
                  //                                 child: Column(
                  //                                   mainAxisAlignment:
                  //                                       MainAxisAlignment.start,
                  //                                   children: [
                  //                                     Container(
                  //                                       padding:
                  //                                           const EdgeInsets
                  //                                               .symmetric(
                  //                                               horizontal: 5),
                  //                                       decoration:
                  //                                           const BoxDecoration(
                  //                                         color: Colors.black,
                  //                                         borderRadius:
                  //                                             BorderRadius.only(
                  //                                           topLeft:
                  //                                               Radius.circular(
                  //                                                   6),
                  //                                           topRight:
                  //                                               Radius.circular(
                  //                                                   6),
                  //                                         ),
                  //                                       ),
                  //                                       child: Row(
                  //                                         mainAxisAlignment:
                  //                                             MainAxisAlignment
                  //                                                 .spaceBetween,
                  //                                         children: [
                  //                                           Row(
                  //                                             children: [
                  //                                               const SizedBox(
                  //                                                   height: 50,
                  //                                                   width: 10),
                  //                                               Text(
                  //                                                 "Quick Note",
                  //                                                 style: GoogleFonts
                  //                                                     .poppins(
                  //                                                   color: Colors
                  //                                                       .white,
                  //                                                   fontSize:
                  //                                                       17,
                  //                                                   fontWeight:
                  //                                                       FontWeight
                  //                                                           .w400,
                  //                                                 ),
                  //                                               ),
                  //                                             ],
                  //                                           ),
                  //                                           Padding(
                  //                                               padding:
                  //                                                   const EdgeInsets
                  //                                                       .only(
                  //                                                       right:
                  //                                                           10),
                  //                                               child:
                  //                                                   ElevatedButton(
                  //                                                 style: ElevatedButton.styleFrom(
                  //                                                     backgroundColor:
                  //                                                         Colors
                  //                                                             .black),
                  //                                                 onPressed:
                  //                                                     () {
                  //                                                   Navigator.pop(
                  //                                                       context);
                  //                                                 },
                  //                                                 child: Text(
                  //                                                   "close",
                  //                                                   style: GoogleFonts
                  //                                                       .poppins(
                  //                                                     color: Colors
                  //                                                         .white,
                  //                                                     fontSize:
                  //                                                         20,
                  //                                                     fontWeight:
                  //                                                         FontWeight
                  //                                                             .w500,
                  //                                                   ),
                  //                                                 ),
                  //                                               )),
                  //                                         ],
                  //                                       ),
                  //                                     ),
                  //                                     Expanded(
                  //                                       child: Container(
                  //                                         decoration:
                  //                                             const BoxDecoration(
                  //                                           color: Color(
                  //                                               0xFFF6F6F6),
                  //                                         ),
                  //                                         child:
                  //                                             SingleChildScrollView(
                  //                                           child: Column(
                  //                                             children: [
                  //                                               const SizedBox(
                  //                                                   height:
                  //                                                       2.5),
                  //                                               const Padding(
                  //                                                 padding:
                  //                                                     EdgeInsets
                  //                                                         .symmetric(
                  //                                                   horizontal:
                  //                                                       5,
                  //                                                   vertical:
                  //                                                       2.5,
                  //                                                 ),
                  //                                               ),
                  //                                               TextButton(
                  //                                                   onPressed:
                  //                                                       () {
                  //                                                     FlutterClipboard
                  //                                                         .copy(
                  //                                                             "${widget.datas[index].tittle1}\n${widget.datas[index].content1}");
                  //                                                     Get.snackbar(
                  //                                                         "copied",
                  //                                                         "${widget.datas[index].tittle1}\n${widget.datas[index].content1}");
                  //                                                     Navigator.pop(
                  //                                                         context);
                  //                                                   },
                  //                                                   child: ListTile(
                  //                                                       leading: Container(height: 20, width: 30, color: Colors.white, child: Image.asset("assets/copy.png")),
                  //                                                       title: const Text(
                  //                                                         "copy to clipboard",
                  //                                                         style: TextStyle(
                  //                                                             fontSize: 15,
                  //                                                             fontWeight: FontWeight.bold),
                  //                                                       ),
                  //                                                       trailing: const Icon(
                  //                                                         Icons
                  //                                                             .arrow_forward_ios,
                  //                                                         size:
                  //                                                             20,
                  //                                                       ))),
                  //                                               TextButton(
                  //                                                   onPressed:
                  //                                                       () async {
                  //                                                     // if (await _request_per(Permission.storage) ==
                  //                                                     //     true) {
                  //                                                     convertToPDF(
                  //                                                         "${widget.datas[index].tittle1}\n\n${widget.datas[index].content1}");
                  //                                                     print(
                  //                                                         "permission granted");
                  //                                                     // } else {
                  //                                                     //   print("permission not granted");
                  //                                                     // }
                  //                                                   },
                  //                                                   child: ListTile(
                  //                                                       leading: Container(height: 20, width: 30, color: Colors.white, child: Image.asset("assets/pop.png")),
                  //                                                       title: const Text(
                  //                                                         "PDF",
                  //                                                         style: TextStyle(
                  //                                                             fontSize: 15,
                  //                                                             fontWeight: FontWeight.bold),
                  //                                                       ),
                  //                                                       trailing: const Icon(
                  //                                                         Icons
                  //                                                             .arrow_forward_ios,
                  //                                                         size:
                  //                                                             20,
                  //                                                       ))),
                  //                                               TextButton(
                  //                                                   onPressed:
                  //                                                       () async {
                  //                                                     // if (await _request_per(Permission.storage) ==
                  //                                                     //     true) {
                  //                                                     convertToDocx(
                  //                                                         "${widget.datas[index].tittle1}\n\n${widget.datas[index].content1}");
                  //                                                     print(
                  //                                                         "permission granted");
                  //                                                     // } else {
                  //                                                     //   print("permission not granted");
                  //                                                     // }
                  //                                                   },
                  //                                                   child: ListTile(
                  //                                                       leading: Container(height: 20, width: 30, color: Colors.white, child: Image.asset("assets/word.png")),
                  //                                                       title: const Text(
                  //                                                         "Word",
                  //                                                         style: TextStyle(
                  //                                                             fontSize: 15,
                  //                                                             fontWeight: FontWeight.bold),
                  //                                                       ),
                  //                                                       trailing: const Icon(
                  //                                                         Icons
                  //                                                             .arrow_forward_ios,
                  //                                                         size:
                  //                                                             20,
                  //                                                       ))),
                  //                                               TextButton(
                  //                                                   onPressed:
                  //                                                       () async {
                  //                                                     // if (await _request_per(Permission.storage) ==
                  //                                                     //     true) {
                  //                                                     downloadTxt(
                  //                                                         "${widget.datas[index].tittle1}\n\n${widget.datas[index].content1}");
                  //                                                     print(
                  //                                                         "permission granted");
                  //                                                     // } else {
                  //                                                     //   print("permission not granted");
                  //                                                     // }
                  //                                                   },
                  //                                                   child: ListTile(
                  //                                                       leading: Container(height: 20, width: 30, color: Colors.white, child: Image.asset("assets/text.png")),
                  //                                                       title: const Text(
                  //                                                         "Txt",
                  //                                                         style: TextStyle(
                  //                                                             fontSize: 15,
                  //                                                             fontWeight: FontWeight.bold),
                  //                                                       ),
                  //                                                       trailing: const Icon(
                  //                                                         Icons
                  //                                                             .arrow_forward_ios,
                  //                                                         size:
                  //                                                             20,
                  //                                                       ))),
                  //                                               TextButton(
                  //                                                   onPressed:
                  //                                                       () async {
                  //                                                     await Share.share(widget
                  //                                                             .datas[
                  //                                                                 index]
                  //                                                             .tittle1 +
                  //                                                         "\n" +
                  //                                                         widget
                  //                                                             .datas[index]
                  //                                                             .content1);
                  //                                                   },
                  //                                                   child: ListTile(
                  //                                                       leading: Container(height: 20, width: 30, color: Colors.white, child: Image.asset("assets/share.png")),
                  //                                                       title: const Text(
                  //                                                         "Share",
                  //                                                         style: TextStyle(
                  //                                                             fontSize: 15,
                  //                                                             fontWeight: FontWeight.bold),
                  //                                                       ),
                  //                                                       trailing: const Icon(
                  //                                                         Icons
                  //                                                             .arrow_forward_ios,
                  //                                                         size:
                  //                                                             20,
                  //                                                       ))),
                  //                                               TextButton(
                  //                                                   onPressed:
                  //                                                       () {
                  //                                                     setState(
                  //                                                         () {
                  //                                                       widget
                  //                                                           .datas
                  //                                                           .removeAt(index);
                  //                                                       setdata1();
                  //                                                     });
                  //                                                     Navigator.pop(
                  //                                                         context);
                  //                                                   },
                  //                                                   child: ListTile(
                  //                                                       leading: Container(
                  //                                                         height:
                  //                                                             20,
                  //                                                         width:
                  //                                                             30,
                  //                                                         color:
                  //                                                             Colors.white,
                  //                                                         child:
                  //                                                             Image.asset("assets/delete.png"),
                  //                                                       ),
                  //                                                       title: const Text(
                  //                                                         "Delete",
                  //                                                         style: TextStyle(
                  //                                                             fontSize: 15,
                  //                                                             fontWeight: FontWeight.bold),
                  //                                                       ),
                  //                                                       trailing: const Icon(
                  //                                                         Icons
                  //                                                             .arrow_forward_ios,
                  //                                                         size:
                  //                                                             20,
                  //                                                       ))),
                  //                                             ],
                  //                                           ),
                  //                                         ),
                  //                                       ),
                  //                                     )
                  //                                   ],
                  //                                 ),
                  //                               ),
                  //                             );
                  //                           },
                  //                           icon: SizedBox(
                  //                             width: 12,
                  //                             height: 12,
                  //                             child:
                  //                                 Image.asset("assets/dot.png"),
                  //                           ))
                  //                     ],
                  //                   ),
                  //                 ),
                  //                 Padding(
                  //                   padding: const EdgeInsets.symmetric(
                  //                       horizontal: 8),
                  //                   child: SizedBox(
                  //                       height: 120,
                  //                       child: SingleChildScrollView(
                  //                           child: Text(
                  //                               widget.datas[index].content1))),
                  //                 )
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       );
                  //     } else {
                  //       return Container();
                  //     }
                  //   },
                  // ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
