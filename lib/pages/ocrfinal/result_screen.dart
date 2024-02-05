import 'dart:convert';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoaiapp/pages/home/homepage.dart';
import 'package:todoaiapp/pages/notes/notedata.dart';

class ResultScreen extends StatefulWidget {
  final String text;

  const ResultScreen({super.key, required this.text});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
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
TextEditingController controller=TextEditingController();
  @override
  void initState() {
    update();

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
            tittle1:controller.text==""? "OCR" +
                "(" +
                DateFormat.yMMMMEEEEd().format(DateTime.now()) +
                ")":controller.text,
            content1: aimessage));
      });
      setdata1();
    } else {
      Get.snackbar("Error", "No data", backgroundColor: Colors.grey);
    }
  }

  String finalvalue = "";
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                save1(widget.text);
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
            IconButton(
                onPressed: () {
                  Share.share(widget.text);
                },
                icon: Icon(
                  Icons.share,
                  color: Colors.black,
                  size: 20,
                ))
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
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                child: TextFormField(
                  controller: controller,
                  maxLength: 100,
                  maxLines: 2,
                  autofocus: true,
                  obscureText: false,
                  decoration: InputDecoration(
                    hintText: "tittle",
                    hintStyle: GoogleFonts.poppins(
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
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(30.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Reasults..',
                    border: InputBorder.none,
                    hintStyle: GoogleFonts.poppins(
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
                  initialValue: widget.text,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: InkWell(
            onTap: () {
              save1(widget.text);
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
