import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoaiapp/intro/intro2.dart';

class intro1 extends StatefulWidget {
  const intro1({super.key});

  @override
  State<intro1> createState() => _intro1State();
}

class _intro1State extends State<intro1> {
  var status = Permission.notification.request();
  storedonboardinginfo() async {
    int inviewed = 0;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt("onboard", inviewed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 60, left: 74),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Ask ChatGPT",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: Colors.black),
                  ),
                  Text(
                    "To Write Anything ",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            height: 150,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
          ),
          Expanded(
              child: Container(
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Image.asset("assets/animation.gif")),
            color: Color.fromARGB(255, 234, 233, 233),
          )),
          Stack(
            children: [
              Container(
                height: 150,
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Center(
                  child: InkWell(
                    onTap: () async {
                      storedonboardinginfo();
                      if (await status.isGranted) {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => intro2()));
                      } else {
                        Get.snackbar("error",
                            "please allow notification for get notified");
                      }
                    },
                    child: Container(
                      child: Center(
                        child: Text(
                          "Continue",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                      ),
                      height: 50,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.18),
                            blurRadius: 6,
                            spreadRadius: 0.6,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
