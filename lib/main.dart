import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:todoaiapp/pages/notes/firebase_options.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:todoaiapp/pages/welcomepage.dart';
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main(List<String> args) async {
    WidgetsFlutterBinding.ensureInitialized();
    tz.initializeTimeZones();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const GetMaterialApp(debugShowCheckedModeBanner: false, home: welcome()));
}
