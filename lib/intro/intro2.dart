import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:todoaiapp/intro/splashtwo.dart';

class intro2 extends StatefulWidget {
  const intro2({super.key});

  @override
  State<intro2> createState() => _intro2State();
}

class _intro2State extends State<intro2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 25, left: 74),
              child: ListView(
                children: [
                  Text(
                    "Seize the Day with Todo:",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: Colors.black),
                  ),
                  Text(
                    "Where Tasks Meet Triumph! ",
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
                child: Image.asset("assets/todogif.gif")),
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
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => splashtwo(),
                          ));
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
