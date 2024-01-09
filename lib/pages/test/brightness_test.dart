import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_screen_wake/flutter_screen_wake.dart';

class MyAppp extends StatefulWidget {
  const MyAppp({super.key});

  @override
  _MyApppState createState() => _MyApppState();
}

class _MyApppState extends State<MyAppp> {
  bool _keepOn = false;
  double _brightness = 0.0;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    bool platformVersion;
    double brightness;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterScreenWake.isKeptOn;
      brightness = await FlutterScreenWake.brightness;
    } on PlatformException {
      platformVersion = false;
      brightness = 1.0;
    }

    if (!mounted) return;

    setState(() {
      _keepOn = platformVersion;
      _brightness = brightness;
    });
  }

  Future<void> changeKeep() async {
    bool platformVersion;

    await FlutterScreenWake.keepOn(!_keepOn);

    try {
      platformVersion = await FlutterScreenWake.isKeptOn;
    } on PlatformException {
      platformVersion = false;
    }

    setState(() {
      _keepOn = platformVersion;
    });
  }

  Future<void> changeBrightnessMax() async {
    double brightness = 0.0;
    await FlutterScreenWake.setBrightness(1.0);

    try {
      brightness = await FlutterScreenWake.brightness;
    } on PlatformException {
      brightness = 0.5;
    }

    setState(() {
      _brightness = brightness;
    });
  }

  Future<void> changeBrightnessMin() async {
    double brightness = 0.0;
    await FlutterScreenWake.setBrightness(0.05);

    try {
      brightness = await FlutterScreenWake.brightness;
    } on PlatformException {
      brightness = 0.5;
    }

    setState(() {
      _brightness = brightness;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Example Flutter Screen Wake'),
        ),
        body: Center(
            child: Container(
          decoration: const BoxDecoration(color: Colors.black38),
          child: Column(
            children: [
              AnimatedCrossFade(
                firstChild: const Icon(
                  Icons.brightness_7,
                  size: 50,
                ),
                secondChild: const Icon(
                  Icons.brightness_3,
                  size: 50,
                ),
                crossFadeState: _keepOn
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(seconds: 2),
              ),
              const SizedBox(
                height: 20,
              ),
              Slider(
                  value: _brightness,
                  onChanged: (value) {
                    setState(() {
                      _brightness = value;
                    });
                    FlutterScreenWake.setBrightness(_brightness);
                  }),
              Text('Keep ON: $_keepOn\n'),
              InkWell(
                  onTap: changeKeep,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(color: Colors.blue),
                    child: const Text('Change Wake'),
                  )),

              ///
              ///
              const SizedBox(
                height: 20,
              ),
              Text('Brightness: $_brightness\n'),
              InkWell(
                  onTap: changeBrightnessMax,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(color: Colors.blue),
                    child: const Text('Max brightness'),
                  )),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                  onTap: changeBrightnessMin,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(color: Colors.blue),
                    child: const Text('Min brightness'),
                  ))
            ],
          ),
        )),
      ),
    );
  }
}
