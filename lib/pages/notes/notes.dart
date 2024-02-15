import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:todoaiapp/pages/home/homepage.dart';
import 'package:todoaiapp/pages/notes/notedata.dart';
import 'dart:math' as math show sin, pi, sqrt;

class notes extends StatefulWidget {
  const notes({super.key});

  @override
  _notesState createState() => _notesState();
}

class _notesState extends State<notes> {
  // Color selectedColor = Colors.white;
  // double _fontSize = 20.0;
  // Color _textColor = Colors.black;
  // String _fontFamily = 'Roboto';
  // bool isItalic = false;
  // bool isBold = false;
  // bool isUnderlined = false;
  // bool isTextStart = true;
  // bool isTextEnd = false;
  // bool isTextCenter = false;
  // Color _fontColor = Colors.black;
  // void updateFontSize(double newSize) {
  //   setState(() {
  //     fontSize = newSize;
  //   });
  // }

  // void updateColor(Color newColor) {
  //   setState(() {
  //     _fontColor = newColor;
  //   });
  // }

  // var _newFontWeight = FontWeight.w300;
  // final List<Color> colors = [
  //   Colors.orange,
  //   Colors.red,
  //   Colors.green,
  //   Colors.blue,
  //   Colors.yellow,
  //   Colors.teal,
  //   Colors.cyan,
  //   Colors.purple,
  // ];
  // final _FontWeight = [
  //   FontWeight.w200,
  //   FontWeight.w900,
  //   FontWeight.w700,
  //   FontWeight.w800,
  //   FontWeight.w300,
  //   FontWeight.w400,
  //   FontWeight.w500,
  //   FontWeight.w600,
  //   FontWeight.w100,
  //   FontWeight.w200,
  // ];
  // double colorSize = 50; // Custom size for color containers
  // double paddingBetweenColors = 30;
  // double fontSize = 20; // Custom padding between colors
  // Color textColor = Colors.black;
  // String fontFamily = "Roboto";

  // bool extraBottomItems = false;
  // void toggleItalic() {
  //   setState(() {
  //     isItalic = !isItalic;
  //   });
  // }

  // TextSpan _textSpan = TextSpan(text: '', style: TextStyle(fontSize: 20));
  // void toggleBold() {
  //   String text = writingController.text;
  //   TextSelection selection = writingController.selection;
  //   int start = selection.start;
  //   int end = selection.end;
  //   for (int i = start; i <= end; i++) {
  //     setState(() {
  //       isBold = !isBold;
  //     });
  //   }
  // }

  // void toggleUnderlined() {
  //   setState(() {
  //     isUnderlined = !isUnderlined;
  //   });
  // }

  // void toggleTextStart() {
  //   if (!isTextStart) {
  //     isTextStart = true;
  //     isTextCenter = false;
  //     isTextEnd = false;
  //   }
  //   setState(() {});
  // }

  // void toggleTextEnd() {
  //   if (!isTextEnd) {
  //     isTextStart = false;
  //     isTextCenter = false;
  //     isTextEnd = true;
  //   } else {
  //     isTextStart = true;
  //     isTextCenter = false;
  //     isTextEnd = false;
  //   }
  //   setState(() {});
  // }

  // void toggleTextCenter() {
  //   if (!isTextCenter) {
  //     isTextStart = false;
  //     isTextCenter = true;
  //     isTextEnd = false;
  //   } else {
  //     isTextStart = true;
  //     isTextCenter = false;
  //     isTextEnd = false;
  //   }
  //   setState(() {});
  // }

  // void onColorSelected(Color color) {
  //   setState(() {
  //     selectedColor = color;
  //   });
  // }

  // void onSizeChange(value) {
  //   setState(() {
  //     _fontSize = value;
  //   });
  // }

  // void onColorChange(Color color) {
  //   setState(() {
  //     _textColor = color;
  //   });
  // }

