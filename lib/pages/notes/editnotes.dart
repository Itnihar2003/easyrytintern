import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:share_plus/share_plus.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:todoaiapp/pages/home/homepage.dart';
import 'package:todoaiapp/pages/notes/notedata.dart';
import 'dart:math' as math show sin, pi, sqrt;

TextEditingController editController = TextEditingController();
TextEditingController editwritingController = TextEditingController();

class editnotes extends StatefulWidget {
  final String tittle;
  final String content;
  final int id;
  final List<data1> edit;
  const editnotes(
      {super.key,
      required this.tittle,
      required this.content,
      required this.id,
      required this.edit});

  @override
  _editnotesState createState() => _editnotesState();
}

class _editnotesState extends State<editnotes> {
  int selectedindex = -1;

  setdata1() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> data2list =
        widget.edit.map((data1) => jsonEncode(data1.toJson())).toList();
    pref.setStringList('myData2', data2list);
  }

  String tit = "";
  String finalvalue = "";
  String con = "";
  String finalcontent = "";
  @override
  Widget build(BuildContext context) {
    tit = widget.tittle;
    con = widget.content;
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
                    if (finalcontent != "" && finalvalue != "") {
                      setState(() {
                        selectedindex = widget.id;
                        widget.edit[widget.id].tittle1 = finalvalue;
                        widget.edit[widget.id].content1 = finalcontent;
                        setdata1();
                      });
                    } else if (finalcontent != "" && finalvalue == "") {
                      setState(() {
                        selectedindex = widget.id;
                        widget.edit[widget.id].tittle1 = tit;
                        widget.edit[widget.id].content1 = finalcontent;
                        setdata1();
                      });
                    } else if (finalcontent == "" && finalvalue != "") {
                      setState(() {
                        selectedindex = widget.id;
                        widget.edit[widget.id].tittle1 = finalvalue;
                        widget.edit[widget.id].content1 = con;
                        setdata1();
                      });
                    } else {
                      setState(() {
                        selectedindex = widget.id;
                        widget.edit[widget.id].tittle1 = tit;
                        widget.edit[widget.id].content1 = con;
                        setdata1();
                      });
                    }
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => home(
                            datas: const [],
                          ),
                        ));
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
                      if (finalcontent != "" && finalvalue != "") {
                        setState(() {
                          selectedindex = widget.id;
                          widget.edit[widget.id].tittle1 = finalvalue;
                          widget.edit[widget.id].content1 = finalcontent;
                          setdata1();
                        });
                      } else if (finalcontent != "" && finalvalue == "") {
                        setState(() {
                          selectedindex = widget.id;
                          widget.edit[widget.id].tittle1 = tit;
                          widget.edit[widget.id].content1 = finalcontent;
                          setdata1();
                        });
                      } else if (finalcontent == "" && finalvalue != "") {
                        setState(() {
                          selectedindex = widget.id;
                          widget.edit[widget.id].tittle1 = finalvalue;
                          widget.edit[widget.id].content1 = con;
                          setdata1();
                        });
                      } else {
                        setState(() {
                          selectedindex = widget.id;
                          widget.edit[widget.id].tittle1 = tit;
                          widget.edit[widget.id].content1 = con;
                          setdata1();
                        });
                      }
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => home(
                              datas: const [],
                            ),
                          ));
                    },
                    icon: const Icon(
                      color: Colors.white,
                      Icons.replay_outlined,
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
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.arrow_back)),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    if (finalvalue != "" &&
                                        finalcontent != "") {
                                      await Share.share(
                                          finalvalue + "\n" + finalcontent);
                                    } else {
                                      await Share.share(widget.tittle +
                                          "\n" +
                                          widget.content);
                                    }
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
                      initialValue: tit,
                      onChanged: (value) {
                        setState(() {
                          if (value != "") {
                            tit = value;
                            finalvalue = value;
                          } else {
                            finalvalue = widget.tittle;
                          }
                        });
                      },
                      maxLines: 2,
                      autofocus: true,
                      obscureText: false,
                      decoration: InputDecoration(
                        hintText: "tittle",
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
                      width: MediaQuery.of(context).size.width,
                      height: 610,
                      decoration: const BoxDecoration(),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                        child: TextFormField(
                          initialValue: con,
                          onChanged: (value1) {
                            setState(() {
                              if (value1 != "") {
                                con = value1;
                                finalcontent = value1;
                              } else {
                                finalcontent = widget.content;
                              }
                            });
                          },

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
