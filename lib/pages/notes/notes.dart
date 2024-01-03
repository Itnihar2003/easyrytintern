import 'dart:convert';
import 'dart:io';

import 'package:fast_color_picker/fast_color_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:todoaiapp/pages/homepage.dart';

class notes extends StatefulWidget {
  const notes({Key? key}) : super(key: key);

  @override
  _notesState createState() => _notesState();
}

class _notesState extends State<notes> {
  Color selectedColor = Colors.white;
  double _fontSize = 20.0;
  Color _textColor = Colors.black;
  String _fontFamily = 'Roboto';
  bool isItalic = false;
  bool isBold = false;
  bool isUnderlined = false;
  bool isTextStart = true;
  bool isTextEnd = false;
  bool isTextCenter = false;
  Color _fontColor = Colors.black;
  void updateFontSize(double newSize) {
    setState(() {
      fontSize = newSize;
    });
  }

  void updateColor(Color newColor) {
    setState(() {
      _fontColor = newColor;
    });
  }

  var _newFontWeight = FontWeight.w300;
  final List<Color> colors = [
    Colors.orange,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.teal,
    Colors.cyan,
    Colors.purple,
  ];
  final _FontWeight = [
    FontWeight.w200,
    FontWeight.w900,
    FontWeight.w700,
    FontWeight.w800,
    FontWeight.w300,
    FontWeight.w400,
    FontWeight.w500,
    FontWeight.w600,
    FontWeight.w100,
    FontWeight.w200,
  ];
  double colorSize = 50; // Custom size for color containers
  double paddingBetweenColors = 30;
  double fontSize = 20; // Custom padding between colors
  Color textColor = Colors.black;
  String fontFamily = "Roboto";

  bool extraBottomItems = false;
  void toggleItalic() {
    setState(() {
      isItalic = !isItalic;
    });
  }

  void toggleBold() {
    setState(() {
      isBold = !isBold;
    });
  }

  void toggleUnderlined() {
    setState(() {
      isUnderlined = !isUnderlined;
    });
  }

  void toggleTextStart() {
    if (!isTextStart) {
      isTextStart = true;
      isTextCenter = false;
      isTextEnd = false;
    }
    setState(() {});
  }

  void toggleTextEnd() {
    if (!isTextEnd) {
      isTextStart = false;
      isTextCenter = false;
      isTextEnd = true;
    } else {
      isTextStart = true;
      isTextCenter = false;
      isTextEnd = false;
    }
    setState(() {});
  }

  void toggleTextCenter() {
    if (!isTextCenter) {
      isTextStart = false;
      isTextCenter = true;
      isTextEnd = false;
    } else {
      isTextStart = true;
      isTextCenter = false;
      isTextEnd = false;
    }
    setState(() {});
  }

  void onColorSelected(Color color) {
    setState(() {
      selectedColor = color;
    });
  }

  void onSizeChange(value) {
    setState(() {
      _fontSize = value;
    });
  }

  void onColorChange(Color color) {
    setState(() {
      _textColor = color;
    });
  }

  void onFamilyChange(String type) {
    setState(() {
      _fontFamily = type.toString();
    });
  }

  Future<void> loadContent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      titleController.text = prefs.getString('title') ?? '';
      writingController.text = prefs.getString('content') ?? '';

