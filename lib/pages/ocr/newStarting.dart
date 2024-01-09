import 'package:flutter/material.dart';

import 'package:page_transition/page_transition.dart';
import 'package:todoaiapp/pages/ocr/homePage.dart';

class NewStarting extends StatefulWidget {
  const NewStarting({super.key});

  @override
  State<NewStarting> createState() => _NewStartingState();
}

class _NewStartingState extends State<NewStarting> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      top: true,
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                  'assets/new/newbg.png'), // Replace with your image asset path
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: const Alignment(0.06, -0.03),
                // top: 305,
                // left: 117,
                // top: size.height * 0.37,
                // left: size.width * 0.3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Colors.blue,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    height: 144,
                    width: 141,
                    child: Image.asset(
                      'assets/new/Group 507.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(-1, -0.02),
                // top: 325,
                // top: size.height * 0.4,
                // left: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Colors.blue,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    height: 96,
                    width: 90,
                    child: Image.asset(
                      'assets/new/Group 576.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(1, -0.0009),
                // top: 325,
                // top: size.height * 0.4,
                // right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Colors.blue,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    height: 96,
                    width: 90,
                    child: Image.asset(
                      'assets/new/Group 577.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),

              Align(
                alignment: const Alignment(0.1, 0.4),
                // top: 507,
                // top: size.height * 0.6,
                // left: size.width * 0.21,
                // left: 77,
                child: Container(
                  decoration: BoxDecoration(
                    // color: Colors.blue,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  height: 32,
                  width: 222,
                  child: Image.asset(
                    'assets/new/txt1.png',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),

              Align(
                alignment: const Alignment(0, 0.6),
                // top: 530,
                // top: size.height * 0.65,
                // left: size.width * 0.07,
                child: SizedBox(
                  height: 60,
                  width: 350,
                  // height: size.height * 0.05,
                  // color: Colors.red,
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                'Image to text converter is a free OCR tool that allows you  \n',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text:
                                'to convert Picture to text, convert PDF to Doc ﬁle and \n',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: 'extract text From PDF Files',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const Alignment(0.8, 0.8),
                // top: size.height * 0.83,
                // right: size.width * 0.09,
                child: InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        PageTransition(
                          child: const HomePage(),
                          type: PageTransitionType.fade,
                          isIos: true,
                          duration: const Duration(milliseconds: 900),
                        ),
                        (route) => false);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(width: 0.2),
                      color: const Color(0xffF0CDB7),
                    ),
                    height: 55,
                    width: 55,
                    // child: Image.asset(
                    //   'assets/screen/Frame 559.png',
                    //   fit: BoxFit.fitHeight,
                    //   // color: Colors.black,
                    // ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
              //   child: Container(
              //     decoration: BoxDecoration(
              //       // color: Colors.blue,
              //       borderRadius: BorderRadius.circular(5),
              //     ),
              //     height: 43,
              //     width: 302,
              //     child: Image.asset(
              //       'assets/screen/Frame 340.png',
              //       fit: BoxFit.fitWidth,
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 25,
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
              //   child: Container(
              //     decoration: BoxDecoration(
              //       // color: Colors.blue,
              //       borderRadius: BorderRadius.circular(5),
              //     ),
              //     height: 50,
              //     width: 331,
              //     // child: Text(
              //     //   "Image to text converter is a free OCR tool that allows\n you to convert Picture to text, convert PDF to Doc ﬁle\n and extract text From PDF Files",
              //     //   style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              //     // ),
              //     child: Image.asset(
              //       'assets/screen/text.png',
              //       fit: BoxFit.fitWidth,
              //     ),
              //   ),
              // ),
              // Spacer(),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       InkWell(
              //         onTap: () {
              //           Navigator.pushAndRemoveUntil(
              //               context,
              //               PageTransition(
              //                 child: HomePage(),
              //                 type: PageTransitionType.fade,
              //                 isIos: true,
              //                 duration: Duration(milliseconds: 900),
              //               ),
              //               (route) => false);
              //         },
              //         child: Container(
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(25),
              //             border: Border.all(width: 0.2),
              //             color: Color(0xffC3C0C6),
              //           ),
              //           height: 55,
              //           child: Image.asset(
              //             'assets/screen/Frame3.png',
              //             fit: BoxFit.fitHeight,
              //             // color: Colors.black,
              //           ),
              //         ),
              //       ),
              //       SizedBox(
              //         width: 20,
              //       ),
              //       InkWell(
              //         onTap: () {
              //           Navigator.pushAndRemoveUntil(
              //               context,
              //               PageTransition(
              //                 child: HomePage(),
              //                 type: PageTransitionType.fade,
              //                 isIos: true,
              //                 duration: Duration(milliseconds: 900),
              //               ),
              //               (route) => false);
              //         },
              //         child: Container(
              //           decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(30),
              //             border: Border.all(width: 0.2),
              //             color: Color(0xffC3C0C6),
              //           ),
              //           height: 55,
              //           child: Image.asset(
              //             'assets/screen/Frame 559.png',
              //             fit: BoxFit.fitHeight,
              //             // color: Colors.black,
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
