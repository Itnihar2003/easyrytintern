import 'dart:async';
import 'dart:convert';

import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoaiapp/pages/home/homepage.dart';
import 'package:todoaiapp/pages/notes/notedata.dart';

import 'package:translator/translator.dart';

class ResultScreen extends StatefulWidget {
  final String text;

  const ResultScreen({super.key, required this.text});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final translater = GoogleTranslator();
  List<String> languages = [
    'English',
    'Hindi',
    'Arabic	',
    'German',
    'Russian',
    'Spanish',
    'Urdu',
    'Japanese	',
    'Italian'
  ];
  List<String> languagescode = [
    'en',
    'hi',
    'ar',
    'de',
    'ru',
    'es',
    'ur',
    'ja',
    'it'
  ];
  String from = 'en';
  String to = 'en';
  String data = "";
  String selectedvalue = 'English';
  String selectedvalue2 = 'English';

  final formkey = GlobalKey<FormState>();
  bool isloading = false;
  translate() async {
    try {
      if (formkey.currentState!.validate()) {
        await translater
            .translate(controller.text, from: from, to: to)
            .then((value) {
          data = value.text;
          isloading = false;
          setState(() {});
          // print(value);
        });
      }
    } on SocketException catch (_) {
      isloading = true;
      SnackBar mysnackbar = const SnackBar(
        content: Text('Internet not Connected'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 5),
      );
      ScaffoldMessenger.of(context).showSnackBar(mysnackbar);
      setState(() {});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  // @override
  // void initState() {
  //   super.initState();
  //   translate();
  // }
  List<data1> allnote = [];
  TextEditingController controller3 = TextEditingController();
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

  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    update();
    setState(() {
      controller.text = widget.text;
    });
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog<String>(
        context: context,
        builder: (BuildContext context) => new AlertDialog(
          surfaceTintColor: Colors.transparent,
          title: Column(
            children: [
              Text(
                "Select Language",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                hint: const Text('Search Language'),
                value: selectedvalue2,
                focusColor: Colors.transparent,
                items: languages.map((lang) {
                  return DropdownMenuItem(
                    value: lang,
                    child: Text(lang),
                    onTap: () {
                      if (lang == languages[0]) {
                        to = languagescode[0];
                      } else if (lang == languages[1]) {
                        to = languagescode[1];
                      } else if (lang == languages[2]) {
                        to = languagescode[2];
                      } else if (lang == languages[3]) {
                        to = languagescode[3];
                      } else if (lang == languages[4]) {
                        to = languagescode[4];
                      } else if (lang == languages[5]) {
                        to = languagescode[5];
                      } else if (lang == languages[6]) {
                        to = languagescode[6];
                      } else if (lang == languages[7]) {
                        to = languagescode[7];
                      } else if (lang == languages[8]) {
                        to = languagescode[8];
                      }
                      setState(() {
                        print(lang);
                        print(from);
                      });
                    },
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedvalue2 = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    isconvert = false;
                  });
                  Navigator.of(context).pop();
                  translate();
                
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.white),
                    fixedSize: const MaterialStatePropertyAll(Size(300, 45))),
                child: isloading
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Translate',
                        style: TextStyle(color: Colors.black),
                      )),
          ],
        ),
      );
    });
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
            tittle1: controller3.text == ""
                ? "OCR" +
                    "(" +
                    DateFormat.yMMMMEEEEd().format(DateTime.now()) +
                    ")"
                : controller.text,
            content1: data));
      });
      setdata1();
    }
  }

  String finalvalue = "";
  bool isconvert = true;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                save1(data);
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
                      Share.share(data);
                    },
                    icon: Icon(
                      Icons.share,
                      color: Colors.black,
                      size: 20,
                    )),
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.transparent)),
                child: isconvert
                    ? Form(
                        key: formkey,
                        child: TextFormField(
                          controller: controller,
                          maxLines: null,
                          minLines: null,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.done,
                          decoration: const InputDecoration(
                              enabledBorder: InputBorder.none,
                              border: InputBorder.none,
                              errorBorder: InputBorder.none,
                              errorStyle: TextStyle(color: Colors.white)),
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      )
                    : Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                        child: TextFormField(
                          controller: controller3,
                          maxLength: 100,
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
              ),

              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.transparent)),
                child: Center(
                  child: SelectableText(
                    data,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
              //   child: TextFormField(
              //     controller: controller,
              //     maxLength: 100,
              //     maxLines: 2,
              //     autofocus: true,
              //     obscureText: false,
              //     decoration: InputDecoration(
              //       hintText: "tittle",
              //       hintStyle: TextStyle(
              //         color: const Color(0xFFBFBFBF),
              //         fontSize: 18,
              //         fontWeight: FontWeight.w500,
              //       ),
              //       enabledBorder: InputBorder.none,
              //       focusedBorder: InputBorder.none,
              //       errorBorder: InputBorder.none,
              //       focusedErrorBorder: InputBorder.none,
              //     ),
              //   ),
              // ),

              // const SizedBox(
              //   height: 30,
              // ),

              // Container(
              //   height: MediaQuery.of(context).size.height,
              //   width: MediaQuery.of(context).size.width,
              //   padding: const EdgeInsets.all(30.0),
              //   child: TextFormField(
              //     decoration: InputDecoration(
              //       hintText: 'Reasults..',
              //       border: InputBorder.none,
              //       hintStyle: TextStyle(
              //         color: const Color(0xFFBFBFBF),
              //         fontSize: 12,
              //         fontWeight: FontWeight.w500,
              //       ),
              //       enabledBorder: InputBorder.none,
              //       focusedBorder: InputBorder.none,
              //       errorBorder: InputBorder.none,
              //       focusedErrorBorder: InputBorder.none,
              //     ),
              //     maxLines: null,
              //     initialValue: widget.text,
              //   ),
              // ),
            ],
          ),
        ),

        // floatingActionButton: InkWell(
        //     onTap: () {
        //       save1(widget.text);
        //       Navigator.of(context).pushAndRemoveUntil(
        //           MaterialPageRoute(
        //             builder: (context) => home(
        //               datas: [],
        //             ),
        //           ),
        //           (Route) => false);
        //     },
        //     child: const CircleAvatar(
        //       radius: 25,
        //       backgroundColor: Colors.black,
        //       child: Icon(
        //         Icons.add,
        //         color: Colors.white,
        //         size: 30,
        //       ),
        //     )),
        // Padding(
        //   padding: const EdgeInsets.only(bottom: 60),
        //   child: TextButton(
        //       onPressed: () {
        //         Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //               builder: (context) => home(datas: const []),
        //             ));
        //         FlutterClipboard.copy(finalvalue);
        //         Get.snackbar("copied", "");
        //         Navigator.pop(context);
        //       },
        //       child: const Icon(
        //         Icons.copy,
        //         color: Colors.black,
        //       )),
        // ),
      );
}
