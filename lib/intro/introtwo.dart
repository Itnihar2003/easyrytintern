import 'package:flutter/material.dart';
import 'package:todoaiapp/intro/splashone.dart';
import 'package:todoaiapp/intro/splashtwo.dart';

import 'package:todoaiapp/pages/welcomepage.dart';

class intro2 extends StatefulWidget {
  const intro2({super.key});

  @override
  State<intro2> createState() => _intro2State();
}

class _intro2State extends State<intro2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Center(
              child: Stack(
            children: [
              Image.asset("assets/in2.png"),
            ],
          )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => splashtwo(),
                      ));
                },
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.arrow_forward_ios),
                )),
          )
        ],
      ),
    );
  }
}
