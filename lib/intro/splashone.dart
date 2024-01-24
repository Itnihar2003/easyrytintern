// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:todoaiapp/intro/splashtwo.dart';

// class splashone extends StatefulWidget {
//   const splashone({super.key});

//   @override
//   State<splashone> createState() => _splashoneState();
// }

// class _splashoneState extends State<splashone> with TickerProviderStateMixin {
//   late final AnimationController _controller =
//       AnimationController(vsync: this, duration: const Duration(seconds: 10))
//         ..repeat();
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     Timer(Duration(seconds: 2), () {
//       Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => splashtwo(),
//           ));
//     });
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: AnimatedBuilder(
//         animation: _controller,
//         child: Container(
//           height: MediaQuery.of(context).size.height / 2,
//           width: MediaQuery.of(context).size.width,
//           child: Center(
//             child: const SizedBox(
//               width: 140,
//               child: Image(
//                 image: AssetImage("assets/anima.png"),
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//         ),
//         builder: (context, child) {
//           return Transform.rotate(
//             angle: _controller.value * 2 * 3.141,
//             child: child,
//           );
//         },
//       ),
//     );
//   }
// }
