import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import 'package:open_file_plus/open_file_plus.dart';
import 'package:page_transition/page_transition.dart';
import 'package:todoaiapp/pages/home/homepage.dart';

import 'package:todoaiapp/pages/ocrfinal/ocr3.dart';
import 'package:todoaiapp/pages/ocrfinal/textviewer.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:http/http.dart' as http;

class ocrhome extends StatefulWidget {
  const ocrhome({super.key});

  @override
  State<ocrhome> createState() => _ocrhomeState();
}

class _ocrhomeState extends State<ocrhome> {
  // final Uri _driveUrl = Uri.parse('https://www.istockphoto.com/photos/nature');
  // final Uri _linkUrl = Uri.parse('https://en.wikipedia.org/wiki/Image');
  // final Uri _cloudUrl = Uri.parse(
  //     'https://www.google.com/webhp?hl=en&sa=X&ved=0ahUKEwjvheDW__WCAxVoZmwGHT2MAnIQPAgJ');
  final picker = ImagePicker();
  // getImage(ImageSource source) async {
  //   XFile? pickedFile = await picker.pickImage(source: source);
  //   setState(() {
  //     if (pickedFile != null) {
  //       _cropImage(pickedFile);
  //     } else {
  //       // Navigator.pop(context);
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => ocrhome()));
  //       // Navigator.pushAndRemoveUntil(
  //       //     context,
  //       //     PageTransition(
  //       //       child: ocrhome(),
  //       //       type: PageTransitionType.fade,
  //       //       isIos: true,
  //       //       duration: Duration(milliseconds: 900),
  //       //     ),
  //       //     (route) => false);
  //       print('No image selected');
  //     }
  //   });
  // }

  File? imageFile;
  // CroppedFile? croppedImage;
  // Future _cropImage(XFile file) async {
  //   croppedImage = await ImageCropper().cropImage(
  //     sourcePath: file.path,
  //     aspectRatioPresets: [
  //       CropAspectRatioPreset.square,
  //       CropAspectRatioPreset.ratio3x2,
  //       CropAspectRatioPreset.original,
  //       CropAspectRatioPreset.ratio4x3,
  //       CropAspectRatioPreset.ratio16x9,
  //     ],
  //     uiSettings: [
  //       AndroidUiSettings(
  //           toolbarTitle: 'Cropper',
  //           toolbarColor: Colors.black,
  //           toolbarWidgetColor: Colors.white,
  //           initAspectRatio: CropAspectRatioPreset.original,
  //           lockAspectRatio: false),
  //       IOSUiSettings(
  //         title: 'Cropper',
  //       ),
  //       WebUiSettings(
  //         context: context,
  //       ),
  //     ],
  //   );
  //   if (croppedImage != null) {
  //     setState(() {
  //       print('Cropped image path: ${croppedImage?.path}');
  //       imageFile = File(croppedImage!.path);
  //       _showLanguageSelectionDialog();
  //       // uploadImage(imageFile!);
  //       // getTextFromImage();
  //     });
  //   } else {
  //     print('Cropping canceled');
  //   }
  // }

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
      uploadImage(imageFile!); // image is being processed
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
                    child: ocrhome(),
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

  String result = '';

  bool isLoading = true;
  Future<void> uploadImage(File imageFile) async {
    print("hii");
    print(imageFile.path);

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
    var url = Uri.parse(
        'https://scannerimage-e52f6979766b.herokuapp.com/ocr/imageToText');

    var request = http.MultipartRequest('POST', url);
    // request.headers['Content-Type'] = 'application/json';
    request.headers['Content-Type'] = 'multipart/form-data';
    request.fields['lang'] = selectedLangCode;

    request.files
        .add(await http.MultipartFile.fromPath('ocrPic', imageFile.path));

    try {
      var response = await request.send();
      print(response);
      var responseData = await response.stream.toBytes();
      var decodedData = utf8.decode(responseData);

      var data = json.decode(decodedData);
      print(data);
      print(response.statusCode);
      print(decodedData);
      setState(() {
        if (data['status'] == true) {
          result = data['data'];
          controller.text = result;

          Navigator.pushAndRemoveUntil(
              context,
              PageTransition(
                child: TextViewer(
                  data: controller.text,
                  langCode: selectedLangCode,
                ),
                type: PageTransitionType.fade,
                isIos: true,
                duration: Duration(milliseconds: 900),
              ),
              (route) => false);
        } else {
          result = data['message'];
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text('Error: ${result}'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pushAndRemoveUntil(
                      context,
                      PageTransition(
                        child: ocrhome(),
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
      });
    } catch (error) {
      setState(() {
        result = 'Error occurred: $error';
      });
    }
  }

  bool _isBusy = false;
  TextEditingController controller = TextEditingController();

  Future<void> _launchUrl(Uri _url) async {
    print("hi");
    if (!await launchUrl(_url)) {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Could not launch $_url.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void openCustomCamera() async {
    List<CameraDescription> cameras = await availableCameras();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CameraScreen(cameras: cameras),
      ),
    );
  }

  @override
  void initState() {
    setState(() {
      // _checkFirstVisit();
      // updateFileList();
    });

    super.initState();
  }

  Future<void> openFile(String filePath) async {
    try {
      await OpenFile.open(filePath);
    } catch (error) {
      print('Error opening file: $error');
    }
  }

  bool galary = false;
  bool camera = false;
  bool history = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => home(datas: []),
                    ));
              },
              icon: Icon(
                Icons.arrow_back,
                size: 30,
              )),
          title: Text(
            "OCR",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          height: size.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // bottom drive box
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            openCustomCamera();
          },
          child: Container(
            height: size.height * 0.07,
            width: size.width * 0.23,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  offset: Offset(0, 0),
                  blurRadius: 0.1,
                  spreadRadius: 0.3,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Image.asset(
                'assets/images/CAMERA.png',
                fit: BoxFit.fitHeight,
                // color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
