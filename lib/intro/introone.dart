import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoaiapp/intro/introtwo.dart';

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Center(child: Image.asset("assets/intro (2).png")),
          Padding(
            padding: const EdgeInsets.only(top: 25),
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
