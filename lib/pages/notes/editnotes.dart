import 'dart:convert';

import 'package:flutter/material.dart';


import 'package:share_plus/share_plus.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:todoaiapp/pages/home/homepage.dart';
import 'package:todoaiapp/pages/notes/notedata.dart';

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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: InkWell(
            onTap: () {
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
            child: const CircleAvatar(
              radius: 25,
              backgroundColor: Colors.black,
              child: Icon(
                Icons.replay_outlined,
                color: Colors.white,
                size: 30,
              ),
            )),
      ),
      body: SafeArea(
        top: true,
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
                            IconButton(
                                onPressed: () {}, icon: const Icon(Icons.undo)),
                            IconButton(
                                onPressed: () {}, icon: const Icon(Icons.redo)),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    if (finalvalue != "" &&
                                        finalcontent != "") {
                                      await Share.share(
                                          finalvalue + "\n" + finalcontent);
                                    } else {
                                      await Share.share(widget.tittle +
                                          "\n" +
                                          widget.content);
                                    }
                                  },
                                  icon: const Icon(Icons.share)),
                            ],
                          ),
                        )
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
                          // style: TextStyle(
                          //   fontSize: _fontSize,
                          //   color: _textColor,
                          //   fontFamily: _fontFamily,
                          //   fontStyle:
                          //       isItalic ? FontStyle.italic : FontStyle.normal,
                          //   fontWeight:
                          //       isBold ? FontWeight.bold : FontWeight.normal,
                          //   decoration: isUnderlined
                          //       ? TextDecoration.underline
                          //       : TextDecoration.none,
                          // ),
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
      // bottomNavigationBar: Container(
      //   color: Colors.white,
      //   height: 120,
      //   width: 400,
      //   child: Column(
      //     children: [
      //       SingleChildScrollView(
      //         scrollDirection: Axis.horizontal,
      //         child: StatefulBuilder(builder: (context, state) {
      //           return FastColorPicker(
      //             selectedColor: textColor,
      //             onColorSelected: (Color color) {
      //               state(() {});
      //               onColorChange(color);
      //             },
      //           );
      //         }),
      //       ),
      //       SingleChildScrollView(
      //         scrollDirection: Axis.horizontal,
      //         child: Row(
      //           children: [
      //             ElevatedButton(
      //               onPressed: () {
      //                 toggleItalic();
      //               },
      //               style: const ButtonStyle(
      //                 backgroundColor: MaterialStatePropertyAll<Color>(
      //                   Color.fromARGB(255, 255, 255, 255),
      //                 ),
      //                 foregroundColor:
      //                     MaterialStatePropertyAll<Color>(Colors.black),
      //               ),
      //               child: const Text('I',
      //                   style: TextStyle(
      //                       fontStyle: FontStyle.italic, fontSize: 16)),
      //             ),
      //             ElevatedButton(
      //               onPressed: () {
      //                 toggleBold();
      //               },
      //               style: const ButtonStyle(
      //                 backgroundColor: MaterialStatePropertyAll<Color>(
      //                   Color.fromARGB(255, 255, 255, 255),
      //                 ),
      //                 foregroundColor:
      //                     MaterialStatePropertyAll<Color>(Colors.black),
      //               ),
      //               child: const Text('B',
      //                   style: TextStyle(
      //                       fontWeight: FontWeight.bold, fontSize: 16)),
      //             ),
      //             ElevatedButton(
      //               onPressed: () {
      //                 toggleUnderlined();
      //               },
      //               style: const ButtonStyle(
      //                 backgroundColor: MaterialStatePropertyAll<Color>(
      //                   Color.fromARGB(255, 255, 255, 255),
      //                 ),
      //                 foregroundColor:
      //                     MaterialStatePropertyAll<Color>(Colors.black),
      //               ),
      //               child: const Text('U',
      //                   style: TextStyle(
      //                       decoration: TextDecoration.underline,
      //                       fontSize: 16)),
      //             ),
      //             ElevatedButton(
      //               onPressed: () {
      //                 toggleTextStart();
      //               },
      //               style: const ButtonStyle(
      //                 backgroundColor: MaterialStatePropertyAll<Color>(
      //                   Color.fromARGB(255, 255, 255, 255),
      //                 ),
      //                 foregroundColor:
      //                     MaterialStatePropertyAll<Color>(Colors.black),
      //               ),
      //               child: const Icon(Icons.align_horizontal_left),
      //             ),
      //             ElevatedButton(
      //               onPressed: () {
      //                 toggleTextCenter();
      //               },
      //               style: const ButtonStyle(
      //                 backgroundColor: MaterialStatePropertyAll<Color>(
      //                   Color.fromARGB(255, 255, 255, 255),
      //                 ),
      //                 foregroundColor:
      //                     MaterialStatePropertyAll<Color>(Colors.black),
      //               ),
      //               child: const Icon(Icons.align_horizontal_center),
      //             ),
      //             ElevatedButton(
      //               onPressed: () {
      //                 toggleTextEnd();
      //               },
      //               style: const ButtonStyle(
      //                 backgroundColor: MaterialStatePropertyAll<Color>(
      //                   Color.fromARGB(255, 255, 255, 255),
      //                 ),
      //                 foregroundColor:
      //                     MaterialStatePropertyAll<Color>(Colors.black),
      //               ),
      //               child: const Icon(Icons.align_horizontal_right),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
