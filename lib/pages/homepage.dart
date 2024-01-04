import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:todoaiapp/pages/notes/notes.dart';
import 'package:todoaiapp/pages/Aipage.dart';
import 'package:todoaiapp/pages/diary/diary.dart';


import 'package:todoaiapp/pages/speechtotext/speechtotext.dart';

import 'package:todoaiapp/pages/todo/tododetail.dart';

class home extends StatefulWidget {
  const home({super.key,});
  

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
                        Container(
                          height: AppBar().preferredSize.height,
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
                                child: TextField(
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

                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            height: 200,
                            width: 400,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
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
                            "Quick Tools :",
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
                              quickTools(
                                  "assets/diary.png", "Diary", 3, context),
                              SizedBox(width: 20),
                              quickTools("assets/subtitle.png", "Subtitle", 4,
                                  context),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        InkWell(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 100,
                                width: 75,
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
                                      image: AssetImage("assets/sptot.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "Speech \nto text",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SpeechScreen(),
                                ));
                          },
                        ),

                        SizedBox(height: 20),

                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            "Recents",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 19,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(height: 2.5),
                        Container(
                          height: 100 * 6,
                          padding: EdgeInsets.all(8),
                          child: FirebaseAnimatedList(
                            query: FirebaseDatabase.instance.ref("post"),
                            itemBuilder: (context, snapshot, animation, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(2.5),
                                    color: Colors.white,
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color.fromRGBO(0, 0, 0, 0.09),
                                        blurRadius: 1,
                                        spreadRadius: 0,
                                        offset: Offset(-2, 4),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      leading: Text(
                                        "(" + index.toString() + ")",
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Quick Note",
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              showModalBottomSheet(
                                                context: context,
                                                builder: (context) =>
                                                    allfunction(
                                                        context, snapshot),
                                              );
                                            },
                                            icon: Icon(
                                              Icons.menu,
                                              size: 30,
                                              color: Colors.black,
                                            ),
                                          )
                                        ],
                                      ),
                                      subtitle: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Tittle=" +
                                                snapshot
                                                    .child("tittle")
                                                    .value
                                                    .toString(),
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text("content=" +
                                              snapshot
                                                  .child("content")
                                                  .value
                                                  .toString())
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 70,
                  width: 100,
                  child: InkWell(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => aiask(),
                          ));
                    },
                    child: Center(
                        child: AnimatedBuilder(
                      animation: _controller,
                      child: Container(
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
                    )),
                  ),
                )
              ],
            ),
          ),
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
                builder: (context) => diary(),
              ));
        } else if (index == 5) {
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
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 100,
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
              fontSize: 15,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget allfunction(BuildContext context, DataSnapshot snapshot) {
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
                            .child(snapshot.child("id").value.toString())
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
