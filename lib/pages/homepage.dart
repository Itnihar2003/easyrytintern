import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todoaiapp/pages/notes/editnotes.dart';

import 'package:todoaiapp/pages/notes/notes.dart';
import 'package:todoaiapp/pages/Aipage.dart';
import 'package:todoaiapp/pages/diary/diary.dart';
import 'package:todoaiapp/pages/ocr/homePage.dart';

import 'package:todoaiapp/pages/speechtotext/speechtotext.dart';

import 'package:todoaiapp/pages/todo/tododetail.dart';
import 'package:todoaiapp/pages/welcomepage.dart';

class home extends StatefulWidget {
  const home({
    super.key,
  });

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> with TickerProviderStateMixin {
  late AnimationController _controller =
      AnimationController(vsync: this, duration: Duration(seconds: 10))
        ..repeat();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final filtercontroler = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.98),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => welcome(),
                                      ));
                                },
                                icon: Icon(Icons.arrow_back)),
                            Container(
                              height: 40,
                              width: 300,
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Row(
                                children: [
                                  Container(
                                    width: 250,
                                    padding: EdgeInsets.only(right: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 20, 20, 20)),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: TextFormField(
                                      onChanged: (String value) {},
                                      controller: filtercontroler,
                                      cursorColor: Colors.black,
                                      style: GoogleFonts.poppins(fontSize: 16),
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: Colors.black,
                                        ),
                                        hintText: "Search",
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            height: 100,
                            width: 400,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                const Color.fromARGB(255, 148, 227, 151),
                                const Color.fromARGB(255, 81, 157, 220)
                              ]),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(7, 6, 6, 0.094),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  offset: Offset(-7, 7),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Quick Tools
                        SizedBox(height: 7.5),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Ai Tools ",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 19,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        SizedBox(height: 7.5),
                        Container(
                          width: 400,
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            children: [
                              quickTools(
                                  "assets/notes.png", "Notes,", 1, context),
                              SizedBox(width: 20),
                              quickTools(
                                  "assets/todo.png", "To-do", 2, context),
                              SizedBox(width: 20),
                              quickTools("assets/confetti.png",
                                  "Speech to text", 3, context),
                              SizedBox(width: 20),
                              quickTools(
                                  "assets/subtitle.png", "OCR", 4, context),
                            ],
                          ),
                        ),

                        SizedBox(height: 20),

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            "QuickNote",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 19,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: 2.5),
                        Container(
                          height: 500,
                          padding: EdgeInsets.all(8),
                          child: StreamBuilder(
                            stream:
                                FirebaseDatabase.instance.ref("post").onValue,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return CircularProgressIndicator();
                              } else {
                                Map<dynamic, dynamic> map =
                                    snapshot.data!.snapshot.value as dynamic;
                                List<dynamic> list = [];
                                list.clear();
                                list = map.values.toList();
                                final tittle = FirebaseDatabase.instance
                                    .ref("post")
                                    .child("tittle")
                                    .onValue
                                    .toString();
                                return GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisExtent: 250,
                                    crossAxisCount: 2,
                                  ),
                                  itemCount:
                                      snapshot.data!.snapshot.children.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    int index1 = index + 1;
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                          boxShadow: const [
                                            BoxShadow(
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.09),
                                              blurRadius: 1,
                                              spreadRadius: 0,
                                              offset: Offset(-2, 4),
                                            ),
                                          ],
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        editnotes(
                                                          id: list[index]["id"],
                                                          tittle: list[index]
                                                              ["tittle"],
                                                          content: list[index]
                                                              ["content"],
                                                        )));
                                          },
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Quick Note" +
                                                        "(" +
                                                        index1.toString() +
                                                        ")",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      showModalBottomSheet(
                                                        context: context,
                                                        builder: (context) =>
                                                            allfunction(
                                                                context,
                                                                list[index]
                                                                    ["id"]),
                                                      );
                                                    },
                                                    icon: Icon(
                                                      Icons
                                                          .drag_indicator_sharp,
                                                      size: 20,
                                                      color: Colors.black,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 8,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  child: Column(
                                                    children: [
                                                      Text(list[index]
                                                          ["tittle"]),
                                                      Text(list[index]
                                                          ["content"])
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => aiask(),
              ));
        },
        child: AnimatedBuilder(
          animation: _controller,
          child: Container(
            width: 100,
            child: Image(
              image: AssetImage("assets/ai.png"),
              fit: BoxFit.cover,
            ),
          ),
          builder: (context, child) {
            return Transform.rotate(
              angle: _controller.value * 2 * 3.141,
              child: child,
            );
          },
        ),
      ),
    );
  }
}

Widget quickTools(
    String imageUrl, String title, int index, BuildContext context) {
  return Expanded(
    child: InkWell(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      onTap: () {
        if (index == 2) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => detail(),
              ));
        } else if (index == 3) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SpeechScreen(),
              ));
        } else if (index == 1) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => notes(),
              ));
        } else if (index == 4) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ));
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.09),
                  blurRadius: 3,
                  spreadRadius: 1,
                  offset: Offset(5, 5),
                ),
              ],
            ),
            child: Center(
              child: Container(
                height: 50,
                child: Image(
                  image: AssetImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 2),
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 10,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget allfunction(BuildContext context, String snapshot) {
  return Container(
    height: 350,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 60,
          width: 400,
          padding: EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(width: 10),
                  Text(
                    "Quick Note :",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Close",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFF6F6F6),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 2.5),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2.5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [],
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        FirebaseDatabase.instance
                            .ref("post")
                            .child(snapshot)
                            .remove();
                      },
                      child: ListTile(
                          leading: Container(
                            height: 50,
                            width: 50,
                            color: const Color.fromARGB(255, 190, 189, 189),
                            child: Icon(
                              Icons.delete,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                          title: Text("Delete"),
                          trailing: Icon(Icons.arrow_forward_ios))),
                  TextButton(
                      onPressed: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       // builder: (context) => DriveUrl(
                        //       //     urlcontrolertext: snapshot
                        //       //         .child("content")
                        //       //         .value
                        //       //         .toString()),
                        //     ));
                      },
                      child: ListTile(
                          leading: Container(
                            height: 50,
                            width: 50,
                            color: const Color.fromARGB(255, 190, 189, 189),
                            child: Icon(
                              Icons.delete,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                          title: Text("Drive"),
                          trailing: Icon(Icons.arrow_forward_ios))),
                  ways(context, "PDF", Icons.picture_as_pdf),
                  ways(context, "Word", Icons.description_rounded),
                  ways(context, "Send as Email", Icons.email),
                  ways(context, "Share More", Icons.shortcut_sharp),
                ],
              ),
            ),
          ),
        )
      ],
    ),
  );
}

Widget ways(BuildContext context, String text, IconData name) {
  return TextButton(
      onPressed: () {},
      child: ListTile(
        leading: Container(
          height: 50,
          width: 50,
          color: const Color.fromARGB(255, 190, 189, 189),
          child: Icon(
            name,
            size: 30,
            color: Colors.white,
          ),
        ),
        title: Text(text),
        trailing:
            IconButton(onPressed: () {}, icon: Icon(Icons.arrow_forward_ios)),
      ));
}
