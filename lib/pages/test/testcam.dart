// import 'dart:convert';
// import 'dart:io';

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:ocr/homePage.dart';
// import 'package:ocr/viewText.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:image/image.dart' as img;
// import 'package:http/http.dart' as http;

// class TestCam extends StatefulWidget {
//   final List<CameraDescription> cameras;

//   const TestCam({Key? key, required this.cameras}) : super(key: key);

//   @override
//   _TestCamState createState() => _TestCamState();
// }

// class _TestCamState extends State<TestCam> {
//   late CameraController _cameraController;
//   XFile? _imageFile;
//   bool _isFlashOn = false; // To track flash status
//   bool _isFrontCamera = false; // To track camera direction

//   @override
//   void initState() {
//     super.initState();
//     _cameraController = CameraController(
//       widget.cameras[0],
//       ResolutionPreset.medium,
//     );
//     _cameraController.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {});
//     });
//   }

//   @override
//   void dispose() {
//     _cameraController.dispose();
//     print("disposed");
//     super.dispose();
//   }

//   Future<void> _takePicture() async {
//     try {
//       XFile imageFile = await _cameraController.takePicture();
//       setState(() {
//         _imageFile = imageFile;
//         if (imageFile != null) {
//           _cropImage(imageFile);
//         } else {
//           Navigator.push(
//             context,
//             PageTransition(
//               child: HomePage(),
//               type: PageTransitionType.fade,
//               isIos: true,
//               duration: Duration(milliseconds: 900),
//             ),
//           );

//           print('No image selected');
//         }
//       });
//     } catch (e) {
//       print(e);
//     }
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
//         // uploadImage(imageFile!);
//         // getTextFromImage();
//         uploadImage(imageFile!);
//       });
//     } else {
//       print('Cropping canceled');
//     }
//   }

//   String result = '';

//   Future<void> uploadImage(File imageFile) async {
//     print("hii");
//     print(imageFile.path); //jpg
//     var url = Uri.parse(
//         'https://scannerimage-e52f6979766b.herokuapp.com/ocr/imageToText');

//     var request = http.MultipartRequest('POST', url);
//     // request.headers['Content-Type'] = 'application/json';
//     request.headers['Content-Type'] = 'multipart/form-data';

//     request.files
//         .add(await http.MultipartFile.fromPath('ocrPic', imageFile.path));

//     try {
//       var response = await request.send();
//       print(response);
//       var responseData = await response.stream.toBytes();
//       var decodedData = utf8.decode(responseData);

//       var data = json.decode(decodedData);
//       print(data);
//       print(response.statusCode);
//       print(decodedData);
//       setState(() {
//         if (data['status'] == true) {
//           result = data['data'];
//         } else {
//           result = data['message'];
//         }
//         controller.text = result;
//       });
//     } catch (error) {
//       setState(() {
//         result = 'Error occurred: $error';
//       });
//     }
//   }

//   // Future<String> uploadImage(File imageFile) async {
//   //   print("process started");
//   //   try {
//   //     var stream = new http.ByteStream(imageFile.openRead());
//   //     stream.cast();
//   //     var length = await imageFile.length();
//   //     print(stream);
//   //     print(length);
//   //     var uri = Uri.parse(
//   //         'https://scannerimage-e52f6979766b.herokuapp.com/ocr/imageToText');
//   //     var request = http.MultipartRequest('POST', uri);
//   //     request.headers['Content-Type'] = 'application/json';
//   //     // request.headers['Content-Type'] = 'multipart/form-data';

//   //     // request.fields['name'] = nameController.text.trim().toString();
//   //     // request.fields['email'] = emailController.text.trim().toString();
//   //     // request.fields['password'] = passwordcontroller.text.trim().toString();

//   //     var multiport = http.MultipartFile('ocrPic', stream, length);

//   //     request.files.add(multiport);

//   //     var reponse = await request.send();
//   //     print(reponse.statusCode);

//   //     if (reponse.statusCode == 201) {
//   //       print("hello");
//   //       print(reponse.statusCode);
//   //       print(reponse);
//   //       Navigator.push(
//   //           context, MaterialPageRoute(builder: (context) => HomePage()));
//   //       return "pic uploded";
//   //     } else {
//   //       print("hii");
//   //       print(reponse.statusCode);
//   //       print(reponse);
//   //       print(await reponse.stream.bytesToString());
//   //       return "${reponse.statusCode}Failed";
//   //     }
//   //     //
//   //   } catch (e) {
//   //     print(e);
//   //     print("failed");
//   //     return "$e";
//   //   }
//   // }

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
//           data: controller.text,
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

