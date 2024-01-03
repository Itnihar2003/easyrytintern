import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoaiapp/pages/notes/firebase_options.dart';

import 'package:todoaiapp/pages/welcomepage.dart';

void main(List<String> args) async {
    WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(GetMaterialApp(debugShowCheckedModeBanner: false, home: welcome()));
}
