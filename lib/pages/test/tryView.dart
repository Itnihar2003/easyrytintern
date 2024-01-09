import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:page_transition/page_transition.dart';
import 'package:todoaiapp/pages/ocr/homePage.dart';

class MyDialogg extends StatefulWidget {
  String textcontroller;
  MyDialogg({
    super.key,
    required this.textcontroller,
  });

  @override
  State<MyDialogg> createState() => _MyDialoggState();
}

class _MyDialoggState extends State<MyDialogg> {
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

  Future<void> convertToPDF() async {
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
    String text = widget.textcontroller.toString();

    print("pdf conversion started");
    // final String convertUrl = 'https://ocr-xj19.onrender.com/pdf/textToPdf';
    final String convertUrl = '$baseUrl/pdf/textToPdf';

    try {
      Directory generalDownloadDir =  Directory('/storage/emulated/0/Download');
      print(generalDownloadDir);

      String directoryPath = generalDownloadDir.path;

      // FilePickerResult? result = await FilePicker.platform.getDirectoryPath();
      // Directory saveDir = await getTemporaryDirectory();
      // print(saveDir);
      // if (saveDir != null) {
      //   String directoryPath = saveDir.path;
      // String directoryPath = result.paths.first ?? '';

      String fileName =
          'converted_text_${DateTime.now().millisecondsSinceEpoch}.pdf';

      final userData = {"text": text};
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
                        child: const HomePage(),
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Container(
        height: 100,
        width: 312,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: const DecorationImage(
            image: AssetImage(
                'assets/images/DRIVE BOX.png'), // Replace with your image asset path
            fit: BoxFit.cover,
          ),
        ),
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(12),
        //   color: Colors.white,
        //   boxShadow: [
        //     BoxShadow(
        //       color: Colors.white,
        //       offset: Offset(0, 0),
        //       blurRadius: 0.2,
        //       spreadRadius: 0.3,
        //     ),
        //   ],
        // ),
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
                    padding: const EdgeInsets.only(top: 4.0, left: 4),
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
                  const Center(
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
            const SizedBox(width: 18.0),
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
                      padding: const EdgeInsets.only(top: 4.0),
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

                          // boxShadow: [
                          //   BoxShadow(
                          //     color:
                          //         textselected ? Colors.black54 : Colors.white,
                          //     offset: Offset(0, 0),
                          //     blurRadius: 0.1,
                          //     spreadRadius: 0.1,
                          //   ),
                          // ],
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
                    const Center(
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
            const SizedBox(width: 8.0),
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
                      padding: const EdgeInsets.only(top: 4.0),
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
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Image.asset(
                              'assets/images/PDF.png',
                              // 'assets/home/pdf.png',
                              height: 59,
                              width: 59,
                              // color: pdfselected ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Center(
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
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                height: 36,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: AssetImage(
                        'assets/images/DRIVE BOX.png'), // Replace with your image asset path
                    fit: BoxFit.cover,
                  ),
                ),
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(12),
                //   color: Colors.white,
                // ),
                child: const Center(
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
            const SizedBox(
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
                  // downloadTxt();
                } else if (wordselected == true) {
                  // convertToDocx();
                }
              },
              child: Container(
                height: 36,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                    image: AssetImage(
                        'assets/images/DRIVE BOX.png'), // Replace with your image asset path
                    fit: BoxFit.cover,
                  ),
                ),
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(12),
                //   color: Colors.white,
                // ),
                child: const Center(
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