//   Future<void> _pickImageFromGallery() async {
//     XFile? imageFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     setState(() {
//       _imageFile = imageFile;
//       if (imageFile != null) {
//         _cropImage(imageFile);
//       } else {
//         // Navigator.push(
//         //   context,
//         //   PageTransition(
//         //     child: ImageToText(),
//         //     type: PageTransitionType.fade,
//         //     isIos: true,
//         //     duration: Duration(milliseconds: 900),
//         //   ),
//         // );
//         Navigator.push(
//           context,
//           PageTransition(
//             child: HomePage(),
//             type: PageTransitionType.fade,
//             isIos: true,
//             duration: Duration(milliseconds: 900),
//           ),
//         );
//         print('No image selected');
//       }
//     });
//   }

//   void _toggleFlash() {
//     setState(() {
//       _isFlashOn = !_isFlashOn;
//       _cameraController
//           .setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
//     });
//   }

//   void _toggleCameraDirection() async {
//     final CameraDescription newDescription =
//         _isFrontCamera ? widget.cameras[0] : widget.cameras[1];
//     await _cameraController.dispose();
//     _cameraController = CameraController(
//       newDescription,
//       ResolutionPreset.medium,
//     );
//     await _cameraController.initialize();
//     setState(() {
//       _isFrontCamera = !_isFrontCamera;
//     });
//   }

//   // void applyBrightnessAndContrast() {
//   //   if (_imageFile != null) {
//   //     // Load the image using the image package
//   //     img.Image image =
//   //         img.decodeImage(File(_imageFile!.path).readAsBytesSync())!;

//   //     // Example adjustments (you can modify these values)
//   //     double brightness = 1.2; // Increase for brighter image
//   //     double contrast = 1.2; // Increase for higher contrast

//   //     // Apply brightness and contrast adjustments
//   //     image = img.adjustBrightness(image, brightness);
//   //     image = img.adjustContrast(image, contrast);

//   //     // Save the adjusted image
//   //     File adjustedFile =
//   //         File(_imageFile!.path.replaceFirst('.png', '_adjusted.png'));
//   //     adjustedFile.writeAsBytesSync(img.encodePng(image));

//   //     // Optionally, update the _imageFile with the adjusted file
//   //     _imageFile = XFile(adjustedFile.path);
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     if (!_cameraController.value.isInitialized) {
//       return Container();
//     }
//     return SafeArea(
//       child: Scaffold(
//         body: Container(
//           height: MediaQuery.of(context).size.height,
//           color: Colors.black,
//           padding: EdgeInsets.all(10),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   ElevatedButton(
//                     onPressed: _toggleFlash,
//                     child: _isFlashOn
//                         ? Icon(
//                             Icons.flash_on,
//                           )
//                         : Icon(
//                             Icons.flash_off,
//                           ),
//                   ),
//                 ],
//               ),
//               Container(
//                 // height: 600,
//                 height: MediaQuery.of(context).size.height * 0.74,
//                 child: CameraPreview(_cameraController),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton(
//                     onPressed: _toggleCameraDirection,
//                     child: _isFrontCamera
//                         ? Container(
//                             height: 40,
//                             // height: MediaQuery.of(context).size.height * 0.1,
//                             width: 40,
//                             child: Icon(
//                               Icons.camera_front,
//                               size: 30,
//                             ),
//                           )
//                         : Container(
//                             height: 40,
//                             width: 40,
//                             child: Icon(
//                               Icons.camera_rear,
//                               size: 30,
//                             ),
//                           ),
//                   ),
//                   InkWell(
//                     onTap: () {
//                       _takePicture();
//                     },
//                     child: Container(
//                       child: Image.asset(
//                         'assets/images/CAMERA.png',
//                         height: 45,
//                         width: 45,
//                       ),
//                     ),
//                   ),
//                   ElevatedButton(
//                     onPressed: _pickImageFromGallery,
//                     child: Image.asset('assets/camera/Copy.png',
//                         height: 40,
//                         width: 40,
//                         color: Color.fromARGB(255, 51, 12, 247)),
//                   ),
//                 ],
//               ),
//               // _imageFile != null
//               //     ? Image.file(File(_imageFile!.path))
//               //     : Container(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
