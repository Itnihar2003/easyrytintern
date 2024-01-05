// import 'package:flutter/material.dart';
// import 'package:ocr/homePage.dart';
// import 'package:page_transition/page_transition.dart';

// class StartingPage extends StatefulWidget {
//   const StartingPage({super.key});

//   @override
//   State<StartingPage> createState() => _StartingPageState();
// }

// class _StartingPageState extends State<StartingPage> {
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return SafeArea(
//       top: true,
//       child: Scaffold(
//         body: Container(
//           height: double.infinity,
//           width: double.infinity,
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage(
//                   'assets/screen/mobile.png'), // Replace with your image asset path
//               fit: BoxFit.cover,
//             ),
//           ),
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 30,
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     // color: Colors.blue,
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   height: 35,
//                   width: 212,
//                   child: Image.asset(
//                     'assets/screen/Welcome.png',
//                     fit: BoxFit.fitWidth,
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     // color: Colors.blue,
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   height: 43,
//                   width: 302,
//                   child: Image.asset(
//                     'assets/screen/Frame 340.png',
//                     fit: BoxFit.fitWidth,
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 25,
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     // color: Colors.blue,
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   height: 50,
//                   width: 331,
//                   // child: Text(
//                   //   "Image to text converter is a free OCR tool that allows\n you to convert Picture to text, convert PDF to Doc ﬁle\n and extract text From PDF Files",
//                   //   style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
//                   // ),
//                   child: Image.asset(
//                     'assets/screen/text.png',
//                     fit: BoxFit.fitWidth,
//                   ),
//                 ),
//               ),
//               Spacer(),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         Navigator.pushAndRemoveUntil(
//                             context,
//                             PageTransition(
//                               child: HomePage(),
//                               type: PageTransitionType.fade,
//                               isIos: true,
//                               duration: Duration(milliseconds: 900),
//                             ),
//                             (route) => false);
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(25),
//                           border: Border.all(width: 0.2),
//                           color: Color(0xffC3C0C6),
//                         ),
//                         height: 55,
//                         child: Image.asset(
//                           'assets/screen/Frame3.png',
//                           fit: BoxFit.fitHeight,
//                           // color: Colors.black,
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 20,
//                     ),
//                     InkWell(
//                       onTap: () {
//                         Navigator.pushAndRemoveUntil(
//                             context,
//                             PageTransition(
//                               child: HomePage(),
//                               type: PageTransitionType.fade,
//                               isIos: true,
//                               duration: Duration(milliseconds: 900),
//                             ),
//                             (route) => false);
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(30),
//                           border: Border.all(width: 0.2),
//                           color: Color(0xffC3C0C6),
//                         ),
//                         height: 55,
//                         child: Image.asset(
//                           'assets/screen/Frame 559.png',
//                           fit: BoxFit.fitHeight,
//                           // color: Colors.black,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 30,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
