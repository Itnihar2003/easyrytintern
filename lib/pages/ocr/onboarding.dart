// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:ocr/StartingPage.dart';
// import 'package:ocr/homePage.dart';
// import 'package:ocr/newStarting.dart';

// class OnboardingScreen extends StatefulWidget {
//   const OnboardingScreen({super.key});

//   @override
//   State<OnboardingScreen> createState() => _OnboardingScreenState();
// }

// class _OnboardingScreenState extends State<OnboardingScreen> {
//   PageController _pageController = PageController(initialPage: 0);

//   List<Widget> pages = [];

//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setSystemUIOverlayStyle(
//       const SystemUiOverlayStyle(
//         statusBarColor: Colors.white,
//         statusBarIconBrightness: Brightness.dark,
//         systemNavigationBarColor: Colors.white,
//         systemNavigationBarIconBrightness: Brightness.dark,
//       ),
//     );
//     pages = [
//       NewStarting(),
//       HomePage(),
//     ];
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onHorizontalDragEnd: (details) {
//         if (details.primaryVelocity! > 0) {
//           // Swiped to the right, go to the previous page.
//           if (_pageController.page!.round() > 0) {
//             _pageController.previousPage(
//               duration: Duration(milliseconds: 700),
//               curve: Curves.ease,
//             );
//           }
//         } else if (details.primaryVelocity! < 0) {
//           // Swiped to the left, go to the next page.
//           if (_pageController.page!.round() < pages.length - 1) {
//             _pageController.nextPage(
//               duration: Duration(milliseconds: 700),
//               curve: Curves.ease,
//             );
//           }
//         }
//       },
//       child: PageView(
//         controller: _pageController,
//         children: pages,
//         onPageChanged: (int pageIndex) {
//           // Do something when the page changes (optional).
//         },
//       ),
//     );
//   }
// }
