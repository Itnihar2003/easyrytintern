import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:open_file_plus/open_file_plus.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoaiapp/pages/ocr/contactTxt.dart';
import 'package:todoaiapp/pages/ocr/docFileList.dart';
import 'package:todoaiapp/pages/ocr/driveUrl.dart';
import 'package:todoaiapp/pages/ocr/iconFileList.dart';
import 'package:todoaiapp/pages/ocr/imageUrl.dart';
import 'package:todoaiapp/pages/ocr/newCameraScreen.dart';
import 'package:todoaiapp/pages/ocr/newStarting.dart';
import 'package:todoaiapp/pages/ocr/pdfFileList.dart';
import 'package:todoaiapp/pages/ocr/privacy.dart';
import 'package:todoaiapp/pages/ocr/termcond.dart';
import 'package:todoaiapp/pages/ocr/txtFileList.dart';
import 'package:todoaiapp/pages/ocr/viewText.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final Uri _driveUrl = Uri.parse('https://www.istockphoto.com/photos/nature');
  // final Uri _linkUrl = Uri.parse('https://en.wikipedia.org/wiki/Image');
  // final Uri _cloudUrl = Uri.parse(
  //     'https://www.google.com/webhp?hl=en&sa=X&ved=0ahUKEwjvheDW__WCAxVoZmwGHT2MAnIQPAgJ');
  final picker = ImagePicker();
  getImage(ImageSource source) async {
    XFile? pickedFile = await picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _cropImage(pickedFile);
      } else {
        // Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     PageTransition(
        //       child: HomePage(),
        //       type: PageTransitionType.fade,
        //       isIos: true,
        //       duration: Duration(milliseconds: 900),
        //     ),
        //     (route) => false);
        print('No image selected');
      }
    });
  }

  File? imageFile;
  CroppedFile? croppedImage;
  Future _cropImage(XFile file) async {
    croppedImage = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
    if (croppedImage != null) {
      setState(() {
        print('Cropped image path: ${croppedImage?.path}');
        imageFile = File(croppedImage!.path);
        _showLanguageSelectionDialog();
        // uploadImage(imageFile!);
        // getTextFromImage();
      });
    } else {
      print('Cropping canceled');
    }
  }

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

  String result = '';

  bool isLoading = true;
  Future<void> uploadImage(File imageFile) async {
    print("hii");
    print(imageFile.path);

    // Check if the file has a valid image extension
    // List<String> validExtensions = ['.jpeg', '.png', '.gif', '.jpg'];
    // String fileExtension = imageFile.path.split('.').last.toLowerCase();
    // if (!validExtensions.contains(fileExtension)) {
    //   // Show an error message or handle accordingly
    //   print('Invalid file format. Only .jpeg, .png, or .gif are allowed.');
    //   showDialog(
    //     context: context,
    //     builder: (context) => AlertDialog(
    //       title: Text('Error'),
    //       content: Text(
    //           'Invalid file format. Only .jpeg, .png, or .gif are allowed.'),
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
    //   return;
    // }
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
      });
    } catch (error) {
      setState(() {
        result = 'Error occurred: $error';
      });
    }
  }

  // Future<String> uploadImage(File imageFile) async {
  //   print("process started");
  //   try {
  //     var stream = new http.ByteStream(imageFile.openRead());
  //     stream.cast();
  //     var length = await imageFile.length();
  //     var uri = Uri.parse(
  //         'https://scannerimage-e52f6979766b.herokuapp.com/ocr/imageToText');
  //     var request = http.MultipartRequest('POST', uri);
  //     request.headers['Content-Type'] = 'application/json';
  //     // request.headers['Content-Type'] = 'multipart/form-data';
  //     // request.fields['name'] = nameController.text.trim().toString();
  //     // request.fields['email'] = emailController.text.trim().toString();
  //     // request.fields['password'] = passwordcontroller.text.trim().toString();

  //     var multiport = http.MultipartFile('ocrPic', stream, length);

  //     request.files.add(multiport);

  //     var reponse = await request.send();
  //     print(reponse.statusCode);

  //     if (reponse.statusCode == 201) {
  //       print("hello");
  //       print(reponse.statusCode);
  //       print(reponse);
  //       Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => HomePage()));
  //       return "pic uploded";
  //     } else {
  //       print("hii");
  //       print(reponse.statusCode);
  //       print(reponse);
  //       print(await reponse.stream.bytesToString());
  //       return "${reponse.statusCode}Failed";
  //     }
  //     //
  //   } catch (e) {
  //     print(e);
  //     print("failed");
  //     return "$e";
  //   }
  // }

  bool _isBusy = false;
  TextEditingController controller = TextEditingController();

  void getTextFromImage() {
    if (croppedImage != null) {
      final InputImage inputImage = InputImage.fromFilePath(croppedImage!.path);
      processImage(inputImage);
    } else {
      print("no cropped image found");
    }
  }

  void processImage(InputImage image) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    setState(() {
      _isBusy = true;
    });

    print(image.filePath!);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(image);
    controller.text = recognizedText.text;
    Navigator.push(
      context,
      PageTransition(
        child: TextViewer(
          data: controller.text.toString(),
          langCode: selectedLangCode,
        ),
        type: PageTransitionType.fade,
        isIos: true,
        duration: Duration(milliseconds: 900),
      ),
    );

    setState(() {
      _isBusy = false;
    });
  }

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
      _checkFirstVisit();
      updateFileList();
    });

    super.initState();
  }

  Future<void> _checkFirstVisit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstVisit = prefs.getBool('isFirstVisit') ?? true;

    if (isFirstVisit) {
      // Show the screen
      _showFirstVisitScreen();

      // Set isFirstVisit to false so that the screen won't be shown again
      await prefs.setBool('isFirstVisit', false);
    }
  }

  void _showFirstVisitScreen() {
    // Implement your logic to show the screen here
    // For example, you can use Navigator to navigate to the first visit screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewStarting()),
    );
  }

  List<FileData> filesData = [];

  Future<void> updateFileList() async {
    try {
      Directory directory = Directory('/storage/emulated/0/Download');
      // Directory? directory = await getExternalStorageDirectory();
      if (await directory.exists()) {
        List<FileSystemEntity> fileEntities = directory.listSync();
        List<FileData> allFilesData = fileEntities
            .where((entity) =>
                entity.path.endsWith('.pdf') ||
                entity.path.endsWith('.docx') ||
                entity.path.endsWith('.txt'))
            .map((entity) => FileData(
                  fileName: entity.uri.pathSegments.last,
                  filePath: entity.path,
                  isPdf: entity.path.endsWith('.pdf'),
                  isDoc: entity.path.endsWith('.docx'),
                  istxt: entity.path.endsWith('.txt'),
                ))
            .toList();

        // Sort files by modification time in descending order
        allFilesData.sort((a, b) => File(b.filePath)
            .lastModifiedSync()
            .compareTo(File(a.filePath).lastModifiedSync()));

        setState(() {
          filesData = allFilesData;
        });
      } else {
        print("directory not found");
      }
    } catch (error) {
      print('Error updating file list: $error');
    }
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
        drawer: MyDrawer(),
        // drawer: CustomDrawer(context),
        body: Container(
          height: size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/home/0 5.png'), // Replace with your image asset path
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                AppBar(
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(
                  // height: 50,
                  height: size.height * 0.07,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 22),
                  child: Container(
                    child: Text(
                      "Recent downloads",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ),
                ),
                filesData.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 6),
                        child: Container(
                          // height: 240,
                          height: size.height * 0.33,
                          color: Colors.transparent,
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 6),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //Container 1
                                  if (filesData.isNotEmpty &&
                                      filesData.any((file) => file.isPdf))
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            child: PdfList(),
                                            type: PageTransitionType.fade,
                                            isIos: true,
                                            duration:
                                                Duration(milliseconds: 900),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: size.height * 0.15,
                                        width: size.width * 0.25,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
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
                                        child: Center(
                                          child: Container(
                                            child: Image.asset(
                                              'assets/images/PDF.png',
                                              // fit: BoxFit.fitHeight,
                                              // width: size.width * 0.27,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  //contaier2
                                  if (filesData.isNotEmpty &&
                                      filesData.any((file) => file.isDoc))
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            child: DocList(),
                                            type: PageTransitionType.fade,
                                            isIos: true,
                                            duration:
                                                Duration(milliseconds: 900),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        // height: size.height * 0.15,
                                        // width: size.width * 0.27,
                                        height: size.height * 0.15,
                                        width: size.width * 0.25,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
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
                                        child: Center(
                                          child: Container(
                                            child: Image.asset(
                                              'assets/images/DOC.png',
                                              // fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  // container 3
                                  if (filesData.isNotEmpty &&
                                      filesData.any((file) => file.istxt))
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            child: TxtList(),
                                            type: PageTransitionType.fade,
                                            isIos: true,
                                            duration:
                                                Duration(milliseconds: 900),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        // height: size.height * 0.15,
                                        // width: size.width * 0.27,
                                        height: size.height * 0.15,
                                        width: size.width * 0.25,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(16.0),
                                          color: Colors.white,
                                          // color: Colors.pink,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black54,
                                              offset: Offset(0, 0),
                                              blurRadius: 0.1,
                                              spreadRadius: 0.3,
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Container(
                                            child: Image.asset(
                                              'assets/images/TXT.png',
                                              // fit: BoxFit.cover,
                                              // scale: 1,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     //new cont 1
                              //     InkWell(
                              //       onTap: () {
                              //         // Navigator.push(
                              //         //   context,
                              //         //   PageTransition(
                              //         //     child: ImageToText(),
                              //         //     type: PageTransitionType.fade,
                              //         //     isIos: true,
                              //         //     duration: Duration(milliseconds: 900),
                              //         //   ),
                              //         // );
                              //       },
                              //       child: Container(
                              //         // height: size.height * 0.15,
                              //         // width: size.width * 0.27,
                              //         height: size.height * 0.15,
                              //         width: size.width * 0.25,
                              //         decoration: BoxDecoration(
                              //           borderRadius: BorderRadius.circular(16.0),
                              //           color: Colors.white,
                              //           // color: Colors.pink,
                              //           boxShadow: [
                              //             BoxShadow(
                              //               color: Colors.black54,
                              //               offset: Offset(0, 0),
                              //               blurRadius: 0.1,
                              //               spreadRadius: 0.3,
                              //             ),
                              //           ],
                              //         ),
                              //         child: Center(
                              //           child: Container(
                              //             child: Image.asset(
                              //               'assets/images/add.png',
                              //               // fit: BoxFit.cover,
                              //               // scale: 1,
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              // ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        height: size.height * 0.33,
                        color: Colors.transparent,
                        padding:
                            EdgeInsets.symmetric(horizontal: 6.0, vertical: 6),
                        child: Center(child: Text("No recent downloads")),
                      ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 22),
                  child: Container(
                    child: Text(
                      "Tools",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                // bottom drive box
                Center(
                  child: Container(
                    height: size.height * 0.2,
                    width: size.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/images/DRIVE BOX.png'), // Replace with your image asset path
                        fit: BoxFit.cover,
                      ),
                    ),
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(16.0),
                    //   // color: Colors.white,

                    //   gradient: LinearGradient(
                    //     begin: Alignment.topLeft,
                    //     end: Alignment.bottomRight,
                    //     colors: [
                    //       Color(0xffFDEBCD),
                    //       Colors.white,
                    //       Color(0xffE5E4E5)
                    //     ],
                    //   ),
                    // ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                // _launchUrl(_driveUrl);

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
                            InkWell(
                              onTap: () {
                                // _launchUrl(_linkUrl);
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: ImageUrlscreen(),
                                    type: PageTransitionType.fade,
                                    isIos: true,
                                    duration: Duration(milliseconds: 900),
                                  ),
                                );
                              },
                              child: Container(
                                height: size.height * 0.07,
                                width: size.width * 0.23,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  // color: Colors.white,
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
                                    'assets/home/3 1.png',
                                    fit: BoxFit.fitHeight,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                // _launchUrl(_cloudUrl);
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: DriveUrl(),
                                    type: PageTransitionType.fade,
                                    isIos: true,
                                    duration: Duration(milliseconds: 900),
                                  ),
                                );
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
                                    'assets/home/5 1.png',
                                    fit: BoxFit.fitHeight,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          // height: 21,
                          height: size.height * 0.04,
                          // width: 150,
                          // color: Colors.green,
                          child: Center(
                            child: Text(
                              "Extract Text From Link",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.06,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Center(
                    child: Container(
                      // decoration: BoxDecoration(
                      //   borderRadius: BorderRadius.circular(25),
                      //   border: Border.all(width: 0.2),
                      //   color: Color(0xffC3C0C6),
                      // ),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/images/black.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      height: size.height * 0.07,
                      width: size.width * 0.85,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                getImage(ImageSource.gallery);
                                galary = !galary;
                                camera = false;
                                history = false;
                              });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 800),
                              // height: 27,
                              // width: 27,
                              height: size.height * 0.04,
                              width: size.width * 0.11,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                // color: galary ? Colors.white : Colors.transparent,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.asset(
                                  'assets/images/IMPORT.png',
                                  // color: galary ? Colors.black : Colors.white,
                                  // scale: 1,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                openCustomCamera();
                                camera = !camera;
                                galary = false;
                                history = false;
                              });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 800),
                              height: size.height * 0.06,
                              width: size.width * 0.11,
                              decoration: BoxDecoration(
                                // color:
                                //     camera ? Color(0xff007BF7) : Colors.transparent,
                                // color: camera
                                //     ? Color(0xffD1BEAD)
                                //     : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Image.asset(
                                  'assets/images/scan.png',
                                  // 'assets/images/Group 527.png',
                                  color: Colors.white,
                                  // 'assets/images/scanner.jpg',
                                  // scale: 1,
                                  // color: camera ? Colors.white : Colors.white,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                galary = false;
                                camera = false;
                                history = !history;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FileListWidget(),
                                  ),
                                );
                              });
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 800),
                              // height: 27,
                              // width: 27,
                              height: size.height * 0.04,
                              width: size.width * 0.11,
                              decoration: BoxDecoration(
                                //Color(0xffD2BFB1)
                                // color: history ? Colors.white : Colors.transparent,
                                // color: history
                                //     ? Color(0xffD1BEAD)
                                //     : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                // border: Border.all(
                                //   width: 1,
                                // ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.asset(
                                  'assets/images/BACKUP.png',
                                  // scale: 1,
                                  // fit: BoxFit.fitHeight,
                                  // color: history ? Colors.black : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // backgroundColor: Color.fromARGB(255, 54, 53, 53),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage(
                'assets/home/0 5.png'), // Replace with your image asset path
            fit: BoxFit.cover,
          ),
          // borderRadius: BorderRadius.only(topRight: Radius.circular(100)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              InkWell(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => ContactTxt()),
                  // );
                },
                child: Text(
                  "Share App",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => ContactTxt()),
                  // );
                },
                child: Text(
                  "Send FeedBack",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TermCond()));
                },
                child: Text(
                  "Terms & condition",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PrivacyPolicy()),
                  );
                },
                child: Text(
                  "Privcy Policy",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ContactTxt()),
                  );
                },
                child: Text(
                  "Contact Info",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
