// import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:ocr/cameraScreen.dart';
// import 'package:ocr/contactTxt.dart';
// import 'package:ocr/docFileList.dart';
// import 'package:ocr/iconFileList.dart';
// import 'package:ocr/imageUrl.dart';
// import 'package:ocr/newCameraScreen.dart';
// import 'package:ocr/pdfFileList.dart';
// import 'package:ocr/privacy.dart';
// import 'package:ocr/termcond.dart';
// import 'package:ocr/testApi/testcam.dart';
// import 'package:ocr/txtFileList.dart';
// import 'package:ocr/viewText.dart';
// import 'package:open_file/open_file.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:url_launcher/url_launcher.dart';

// class TestApi extends StatefulWidget {
//   const TestApi({super.key});

//   @override
//   State<TestApi> createState() => _TestApiState();
// }

// class _TestApiState extends State<TestApi> {
//   final Uri _driveUrl = Uri.parse('https://www.istockphoto.com/photos/nature');
//   final Uri _linkUrl = Uri.parse('https://en.wikipedia.org/wiki/Image');
//   final Uri _cloudUrl = Uri.parse(
//       'https://www.google.com/webhp?hl=en&sa=X&ved=0ahUKEwjvheDW__WCAxVoZmwGHT2MAnIQPAgJ');
//   final picker = ImagePicker();
//   getImage(ImageSource source) async {
//     XFile? pickedFile = await picker.pickImage(source: source);
//     setState(() {
//       if (pickedFile != null) {
//         _cropImage(pickedFile);
//       } else {
//         // Navigator.pop(context);
//         Navigator.push(
//             context, MaterialPageRoute(builder: (context) => TestApi()));
//         // Navigator.pushAndRemoveUntil(
//         //     context,
//         //     PageTransition(
//         //       child: HomePage(),
//         //       type: PageTransitionType.fade,
//         //       isIos: true,
//         //       duration: Duration(milliseconds: 900),
//         //     ),
//         //     (route) => false);
//         print('No image selected');
//       }
//     });
//   }

//   File? imageFile;
//   CroppedFile? croppedImage;
//   Future _cropImage(XFile file) async {
//     croppedImage = await ImageCropper().cropImage(
//       sourcePath: file.path,
//       aspectRatioPresets: [
//         CropAspectRatioPreset.square,
//         CropAspectRatioPreset.ratio3x2,
//         CropAspectRatioPreset.original,
//         CropAspectRatioPreset.ratio4x3,
//         CropAspectRatioPreset.ratio16x9,
//       ],
//       uiSettings: [
//         AndroidUiSettings(
//             toolbarTitle: 'Cropper',
//             toolbarColor: Colors.deepOrange,
//             toolbarWidgetColor: Colors.white,
//             initAspectRatio: CropAspectRatioPreset.original,
//             lockAspectRatio: false),
//         IOSUiSettings(
//           title: 'Cropper',
//         ),
//         WebUiSettings(
//           context: context,
//         ),
//       ],
//     );
//     if (croppedImage != null) {
//       setState(() {
//         print('Cropped image path: ${croppedImage?.path}');
//         imageFile = File(croppedImage!.path);
//         getTextFromImage();
//       });
//     } else {
//       print('Cropping canceled');
//     }
//   }

//   bool _isBusy = false;
//   TextEditingController controller = TextEditingController();

//   void getTextFromImage() {
//     if (croppedImage != null) {
//       final InputImage inputImage = InputImage.fromFilePath(croppedImage!.path);
//       processImage(inputImage);
//     } else {
//       print("no cropped image found");
//     }
//   }

//   void processImage(InputImage image) async {
//     final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

//     setState(() {
//       _isBusy = true;
//     });

//     print(image.filePath!);
//     final RecognizedText recognizedText =
//         await textRecognizer.processImage(image);
//     controller.text = recognizedText.text;
//     Navigator.push(
//       context,
//       PageTransition(
//         child: TextViewer(
//           data: controller.text.toString(),
//         ),
//         type: PageTransitionType.fade,
//         isIos: true,
//         duration: Duration(milliseconds: 900),
//       ),
//     );

//     setState(() {
//       _isBusy = false;
//     });
//   }

//   void openCustomCamera() async {
//     List<CameraDescription> cameras = await availableCameras();
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => TestCam(cameras: cameras),
//       ),
//     );
//   }

//   @override
//   void initState() {
//     setState(() {
//       updateFileList();
//     });

//     super.initState();
//   }

//   List<FileData> filesData = [];

//   Future<void> updateFileList() async {
//     try {
//       Directory? directory = await getExternalStorageDirectory();
//       if (directory != null) {
//         List<FileSystemEntity> fileEntities = directory.listSync();
//         List<FileData> allFilesData = fileEntities
//             .where((entity) =>
//                 entity.path.endsWith('.pdf') ||
//                 entity.path.endsWith('.docx') ||
//                 entity.path.endsWith('.txt'))
//             .map((entity) => FileData(
//                   fileName: entity.uri.pathSegments.last,
//                   filePath: entity.path,
//                   isPdf: entity.path.endsWith('.pdf'),
//                   isDoc: entity.path.endsWith('.docx'),
//                   istxt: entity.path.endsWith('.txt'),
//                 ))
//             .toList();

//         // Sort files by modification time in descending order
//         allFilesData.sort((a, b) => File(b.filePath)
//             .lastModifiedSync()
//             .compareTo(File(a.filePath).lastModifiedSync()));

//         setState(() {
//           filesData = allFilesData;
//         });
//       }
//     } catch (error) {
//       print('Error updating file list: $error');
//     }
//   }

//   Future<void> openFile(String filePath) async {
//     try {
//       await OpenFile.open(filePath);
//     } catch (error) {
//       print('Error opening file: $error');
//     }
//   }

//   bool galary = false;
//   bool camera = false;
//   bool history = false;

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return SafeArea(
//       child: Scaffold(
//         body: SingleChildScrollView(
//           child: Container(
//             height: size.height,
//             child: Column(
//               // mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: 10,
//                 ),
//                 AppBar(
//                   backgroundColor: Colors.transparent,
//                 ),
//                 SizedBox(
//                   height: 60,
//                 ),

//                 SizedBox(
//                   height: 10,
//                 ),
//                 // bottom drive box
//                 Center(
//                   child: Container(
//                     height: size.height * 0.2,
//                     width: size.width * 0.9,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(16.0),
//                       image: DecorationImage(
//                         image: AssetImage(
//                             'assets/images/DRIVE BOX.png'), // Replace with your image asset path
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             InkWell(
//                               onTap: () {
//                                 openCustomCamera();
//                               },
//                               child: Container(
//                                 height: size.height * 0.07,
//                                 width: size.width * 0.23,
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(8.0),
//                                   color: Colors.white,
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black54,
//                                       offset: Offset(0, 0),
//                                       blurRadius: 0.1,
//                                       spreadRadius: 0.3,
//                                     ),
//                                   ],
//                                 ),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(6.0),
//                                   child: Image.asset(
//                                     'assets/images/CAMERA.png',
//                                     fit: BoxFit.fitHeight,
//                                     // color: Colors.black,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Container(
//                           height: 21,
//                           width: 150,
//                           // color: Colors.green,
//                           child: Center(
//                             child: Text(
//                               "Extract Text From Link",
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