      final selectedColorValue = prefs.getInt('selectedColor');
      selectedColor = Color(selectedColorValue ?? Colors.white.value);
      // Load other properties here as well.
    });
  }

  @override
  void initState() {
    super.initState();
    loadContent();
  }

  save() {
    String savedtittle = titleController.text;
    String savedcontent = writingController.text;
    titleController.clear();
    writingController.clear();
    if (savedtittle != "" && savedcontent != "") {
      FirebaseDatabase.instance
          .ref("post")
          .child(savedtittle)
          .set({"tittle": savedtittle, "content": savedcontent});
    } else {
      Get.snackbar("Error", "Plese fill all data",
          backgroundColor: Colors.grey);
    }
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController writingController = TextEditingController();

  // Flag to track whether the keyboard is open
  bool isKeyboardOpen = false;
  bool isbold = false;
  bool isitalic = false;
  bool isunderline = false;

  String? selectedText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => home(),
                  ));
              save();
            },
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.black,
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
            )),
      ),
      body: SafeArea(
        top: true,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
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
                                icon: Icon(Icons.arrow_back)),
                            IconButton(
                                onPressed: () {}, icon: Icon(Icons.undo)),
                            IconButton(
                                onPressed: () {}, icon: Icon(Icons.redo)),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {}, icon: Icon(Icons.share)),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.list_outlined)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                    child: TextFormField(
                      controller: titleController,
                      maxLines: 2,
                      autofocus: true,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: 'Title',
                        hintStyle: GoogleFonts.poppins(
                          color: Color(0xFFBFBFBF),
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
                    padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                    child: Container(
                      width: 345,
                      height: 96,
                      decoration: BoxDecoration(),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                        child: TextField(
                          controller: writingController,
                          textAlign: isTextStart
                              ? TextAlign.start
                              : isTextCenter
                                  ? TextAlign.center
                                  : TextAlign.end,
                          decoration: InputDecoration(
                            hintText: 'Start Writing..',
                            border: InputBorder.none,
                            hintStyle: GoogleFonts.poppins(
                              color: Color(0xFFBFBFBF),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                          ),
                          maxLines: null,
                          style: TextStyle(
                            fontSize: _fontSize,
                            color: _textColor,
                            fontFamily: _fontFamily,
                            fontStyle:
                                isItalic ? FontStyle.italic : FontStyle.normal,
                            fontWeight:
                                isBold ? FontWeight.bold : FontWeight.normal,
                            decoration: isUnderlined
                                ? TextDecoration.underline
                                : TextDecoration.none,
                          ),
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
      bottomNavigationBar: Container(
        color: Colors.white,
        height: 120,
        width: 400,
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: StatefulBuilder(builder: (context, state) {
                return FastColorPicker(
                  selectedColor: textColor,
                  onColorSelected: (Color color) {
                    state(() {});
                    onColorChange(color);
                  },
                );
              }),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      toggleItalic();
                    },
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(
                        Color.fromARGB(255, 255, 255, 255),
                      ),
                      foregroundColor:
                          MaterialStatePropertyAll<Color>(Colors.black),
                    ),
                    child: const Text('I',
                        style: TextStyle(
                            fontStyle: FontStyle.italic, fontSize: 16)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      toggleBold();
                    },
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(
                        Color.fromARGB(255, 255, 255, 255),
                      ),
                      foregroundColor:
                          MaterialStatePropertyAll<Color>(Colors.black),
                    ),
                    child: const Text('B',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      toggleUnderlined();
                    },
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(
                        Color.fromARGB(255, 255, 255, 255),
                      ),
                      foregroundColor:
                          MaterialStatePropertyAll<Color>(Colors.black),
                    ),
                    child: const Text('U',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 16)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      toggleTextStart();
                    },
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(
                        Color.fromARGB(255, 255, 255, 255),
                      ),
                      foregroundColor:
                          MaterialStatePropertyAll<Color>(Colors.black),
                    ),
                    child: const Icon(Icons.align_horizontal_left),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      toggleTextCenter();
                    },
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(
                        Color.fromARGB(255, 255, 255, 255),
                      ),
                      foregroundColor:
                          MaterialStatePropertyAll<Color>(Colors.black),
                    ),
                    child: const Icon(Icons.align_horizontal_center),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      toggleTextEnd();
                    },
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(
                        Color.fromARGB(255, 255, 255, 255),
                      ),
                      foregroundColor:
                          MaterialStatePropertyAll<Color>(Colors.black),
                    ),
                    child: const Icon(Icons.align_horizontal_right),
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
