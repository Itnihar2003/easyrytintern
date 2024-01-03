// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:todoaiapp/pages/diary.dart';
// import 'package:todoaiapp/pages/homepage.dart';

// class todo extends StatefulWidget {
//   const todo({super.key});

//   @override
//   State<todo> createState() => _todoState();
// }

// class _todoState extends State<todo> {
//   List listData = [ "Playing",
//     "Eating",
//     "Sleeping",
//     "Dancing",];
//   List lists = [
//     "Playing",
//     "Eating",
//     "Sleeping",
//     "Dancing",
//     "cooking",
//     "Educationdetail"
//   ];
//   bool check = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           padding: EdgeInsets.symmetric(horizontal: 5),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(
//                 height: AppBar().preferredSize.height,
//                 width: 400,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Row(
//                       children: [
//                         InkWell(
//                           overlayColor:
//                               MaterialStateProperty.all(Colors.transparent),
//                           onTap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => home(),
//                                 ));
//                           },
//                           child: Icon(
//                             Icons.arrow_back,
//                             color: Colors.black,
//                             size: 30,
//                           ),
//                         ),
//                         SizedBox(width: 20),
//                         Text(
//                           "Title",
//                           style: GoogleFonts.poppins(
//                               color: Colors.black,
//                               fontSize: 25,
//                               fontWeight: FontWeight.w500),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(right: 0),
//                           child: IconButton(
//                               onPressed: () {
//                                 showModalBottomSheet<void>(
//                                     context: context,
//                                     builder: (BuildContext context) {
//                                       return Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Container(
//                                             height: 60,
//                                             width: 400,
//                                             padding: EdgeInsets.symmetric(
//                                                 horizontal: 5),
//                                             decoration: BoxDecoration(
//                                               color: Colors.black,
//                                               borderRadius: BorderRadius.only(
//                                                 topLeft: Radius.circular(6),
//                                                 topRight: Radius.circular(6),
//                                               ),
//                                             ),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 Row(
//                                                   children: [
//                                                     Icon(
//                                                       Icons.arrow_back,
//                                                       color: Colors.white,
//                                                       size: 20,
//                                                     ),
//                                                     SizedBox(width: 2.5),
//                                                     Text(
//                                                       "All types of details :",
//                                                       style:
//                                                           GoogleFonts.poppins(
//                                                         color: Colors.white,
//                                                         fontSize: 17,
//                                                         fontWeight:
//                                                             FontWeight.w400,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                                 InkWell(
//                                                   onTap: () {
//                                                     Navigator.pop(context);
//                                                   },
//                                                   child: Text(
//                                                     "Cancel",
//                                                     style: GoogleFonts.poppins(
//                                                       color: Colors.white,
//                                                       fontSize: 16,
//                                                       fontWeight:
//                                                           FontWeight.w500,
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             height: 20,
//                                           ),
//                                           Expanded(
//                                             child: ListView.builder(
//                                               itemCount: lists.length,
//                                               itemBuilder:
//                                                   (BuildContext context,
//                                                       int index) {
//                                                 return InkWell(
//                                                   onTap: () {
//                                                     setState(() {
//                                                       listData.add(lists[index]
//                                                           .toString());
//                                                     });
//                                                     Navigator.pop(context);
//                                                   },
//                                                   child: Padding(
//                                                     padding:
//                                                         const EdgeInsets.all(
//                                                             2.0),
//                                                     child: ListTile(
//                                                       tileColor: Colors.white,
//                                                       title: Text(
//                                                         lists[index],
//                                                         style: TextStyle(
//                                                             color: Colors.black,
//                                                             fontWeight:
//                                                                 FontWeight
//                                                                     .bold),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 );
//                                               },
//                                             ),
//                                           ),
//                                         ],
//                                       );
//                                     });
//                               },
//                               icon: Icon(
//                                 Icons.arrow_drop_down,
//                                 size: 40,
//                                 color: Colors.red,
//                               )),
//                         )
//                       ],
//                     ),
//                     IconButton(
//                       onPressed: () {
//                         showModalBottomSheet<void>(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return reminderModal(context);
//                             });
//                       },
//                       icon: Icon(
//                         Icons.timer,
//                         size: 30,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                   child: ListView.builder(
//                 itemCount: listData.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return InkWell(
//                     child:
//                         singleTodoTile(listData[index], context, lists, check),
//                     onLongPress: () {
//                       Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => diary(),
//                           ));
//                     },
//                   );
//                 },
//               )),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// Widget singleTodoTile(
//     String title, BuildContext context, List detail, bool check1) {
//   return title == " "
//       ? InkWell(
//           onTap: () {},
//           child: Container(
//             height: 50,
//             width: 100,
//             margin: EdgeInsets.only(top: 2.5),
//             decoration: BoxDecoration(
//               boxShadow: const [
//                 BoxShadow(
//                   color: Color.fromRGBO(0, 0, 0, 0.1),
//                   blurRadius: 25,
//                   spreadRadius: -5,
//                   offset: Offset(0, 20),
//                 ),
//                 BoxShadow(
//                   color: Color.fromRGBO(0, 0, 0, 0.04),
//                   blurRadius: 10,
//                   spreadRadius: -5,
//                   offset: Offset(0, 10),
//                 ),
//               ],
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(2.5),
//             ),
//           ),
//         )
//       : SizedBox(
//           height: 50,
//           width: 100,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 height: 12.5,
//                 width: 12.5,
//                 decoration: const BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage(
//                       "assets/icons/menu.png",
//                     ),
//                     fit: BoxFit.contain,
//                   ),
//                 ),
//               ),
//               SizedBox(width: 2.5),
//               Container(
//                 height: 22.5,
//                 width: 22.5,
//                 child: Checkbox(
//                   value: check1,
//                   onChanged: (value) {
//                     check1 = value!;
//                   },
//                 ),
//               ),
//               SizedBox(width: 2.5),
//               Expanded(
//                 child: Text(
//                   title,
//                   style: GoogleFonts.poppins(
//                     fontSize: 15,
//                     color: Colors.black,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
// }

