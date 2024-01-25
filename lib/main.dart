import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoaiapp/intro/introone.dart';

import 'package:todoaiapp/intro/splashtwo.dart';
import 'package:todoaiapp/pages/notes/firebase_options.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:todoaiapp/pages/welcomepage.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
int? inviewed;
void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences pref = await SharedPreferences.getInstance();
  inviewed = pref.getInt("onboard");
  runApp(
     GetMaterialApp(
      title: 'Palm - AI, Gpt, Notes, AI Chat',
      debugShowCheckedModeBanner: false,
      home:inviewed !=0?intro1():splashtwo(),
    ),
  );
}
