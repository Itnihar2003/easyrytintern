import 'dart:convert';

import 'package:clipboard/clipboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            tittle1: "OCR" +
                "(" +
                DateFormat.yMMMMEEEEd().format(DateTime.now()) +
                ")",
            content1: aimessage));
      });
      setdata1();
    } else {
      Get.snackbar("Error", "No data",
          backgroundColor: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                save1(widget.text);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => home(datas: const []),
                    ));
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
          title: const Text('Result'),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(30.0),
                child: SingleChildScrollView(
                    child: Container(child: Text(widget.text))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => home(datas: const []),
                        ));
                    save1(widget.text);
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Text(
                          "Save to Recents",
                          style: TextStyle(color: Colors.black),
                        ),
                      ))),
            )
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 60),
          child: TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => home(datas: const []),
                    ));
                FlutterClipboard.copy(widget.text);
                Get.snackbar("copied", "");
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.copy,
                color: Colors.black,
              )),
        ),
      );
}