// Widget reminderModal(BuildContext context) {
//   return Container(
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Container(
//           height: 60,
//           width: 400,
//           padding: EdgeInsets.symmetric(horizontal: 5),
//           decoration: BoxDecoration(
//             color: Colors.black,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(6),
//               topRight: Radius.circular(6),
//             ),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   Icon(
//                     Icons.arrow_back,
//                     color: Colors.white,
//                     size: 20,
//                   ),
//                   SizedBox(width: 2.5),
//                   Text(
//                     "Reminder",
//                     style: GoogleFonts.poppins(
//                       color: Colors.white,
//                       fontSize: 17,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                 ],
//               ),
//               InkWell(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: Text(
//                   "Set",
//                   style: GoogleFonts.poppins(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Expanded(
//           child: Container(
//             decoration: const BoxDecoration(
//               color: Color(0xFFF6F6F6),
//             ),
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   SizedBox(height: 2.5),
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 5,
//                       vertical: 2.5,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Date",
//                           style: GoogleFonts.poppins(
//                             color: Colors.black,
//                             fontSize: 18,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         Icon(
//                           Icons.keyboard_arrow_up_sharp,
//                           color: Colors.black,
//                           size: 20,
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     decoration: const BoxDecoration(
//                       color: Colors.white,
//                     ),
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 5,
//                       vertical: 2.5,
//                     ),
//                     child: Row(
//                       children: [
//                         Text(
//                           "Today, 2:46 pm",
//                           style: GoogleFonts.poppins(
//                             color: Colors.black,
//                             fontSize: 17,
//                             fontWeight: FontWeight.normal,
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 10,
//                       vertical: 20,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           "Repeat",
//                           style: GoogleFonts.poppins(
//                             color: Colors.black,
//                             fontSize: 18,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         Icon(
//                           Icons.keyboard_arrow_up_sharp,
//                           color: Colors.black,
//                           size: 20,
//                         ),
//                       ],
//                     ),
//                   ),
//                   modalSingleTile("Never"),
//                   SizedBox(height: 20),
//                   modalSingleTile("Daily"),
//                   SizedBox(height: 20),
//                   modalSingleTile("Weekly"),
//                   SizedBox(height: 20),
//                   modalSingleTile("Monthly"),
//                   SizedBox(height: 20),
//                   modalSingleTile("Yearly"),
//                   SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),
//         )
//       ],
//     ),
//   );
// }

// Widget modalSingleTile(String title) {
//   return Container(
//     decoration: const BoxDecoration(
//       color: Colors.white,
//     ),
//     padding: EdgeInsets.symmetric(
//       horizontal: 5,
//       vertical: 2.5,
//     ),
//     child: Row(
//       children: [
//         Text(
//           title,
//           style: GoogleFonts.poppins(
//             color: Colors.black,
//             fontSize: 17,
//             fontWeight: FontWeight.normal,
//           ),
//         )
//       ],
//     ),
//   );
// }