  // void onFamilyChange(String type) {
  //   setState(() {
  //     _fontFamily = type.toString();
  //   });
  // }

  // Future<void> loadContent() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     titleController.text = prefs.getString('title') ?? '';
  //     writingController.text = prefs.getString('content') ?? '';

  //     final selectedColorValue = prefs.getInt('selectedColor');
  //     selectedColor = Color(selectedColorValue ?? Colors.white.value);
  //     // Load other properties here as well.
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   loadContent();
  // }

  // String id = DateTime.now().millisecondsSinceEpoch.toString();
  // save() {
  //   String savedtittle = titleController.text;
  //   String savedcontent = writingController.text;
  //   titleController.clear();
  //   writingController.clear();
  //   if (savedtittle != "" && savedcontent != "") {
  //     FirebaseDatabase.instance
  //         .ref("post")
  //         .child(id)
  //         .set({"tittle": savedtittle, "content": savedcontent, "id": id});
  //   } else {
  //     Get.snackbar("Error", "Plese fill all data",
  //         backgroundColor: Colors.grey);
  //   }
  // }
  late RewardedAd _rewardedAd;
  startrewardad() {
    RewardedAd.load(
        adUnitId: "ca-app-pub-3940256099942544/5224354917",
        // adUnitId: "ca-app-pub-1396556165266132/1772804526",
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (RewardedAd ad) {
              this._rewardedAd = ad;
            },
            onAdFailedToLoad: (LoadAdError error) {}));
  }

  showreward() {
    _rewardedAd.show(
      onUserEarnedReward: (ad, reward) {
        print("Rewarded money${reward.amount}");
      },
    );
    _rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {},
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
      },
      onAdWillDismissFullScreenContent: (ad) {
        ad.dispose();
      },
      onAdImpression: (ad) {
        print("$ad impression occure");
      },
    );
  }

  List<data1> allnote = [];

  setdata1() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> data2list =
        allnote.map((data1) => jsonEncode(data1.toJson())).toList();
    pref.setStringList('myData2', data2list);
  }

  getdata() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String>? data2list = pref.getStringList('myData2');
    if (data2list != null) {
      List<data1> finaldata2 = data2list
          //here data and data1 are not same
          .map((data2) => data1.fromJson(json.decode(data2)))
          .toList();
      return finaldata2;
    }
  }

  @override
  void initState() {
    update();
    startrewardad();
    super.initState();
  }

  update() async {
    List<data1> sdata = await getdata();
    setState(() {
      allnote = sdata;
    });
  }

  save1() {
    if (titleController.text != "" && writingController.text != "") {
      setState(() {
        allnote.add(data1(
            tittle1: titleController.text, content1: writingController.text));
      });
      setdata1();
    }
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController writingController = TextEditingController();

  // Flag to track whether the keyboard is open
  bool isKeyboardOpen = false;
  bool isbold = false;
  bool isitalic = false;
  bool isunderline = false;

  String? selectedText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: Stack(
        children: [
          WaveAnimation(
            size: 60.0,
            color: Color.fromARGB(255, 172, 172, 172),
            centerChild: Stack(
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle button tap
                    // showreward();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => home(
                            datas: [],
                          ),
                        ),
                        (Route) => false);
                    save1();
                    writingController.clear();
                    writingController.clear();
                    print(allnote.length);
                  },
                  child: Text(""),
                ),
              ],
            ),
          ),
          Positioned(
            top: 17,
            left: 18,
            child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.black,
                child: IconButton(
                    onPressed: () {
                      // showreward();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => home(
                              datas: [],
                            ),
                          ),
                          (Route) => false);
                      save1();
                      writingController.clear();
                      writingController.clear();
                      print(allnote.length);
                    },
                    icon: const Icon(
                      color: Colors.white,
                      Icons.add,
                      size: 30,
                    ))),
          )
        ],
      ),

      body: SafeArea(
        top: true,
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 82,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) => home(
                                          datas: [],
                                        ),
                                      ),
                                      (Route) => false);
                                  save1();
                                  writingController.clear();
                                  writingController.clear();
                                  print(allnote.length);
                                },
                                icon: const Icon(Icons.arrow_back)),
                            IconButton(
                                onPressed: () {}, icon: const Icon(Icons.undo)),
                            IconButton(
                                onPressed: () {}, icon: const Icon(Icons.redo)),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    await Share.share(titleController.text +
                                        "\n" +
                                        writingController.text);
                                  },
                                  icon: const Icon(Icons.share)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                    child: TextFormField(
                      maxLength: 100,
                      controller: titleController,
                      maxLines: 2,
                      autofocus: true,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: 'Title',
                        hintStyle: TextStyle(
                          color: const Color(0xFFBFBFBF),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                    child: Container(
                      height: 610,
                      decoration: const BoxDecoration(),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                        child: TextField(
                          controller: writingController,
                          // textAlign: isTextStart
                          //     ? TextAlign.start
                          //     : isTextCenter
                          //         ? TextAlign.center
                          //         : TextAlign.end,
                          decoration: InputDecoration(
                            hintText: 'Start Writing..',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: const Color(0xFFBFBFBF),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                          ),
                          maxLines: null,
                          // style: TextStyle(
                          //   fontSize: _fontSize,
                          //   color: _textColor,
                          //   fontFamily: _fontFamily,
                          //   fontStyle:
                          //       isItalic ? FontStyle.italic : FontStyle.normal,
                          //   fontWeight:
                          //       isBold ? FontWeight.bold : FontWeight.normal,
                          //   decoration: isUnderlined
                          //       ? TextDecoration.underline
                          //       : TextDecoration.none,
                          // ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: Container(
      //   color: Colors.white,
      //   height: 120,
      //   width: 400,
      //   child: Column(
      //     children: [
      //       SingleChildScrollView(
      //         scrollDirection: Axis.horizontal,
      //         child: StatefulBuilder(builder: (context, state) {
      //           return FastColorPicker(
      //             selectedColor: textColor,
      //             onColorSelected: (Color color) {
      //               state(() {});
      //               onColorChange(color);
      //             },
      //           );
      //         }),
      //       ),
      //       SingleChildScrollView(
      //         scrollDirection: Axis.horizontal,
      //         child: Row(
      //           children: [
      //             ElevatedButton(
      //               onPressed: () {
      //                 toggleItalic();
      //               },
      //               style: const ButtonStyle(
      //                 backgroundColor: MaterialStatePropertyAll<Color>(
      //                   Color.fromARGB(255, 255, 255, 255),
      //                 ),
      //                 foregroundColor:
      //                     MaterialStatePropertyAll<Color>(Colors.black),
      //               ),
      //               child: const Text('I',
      //                   style: TextStyle(
      //                       fontStyle: FontStyle.italic, fontSize: 16)),
      //             ),
      //             ElevatedButton(
      //               onPressed: () {
      //                 toggleBold();
      //               },
      //               style: const ButtonStyle(
      //                 backgroundColor: MaterialStatePropertyAll<Color>(
      //                   Color.fromARGB(255, 255, 255, 255),
      //                 ),
      //                 foregroundColor:
      //                     MaterialStatePropertyAll<Color>(Colors.black),
      //               ),
      //               child: const Text('B',
      //                   style: TextStyle(
      //                       fontWeight: FontWeight.bold, fontSize: 16)),
      //             ),
      //             ElevatedButton(
      //               onPressed: () {
      //                 toggleUnderlined();
      //               },
      //               style: const ButtonStyle(
      //                 backgroundColor: MaterialStatePropertyAll<Color>(
      //                   Color.fromARGB(255, 255, 255, 255),
      //                 ),
      //                 foregroundColor:
      //                     MaterialStatePropertyAll<Color>(Colors.black),
      //               ),
      //               child: const Text('U',
      //                   style: TextStyle(
      //                       decoration: TextDecoration.underline,
      //                       fontSize: 16)),
      //             ),
      //             ElevatedButton(
      //               onPressed: () {
      //                 toggleTextStart();
      //               },
      //               style: const ButtonStyle(
      //                 backgroundColor: MaterialStatePropertyAll<Color>(
      //                   Color.fromARGB(255, 255, 255, 255),
      //                 ),
      //                 foregroundColor:
      //                     MaterialStatePropertyAll<Color>(Colors.black),
      //               ),
      //               child: const Icon(Icons.align_horizontal_left),
      //             ),
      //             ElevatedButton(
      //               onPressed: () {
      //                 toggleTextCenter();
      //               },
      //               style: const ButtonStyle(
      //                 backgroundColor: MaterialStatePropertyAll<Color>(
      //                   Color.fromARGB(255, 255, 255, 255),
      //                 ),
      //                 foregroundColor:
      //                     MaterialStatePropertyAll<Color>(Colors.black),
      //               ),
      //               child: const Icon(Icons.align_horizontal_center),
      //             ),
      //             ElevatedButton(
      //               onPressed: () {
      //                 toggleTextEnd();
      //               },
      //               style: const ButtonStyle(
      //                 backgroundColor: MaterialStatePropertyAll<Color>(
      //                   Color.fromARGB(255, 255, 255, 255),
      //                 ),
      //                 foregroundColor:
      //                     MaterialStatePropertyAll<Color>(Colors.black),
      //               ),
      //               child: const Icon(Icons.align_horizontal_right),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

class WaveAnimation extends StatefulWidget {
  final double size;
  final Color color;
  final Widget centerChild;

  const WaveAnimation({
    this.size = 80.0,
    this.color = Colors.red,
    required this.centerChild,
    Key? key,
  }) : super(key: key);

  @override
  WaveAnimationState createState() => WaveAnimationState();
}

class WaveAnimationState extends State<WaveAnimation>
    with TickerProviderStateMixin {
  late AnimationController animCtr;

  @override
  void initState() {
    super.initState();
    animCtr = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  Widget getAnimatedWidget() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.size),
          gradient: RadialGradient(
            colors: [
              widget.color,
              Color.lerp(widget.color, Colors.black, .05)!
            ],
          ),
        ),
        child: ScaleTransition(
          scale: Tween(begin: 0.95, end: 1.0).animate(
            CurvedAnimation(
              parent: animCtr,
              curve: CurveWave(),
            ),
          ),
          child: Container(
            width: widget.size * 0.4,
            height: widget.size * 0.4,
            margin: const EdgeInsets.all(6),
            child: widget.centerChild,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(context) {
    return CustomPaint(
      painter: CirclePainter(animCtr, color: widget.color),
      child: SizedBox(
        width: widget.size * 1.6,
        height: widget.size * 1.6,
        child: getAnimatedWidget(),
      ),
    );
  }

  @override
  void dispose() {
    animCtr.dispose();
    super.dispose();
  }
}

class CirclePainter extends CustomPainter {
  final Color color;
  final Animation<double> animation;

  CirclePainter(
    this.animation, {
    required this.color,
  }) : super(repaint: animation);

  void circle(Canvas canvas, Rect rect, double value) {
    final double opacity = (1.0 - (value / 4.0)).clamp(0.0, 1.0);
    final Color rippleColor = color.withOpacity(opacity);
    final double size = rect.width / 2;
    final double area = size * size;
    final double radius = math.sqrt(area * value / 4);
    final Paint paint = Paint()..color = rippleColor;
    canvas.drawCircle(rect.center, radius, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    for (int wave = 3; wave >= 0; wave--) {
      circle(canvas, rect, wave + animation.value);
    }
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) => true;
}

class CurveWave extends Curve {
  @override
  double transform(double t) {
    if (t == 0 || t == 1) {
      return 0.01;
    }
    return math.sin(t * math.pi);
  }
}
