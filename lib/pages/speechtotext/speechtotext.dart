import 'dart:convert';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:todoaiapp/pages/home/homepage.dart';
import 'package:todoaiapp/pages/notes/notedata.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
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
            tittle1: "converted text" +
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

  TextEditingController controller = TextEditingController();

  int selectedindex = -1;

  TextEditingController controler = TextEditingController();

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "";
  double _confidence = 1.0;
  String finaltext = "";
  @override
  void initState() {
    update();
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              save1(finaltext);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => home(datas: []),
                  ));
            },
            icon: Icon(
              Icons.arrow_back,
              size: 30,
            )),
        actions: [
          IconButton(
              onPressed: () async {
                await Share.share(controler.text);
              },
              icon: Icon(
                Icons.share,
                size: 20,
                color: Colors.black,
              ))
        ],
        title: const Text("speech to text converter"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        duration: const Duration(milliseconds: 4000),
        repeat: true,
        child: GestureDetector(
          onTapDown: (details) async {
            if (!_isListening) {
              bool available = await _speech.initialize(
                onStatus: (val) => print('onStatus: $val'),
                onError: (val) => print('onError: $val'),
              );
              if (available) {
                setState(() => _isListening = true);
                _speech.listen(onResult: (val) {
                  setState(() {
                    finaltext = "$finaltext $_text";
                    controler.text = finaltext;
                  });

                  setState(() {
                    _text = val.recognizedWords;

                    if (val.hasConfidenceRating && val.confidence > 0) {
                      _confidence = val.confidence;
                    }
                  });
                });
              }
            }
          },
          onTapUp: (details) {
            setState(() => _isListening = false);
            _speech.stop();
          },
          child: const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.black,
            child: Icon(
              Icons.mic,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Container(
              height: 600,
              decoration: BoxDecoration(border: Border.all()),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      maxLength: 1000,
                      maxLines: 30,
                      decoration: const InputDecoration(
                          hintText: 'Press the button and start speaking',
                          border: OutlineInputBorder()),
                      controller: controler,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "press mic and speak and again press to send text",
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Center(
                      child: Text(
                        'Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        FlutterClipboard.copy(controler.text);
                      },
                      child: const Text("copy"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
