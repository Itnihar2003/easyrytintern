import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todoaiapp/pages/home/concentscreen.dart';
import 'package:todoaiapp/pages/home/homepage.dart';
import 'package:todoaiapp/pages/todo/notification.dart';
import 'package:todoaiapp/pages/welcomepage.dart';

class splashtwo extends StatefulWidget {
  const splashtwo({super.key});

  @override
  State<splashtwo> createState() => _splashoneState();
}

class _splashoneState extends State<splashtwo> with TickerProviderStateMixin {
  Notificationservice notificationservice = Notificationservice();
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 10))
        ..repeat();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    Timer(Duration(seconds: 1), () async {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                initializescreen(targetwidget: home(datas: [])),
          ));
    });
    notificationservice.initialisenotification();
    // TODO: implement initState 
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        child: Center(
          child: const SizedBox(
            width: 190,
            child: Image(
              image: AssetImage("assets/splash screen logo.gif"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller.value * 2 * 3.141,
            child: child,
          );
        },
      ),
    );
  }
}
