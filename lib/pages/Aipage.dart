import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class aiask extends StatefulWidget {
  const aiask({super.key});

  @override
  State<aiask> createState() => _AskAiScreenState();
}

class _AskAiScreenState extends State<aiask> {
  String chatReply =
      "d in your arms and be held as if I could break.I WISH TO REST INTO YOU my love possibly collapse and I know we mustn't fall for we must hold our selves before we hold each other's warm bodies in the night that bites where lovers lay but tonight my love I would like to collapse I would like to exhale and with it let go of all my fireall the do's I would like to be a child in your arms and be held as if I could break. I WISH TO REST INTO YOU my love possibly collapse and I know we mustn't fall for we must hold our selves before we hold each other's warm bodies in the night that bites where lovers lay but tonight my love I would like to collapse I would like to exhale and with it let go of all my fire all the do's. I would like to be a child in your arms and be held as if I could break.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              appbar(),
              Expanded(
                child: ListView.builder(
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return singleSenderChatTile();
                    }),
              ),
              SizedBox(height: 2.5),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  // height: 60,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 2.5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(99, 99, 99, 0.2),
                                blurRadius: 8,
                                spreadRadius: 0,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextFormField(
                            maxLines: 1,
                            style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                            cursorColor: Colors.black,
                            decoration: const InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              focusedErrorBorder: InputBorder.none,
                              hintText: "Type message..",
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(99, 99, 99, 0.2),
                              blurRadius: 8,
                              spreadRadius: 0,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.send_sharp,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 2.5)
            ],
          ),
        ),
      ),
    );
  }

  Widget singleSenderChatTile() {
    return Column(
      children: [
        Row(
          children: [
            Container(
              height: 25,
              width: 25,
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  image: AssetImage("assets/notes.png"),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: 2.5),
            Text(
              "You",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(
              height: 25,
              width: 25,
            ),
            SizedBox(width: 2.5),
            Text(
              "Write About AI",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(
              height: 25,
              width: 25,
            ),
            SizedBox(width: 2.5),
            Expanded(
              child: Text(
                chatReply,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget appbar() {
    return SizedBox(
      height: AppBar().preferredSize.height,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 30,
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.edit,
                size: 30,
                color: Colors.black,
              ),
              SizedBox(width: 10),
              Icon(
                Icons.menu,
                size: 30,
                color: Colors.black,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
