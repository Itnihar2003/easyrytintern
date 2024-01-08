import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:page_transition/page_transition.dart';
import 'package:http/http.dart' as http;
import 'package:todoaiapp/pages/ocr/homePage.dart';
import 'package:todoaiapp/pages/ocr/viewText.dart';

class DriveUrl extends StatefulWidget {
  const DriveUrl({super.key});

  @override
  State<DriveUrl> createState() => _DriveUrlState();
}

class _DriveUrlState extends State<DriveUrl> {
  String? data;
  bool isLoading = true;
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController urlController = TextEditingController();

  String selectedLangCode = ''; // Store the selected language code

  List<Map<String, String>> languages = [
    {'Lang Code': 'afr', 'Language': 'Afrikaans'},
    {'Lang Code': 'amh', 'Language': 'Amharic'},
    {'Lang Code': 'ara', 'Language': 'Arabic'},
    {'Lang Code': 'asm', 'Language': 'Assamese'},
    {'Lang Code': 'aze', 'Language': 'Azerbaijani'},
    {'Lang Code': 'aze_cyrl', 'Language': 'Azerbaijani - Cyrillic'},
    {'Lang Code': 'bel', 'Language': 'Belarusian'},
    {'Lang Code': 'ben', 'Language': 'Bengali'},
    {'Lang Code': 'bod', 'Language': 'Tibetan'},
    {'Lang Code': 'bos', 'Language': 'Bosnian'},
    {'Lang Code': 'bul', 'Language': 'Bulgarian'},
    {'Lang Code': 'cat', 'Language': 'Catalan; Valencian'},
    {'Lang Code': 'ceb', 'Language': 'Cebuano'},
    {'Lang Code': 'ces', 'Language': 'Czech'},
    {'Lang Code': 'chi_sim', 'Language': 'Chinese - Simplified'},
    {'Lang Code': 'chi_tra', 'Language': 'Chinese - Traditional'},
    {'Lang Code': 'chr', 'Language': 'Cherokee'},
    {'Lang Code': 'cym', 'Language': 'Welsh'},
    {'Lang Code': 'dan', 'Language': 'Danish'},
    {'Lang Code': 'deu', 'Language': 'German'},
    {'Lang Code': 'dzo', 'Language': 'Dzongkha'},
    {'Lang Code': 'ell', 'Language': 'Greek, Modern (1453-)'},
    {'Lang Code': 'eng', 'Language': 'English'},
    {'Lang Code': 'enm', 'Language': 'English, Middle (1100-1500)'},
    {'Lang Code': 'epo', 'Language': 'Esperanto'},
    {'Lang Code': 'est', 'Language': 'Estonian'},
    {'Lang Code': 'eus', 'Language': 'Basque'},
    {'Lang Code': 'fas', 'Language': 'Persian'},
    {'Lang Code': 'fin', 'Language': 'Finnish'},
    {'Lang Code': 'fra', 'Language': 'French'},
    {'Lang Code': 'frk', 'Language': 'German Fraktur'},
    {'Lang Code': 'frm', 'Language': 'French, Middle (ca. 1400-1600)'},
    {'Lang Code': 'gle', 'Language': 'Irish'},
    {'Lang Code': 'glg', 'Language': 'Galician'},
    {'Lang Code': 'grc', 'Language': 'Greek, Ancient (-1453)'},
    {'Lang Code': 'guj', 'Language': 'Gujarati'},
    {'Lang Code': 'hat', 'Language': 'Haitian; Haitian Creole'},
    {'Lang Code': 'heb', 'Language': 'Hebrew'},
    {'Lang Code': 'hin', 'Language': 'Hindi'},
    {'Lang Code': 'hrv', 'Language': 'Croatian'},
    {'Lang Code': 'hun', 'Language': 'Hungarian'},
    {'Lang Code': 'iku', 'Language': 'Inuktitut'},
    {'Lang Code': 'ind', 'Language': 'Indonesian'},
    {'Lang Code': 'isl', 'Language': 'Icelandic'},
    {'Lang Code': 'ita', 'Language': 'Italian'},
    {'Lang Code': 'ita_old', 'Language': 'Italian - Old'},
    {'Lang Code': 'jav', 'Language': 'Javanese'},
    {'Lang Code': 'jpn', 'Language': 'Japanese'},
    {'Lang Code': 'kan', 'Language': 'Kannada'},
    {'Lang Code': 'kat', 'Language': 'Georgian'},
    {'Lang Code': 'kat_old', 'Language': 'Georgian - Old'},
    {'Lang Code': 'kaz', 'Language': 'Kazakh'},
    {'Lang Code': 'khm', 'Language': 'Central Khmer'},
    {'Lang Code': 'kir', 'Language': 'Kirghiz; Kyrgyz'},
    {'Lang Code': 'kor', 'Language': 'Korean'},
    {'Lang Code': 'kur', 'Language': 'Kurdish'},
    {'Lang Code': 'lao', 'Language': 'Lao'},
    {'Lang Code': 'lat', 'Language': 'Latin'},
    {'Lang Code': 'lav', 'Language': 'Latvian'},
    {'Lang Code': 'lit', 'Language': 'Lithuanian'},
    {'Lang Code': 'mal', 'Language': 'Malayalam'},
    {'Lang Code': 'mar', 'Language': 'Marathi'},
    {'Lang Code': 'mkd', 'Language': 'Macedonian'},
    {'Lang Code': 'mlt', 'Language': 'Maltese'},
    {'Lang Code': 'msa', 'Language': 'Malay'},
    {'Lang Code': 'mya', 'Language': 'Burmese'},
    {'Lang Code': 'nep', 'Language': 'Nepali'},
    {'Lang Code': 'nld', 'Language': 'Dutch; Flemish'},
    {'Lang Code': 'nor', 'Language': 'Norwegian'},
    {'Lang Code': 'ori', 'Language': 'Oriya'},
    {'Lang Code': 'pan', 'Language': 'Panjabi; Punjabi'},
    {'Lang Code': 'pol', 'Language': 'Polish'},
    {'Lang Code': 'por', 'Language': 'Portuguese'},
    {'Lang Code': 'pus', 'Language': 'Pushto; Pashto'},
    {'Lang Code': 'ron', 'Language': 'Romanian; Moldavian; Moldovan'},
    {'Lang Code': 'rus', 'Language': 'Russian'},
    {'Lang Code': 'san', 'Language': 'Sanskrit'},
    {'Lang Code': 'sin', 'Language': 'Sinhala; Sinhalese'},
    {'Lang Code': 'slk', 'Language': 'Slovak'},
    {'Lang Code': 'slv', 'Language': 'Slovenian'},
    {'Lang Code': 'spa', 'Language': 'Spanish; Castilian'},
    {'Lang Code': 'spa_old', 'Language': 'Spanish; Castilian - Old'},
    {'Lang Code': 'sqi', 'Language': 'Albanian'},
    {'Lang Code': 'srp', 'Language': 'Serbian'},
    {'Lang Code': 'srp_latn', 'Language': 'Serbian - Latin'},
    {'Lang Code': 'swa', 'Language': 'Swahili'},
    {'Lang Code': 'swe', 'Language': 'Swedish'},
    {'Lang Code': 'syr', 'Language': 'Syriac'},
    {'Lang Code': 'tam', 'Language': 'Tamil'},
    {'Lang Code': 'tel', 'Language': 'Telugu'},
    {'Lang Code': 'tgk', 'Language': 'Tajik'},
    {'Lang Code': 'tgl', 'Language': 'Tagalog'},
    {'Lang Code': 'tha', 'Language': 'Thai'},
    {'Lang Code': 'tir', 'Language': 'Tigrinya'},
    {'Lang Code': 'tur', 'Language': 'Turkish'},
    {'Lang Code': 'uig', 'Language': 'Uighur; Uyghur'},
    {'Lang Code': 'ukr', 'Language': 'Ukrainian'},
    {'Lang Code': 'urd', 'Language': 'Urdu'},
    {'Lang Code': 'uzb', 'Language': 'Uzbek'},
    {'Lang Code': 'uzb_cyrl', 'Language': 'Uzbek - Cyrillic'},
    {'Lang Code': 'vie', 'Language': 'Vietnamese'},
    {'Lang Code': 'yid', 'Language': 'Yiddish'},
  ];
  List<Map<String, String>> filteredLanguages = [];
  Future<void> _showLanguageSelectionDialog() async {
    filteredLanguages = List.from(languages);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Select Language'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 90,
                      // width: 200,
                      child: TextField(
                        onChanged: (value) {
                          // Filter languages based on user input
                          setState(() {
                            filteredLanguages = languages
                                .where((language) =>
                                    language['Language']!
                                        .toLowerCase()
                                        .contains(value.toLowerCase()) ||
                                    language['Lang Code']!
                                        .toLowerCase()
                                        .contains(value.toLowerCase()))
                                .toList();
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Search Language',
                          hintText: 'Enter language name or code',
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      // height: 300,
                      // color: Colors.blue,
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.height * 0.62,
                      child: ListView.builder(
                        itemCount: filteredLanguages.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              // Set the selected language code and close the dialog
                              setState(() {
                                selectedLangCode =
                                    filteredLanguages[index]['Lang Code']!;
                              });
                              Navigator.pop(context);
                            },
                            title: Text(
                              '${filteredLanguages[index]['Language']} (${filteredLanguages[index]['Lang Code']})',
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    // here received the  code lang value ,
    //now go for upload image with the code data
    print("here");
    print(selectedLangCode);
    if (selectedLangCode.isNotEmpty) {
      // uploadImage(imageFile!); // image is being processed
      _postData();
    } else {
      // show popup
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text(" Please select the language code . "),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  PageTransition(
                    child: HomePage(),
                    type: PageTransitionType.fade,
                    isIos: true,
                    duration: Duration(milliseconds: 900),
                  ),
                  (route) => false),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _postData() async {
    print("entered");
    if (isLoading) {
      showDialog(
        context: context,
        builder: (context) => Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        ),
      );
    } else {
      Text("");
    }
    // final String apiUrl = 'https://ocr-xj19.onrender.com/ocr/imageUrlText';
    // final String apiUrl = 'https://scannerimage-e52f6979766b.herokuapp.com';
    // final String apiUrl =
    //     'https://scannerimage-e52f6979766b.herokuapp.com/ocr/googleDriveText';

    // try {
    //   var _header = {
    //     'Content-Type': 'application/json',
    //   };
    //   print(urlController.text);
    //   print(selectedLangCode);

      // var _body = {
      //   // 'url':
      //   //     'https://d2jaiao3zdxbzm.cloudfront.net/wp-content/uploads/figure-65.png',
      //   'url': urlController.text,
      //   'lang': selectedLangCode,
      // };
      // final http.Response response = await http.post(
      //   Uri.parse(apiUrl),
      //   body: json.encode(_body),
      //   headers: _header,
      // );
    //   var value = jsonDecode(response.body);
    //   print(response.statusCode);
    //   if (response.statusCode == 200) {
    //     setState(() {
    //       isLoading = false;
    //     });
    //     data = value["data"];
    //     print("here data");
    //     // Successful response, handle accordingly
    //     print(data);
    //     if (data != null) {
    //       Navigator.push(
    //         context,
    //         PageTransition(
    //           child: TextViewer(
    //             data: data!,
    //             langCode: selectedLangCode,
    //           ),
    //           type: PageTransitionType.fade,
    //           isIos: true,
    //           duration: Duration(milliseconds: 900),
    //         ),
    //       );
    //       isLoading = false;
    //     }
    //     print('Response: ${response.body}');
    //   } else {
    //     showDialog(
    //       context: context,
    //       builder: (context) => AlertDialog(
    //         title: Text('Error'),
    //         content: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text('Error: ${response.statusCode}'),
    //             Text("Please check the link format . "),
    //           ],
    //         ),
    //         actions: <Widget>[
    //           TextButton(
    //             onPressed: () => Navigator.pushAndRemoveUntil(
    //                 context,
    //                 PageTransition(
    //                   child: HomePage(),
    //                   type: PageTransitionType.fade,
    //                   isIos: true,
    //                   duration: Duration(milliseconds: 900),
    //                 ),
    //                 (route) => false),
    //             child: Text('OK'),
    //           ),
    //         ],
    //       ),
    //     );
    //   }
    // } catch (e) {
    //   showDialog(
    //     context: context,
    //     builder: (context) => AlertDialog(
    //       title: Text('Exception'),
    //       content: Text('Exception: $e'),
    //       actions: <Widget>[
    //         TextButton(
    //           onPressed: () => Navigator.pushAndRemoveUntil(
    //               context,
    //               PageTransition(
    //                 child: HomePage(),
    //                 type: PageTransitionType.fade,
    //                 isIos: true,
    //                 duration: Duration(milliseconds: 900),
    //               ),
    //               (route) => false),
    //           child: Text('OK'),
    //         ),
    //       ],
    //     ),
    //   );
    //   // Handle exceptions
    //   print('Exception: $e');
    // }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/home/0 5.png',
                ), // Replace with your image asset path
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  leading: InkWell(
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          PageTransition(
                            child: HomePage(),
                            type: PageTransitionType.fade,
                            isIos: true,
                            duration: Duration(milliseconds: 900),
                          ),
                          (route) => false);
                    },
                    child: Icon(Icons.arrow_back_ios),
                  ),
                  // title: Center(child: Text("Url to pdf")),
                ),
                SizedBox(
                  // height: 10,
                  height: size.height * 0.01,
                ),
                Container(
                  // width: 327,
                  // height: 55,
                  //  height: size.height * 0.07,
                  // width: size.width * 0.8,
                  height: size.height * 0.07,
                  width: size.width * 0.82,

                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(width: 1, color: Colors.black)),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(17.0),
                        child: Container(
                          // height: 19,
                          // width: 19,
                          height: size.height * 0.19,
                          width: size.width * 0.05,
                          child: Image.asset(
                            'assets/images/Group 52.png',
                            scale: 1,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        // height: 30,
                        height: size.height * 0.04,
                        child: VerticalDivider(
                          width: 3,
                          thickness: 2,
                          color: Colors.black26,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          // height: 50,
                          // width: 250,
                          height: size.height * 0.06,
                          width: size.width * 0.64,
                          child: TextFormField(
                            controller: urlController,
                            maxLines: 1,
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Colors.black),
                            decoration: InputDecoration(
                              hintText: 'Enter Url',
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.black45),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.025,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TextViewer(
                            data: urlController.text,
                            langCode: selectedLangCode,
                          ),
                        ));
                    // _postData();
                    _showLanguageSelectionDialog();
                  },
                  child: Container(
                    // height: 46,
                    // width: 327,
                    height: size.height * 0.065,
                    width: size.width * 0.82,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.black,
                        border: Border.all(width: 0.2)),
                    child: Center(
                      child: Text(
                        "Search",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.15,
                ),
                Container(
                  height: size.height * 0.4,
                  width: size.width * 0.8,
                  // color: Colors.pink,
                  child: Stack(
                    children: [
                      // Positioned(
                      //   top: 115,
                      //   left: 80,
                      //   child: Container(
                      //     // color: Colors.red,
                      //     height: 29,
                      //     width: 169,
                      //     child: Image.asset(
                      //       'assets/images/http.png',
                      //       color: Colors.black45,
                      //     ),
                      //   ),
                      // ),
                      // Align(
                      //   alignment: Alignment.center,
                      //   child: Container(
                      //     height: 264,
                      //     width: 264,
                      //     child: Image.asset(
                      //       'assets/images/Web.png',
                      //       // color: Colors.blue,
                      //       color: Colors.black,
                      //     ),
                      //   ),
                      // ),
                      Align(
                        alignment: Alignment(-0.5, 0),
                        // top: size.height * 0.15,
                        // left: size.width * 0.1,
                        child: Container(
                          // color: Colors.red,
                          height: size.height * 0.07,
                          width: size.width * 0.6,
                          child: Image.asset(
                            'assets/images/http.png',
                            color: Colors.black45,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment(-0.14, 0),
                        child: Container(
                          // height: 264,
                          // width: 264,
                          height: size.height * 0.92,
                          width: size.width * 0.92,
                          child: Image.asset(
                            'assets/images/Web.png',
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
