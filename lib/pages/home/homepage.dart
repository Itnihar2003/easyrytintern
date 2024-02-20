import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math' as math show sin, pi, sqrt;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_update/in_app_update.dart';

import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoaiapp/main.dart';

import 'package:todoaiapp/pages/Aipage.dart';
import 'package:todoaiapp/pages/home/cookingai.dart';

import 'package:todoaiapp/pages/home/recents.dart';
import 'package:todoaiapp/pages/home/setting.dart';
import 'package:todoaiapp/pages/notes/editnotes.dart';
import 'package:todoaiapp/pages/notes/notedata.dart';
import 'package:todoaiapp/pages/notes/notes.dart';

import 'package:http/http.dart' as http;
import 'package:todoaiapp/pages/home/suggestedpage.dart';
import 'package:todoaiapp/pages/ocrfinal/ocrhome.dart';

import 'package:todoaiapp/pages/todo/tododetail.dart';

class home extends StatefulWidget {
  List<data1> datas;

  home({
    super.key,
    required this.datas,
  });

  @override
  State<home> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<home> with TickerProviderStateMixin {
  //banneradds
  late BannerAd _bannerAd;

  bool _isadloaded = false;
  bool loadreward = false;
  initialadd() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: "ca-app-pub-3940256099942544/6300978111",
        listener: BannerAdListener(
          onAdLoaded: (Ad) {
            setState(() {
              _isadloaded = true;
            });
          },
          onAdFailedToLoad: (ad, error) {},
        ),
        request: AdRequest());
    _bannerAd.load();
  }

  late RewardedAd _rewardedAd;
  startrewardad() {
    RewardedAd.load(
        // adUnitId: "ca-app-pub-3940256099942544/5224354917",
        adUnitId: "ca-app-pub-1396556165266132/1772804526",
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (RewardedAd ad) {
              this._rewardedAd = ad;
            },
            onAdFailedToLoad: (LoadAdError error) {}));
  }

  List<data1> saveddata = [];

  showreward() {
    _rewardedAd.show(
      onUserEarnedReward: (ad, reward) {
        print("Rewarded money${reward.amount}");
      },
    );
    _rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {},
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
      },
      onAdWillDismissFullScreenContent: (ad) {
        ad.dispose();
      },
      onAdImpression: (ad) {
        print("$ad impression occure");
      },
    );
  }

  //rating the app
  final RateMyApp rateMyApp = RateMyApp(
      remindLaunches: 2,
      remindDays: 2,
      minDays: 0,
      minLaunches: 0,
      googlePlayIdentifier: "com.easyrytAiNotes");

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  Future<void> _sendAnalyticsEvent(String message, int nom) async {
    await analytics.logEvent(
      name: 'NotaAidetail',
      parameters: <String, dynamic>{
        'Page__name': message,
        'page__index': nom,
      },
    );

    setMessage('logEvent succeeded');
  }

  String _message = '';
  void setMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  //app update alert
  Future<void> checkForAppUpdate() async {
    if (kDebugMode) {
      print('checking for Update');
    }
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          if (kDebugMode) {
            print('Update Available');
          }
          updatedApps();
        } else {
          if (kDebugMode) {
            print('it is up to date');
          }
        }
      });
    }).catchError((e) {
      if (kDebugMode) {
        print('check update function error ${e.toString()}');
      }
    });
  }

  void updatedApps() async {
    await InAppUpdate.startFlexibleUpdate();
    InAppUpdate.completeFlexibleUpdate().then((_) {}).catchError((e) {
      if (kDebugMode) {
        print('update function error ${e.toString()}');
      }
    });
    if (kDebugMode) {
      print('updating');
    }
  }

  Timer? timer;
  @override
  void initState() {
    //only for final update on play store
    checkForAppUpdate();

    timer = Timer.periodic(Duration(seconds: 120), (Timer t) => showreward());

    startrewardad();
    // initialadd();

    analytics.setAnalyticsCollectionEnabled(true);
    rateMyApp.init().then((_) {
      rateMyApp.conditions.forEach((condition) {
        if (condition is DebuggableCondition) {
          print(condition.valuesAsString);
        }
      });
      if (rateMyApp.shouldOpenDialog) {
        rateMyApp.showStarRateDialog(
          context,
          title: "Rate this APP",
          message:
              "you like this app ? Then take a little bit of your time to Leave a rating",
          actionsBuilder: (context, stars) {
            return [
              TextButton(
                  onPressed: () async {
                    stars = stars ?? 0;
                    print("Thank you for the :${stars.toString()}");
                    if (stars! < 4) {
                      print("Would you like to send any feedback");
                    } else {
                      Navigator.pop<RateMyAppDialogButton>(
                          context, RateMyAppDialogButton.rate);
                      await rateMyApp
                          .callEvent(RateMyAppEventType.rateButtonPressed);
                      // if ((await rateMyApp.isNativeReviewDialogSupported) ??
                      //     false) {
                      //   await rateMyApp.launchNativeReviewDialog();
                      // }
                      rateMyApp.launchStore();
                    }
                  },
                  child: Text(
                    "ok",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ))
            ];
          },
          ignoreNativeDialog: true,
          dialogStyle: DialogStyle(
              titleAlign: TextAlign.center,
              messageAlign: TextAlign.center,
              messagePadding: EdgeInsets.only(bottom: 20)),
          starRatingOptions: StarRatingOptions(),
          onDismissed: () {
            rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed);
          },
        );
      }
    });
    update();
    super.initState();
    // generateDeviceIdentifier();
  }

  // save() {
  //   FirebaseDatabase.instance.ref("post").set({"name2": "nihar"});
  // }

  bool isLoading = true;
  String baseUrl = 'https://scannerimage-e52f6979766b.herokuapp.com';
  void showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id', // Change this to a unique ID for your app
      'Your Channel Name',
      // 'Your Channel Description',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Change this to a unique notification ID
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }
  //concent form

  List text = [
    "Marketing Strategy Blueprint:",
    "Resume Enhancement Studio:",
    "Cover Letter Composer:",
    "Speechcraft Navigator:",
    "Content Summarization Tool:",
    "Mail Mastery Assistant:",
    "Weekly Planner Generator:",
    "Stand-Up Comedy Companion:",
    "Holiday Wishes Generator:",
    "Dream Interpretation Wizard:",
    "Fun Suggestions Hub:",
    "Song Recommendations Maven:",
    "Shopping Advice Advisor:",
    "Improvise Recipes Companion :",
    "Travel Guide Companion:",
    "Instagram Captions Guru:",
    "Tweet Generator:",
    "YouTube Script Creator:",
    "Restaurant Reviews Companion:",
    "Technology Insight Hub:",
    "Life Guide Advisor:",
    "English Enhancement Studio:",
    "Language Recognition Navigator:",
    "Identify languages easily: notes on patterns, dialects, nuances.",
    "Chinese-English Translation Wizard:",
    "Poetry Crafting Studio:",
    "Article Extension Navigator:",
    "Writing Materials Collection:",
    "Writing Advisory Hub :",
    "Writing Support System",
    "Storytelling Keywords Generator:",
    "SEO-Optimized Article Wizard:",
    "Book Summaries Companion:",
    "Philosophical Pondering Aid:",
    "Fallacy Detection System:",
    "Debate Perspective Generator:",
    "Theme Deconstruction Companion:",
    "Think Tank Assistant:",
    "Question Query Companion:"
  ];
  List text4 = [
    "Create impactful ad plans, targeting effectively. ",
    "Optimize content, format, showcase achievements—elevate profile. ",
    "Craft personalized, skill-focused cover letters. ",
    "Master public speaking: key points, impact.",
    " Condense details, maintain clarity—summarize effectively. ",
    "Refine email communication: language, tone, structure. ",
    "Prioritize tasks, set goals—boost productivity weekly. ",
    "Craft hilarious punchlines, witty observations—laughter guaranteed. ",
    "Spread joy, warmth—personalized holiday wishes crafted. ",
    "Understand dream symbolism—unravel nightly mysteries. ",
    "Roll good times with creative leisure. ",
    "Elevate playlist: personalized notes, mood-matching recommendations.",
    "Make informed shopping decisions—expert reviews, trends, comparisons.",
    "Kitchen maestro: enhance, experiment with culinary improvisation.",
    "Effortless adventure planning: personalized travel notes, insider tips.",
    "Elevate social media: catchy, engaging photo captions.",
    "Create tweets: quick-witted, attention-grabbing content.",
    "Create YouTube scripts: engage, entertain, compel.",
    "Craft engaging restaurant reviews: ambiance, cuisine, experience.",
    "Cutting-edge tech reviews: features, performance, user experience.",
    "Navigate life's complexities: personalized notes, holistic guidance.",
    "Expand English writing: grammar, vocabulary, structure refinement.",
    "Identify languages easily: notes on patterns, dialects, nuances.",
    "Translate Chinese to English seamlessly: context, culture.",
    "Craft expressive poems: refine rhythm, imagery, devices.",
    "Continue articles seamlessly: content, tone, structure continuity.",
    "Curate diverse writing materials: genres, styles, themes.",
    "Gain expert writing advice: technique, style, storytelling.",
    "Assist at every writing stage: brainstorming, drafting, polishing.",
    "Spark creativity: curated keywords inspire enriched narrative.",
    "Optimize online presence with SEO articles.",
    "Summarize books: key themes, characters, plot.",
    "Deepen philosophy: key concepts, theories, perspectives notes.",
    "Hone argumentative skills: fallacy finder notes, logical errors.",
    " Craft compelling debate points: diverse viewpoints, enriched arguments.",
    "Explore themes deeply: symbolism, motifs, underlying messages.",
    "Innovate with think tank's collaborative notes.",
    "Hone questioning skills: craft thoughtful, probing questions."
  ];
  var permission = Permission.manageExternalStorage.request();
//permission for internal storage acess
  // Future<bool> _request_per(Permission permission) async {
  //   AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;
  //   if (build.version.sdkInt >= 5) {
  //     var re = await Permission.manageExternalStorage.request();
  //     if (re.isGranted) {
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } else {
  //     if (await permission.isGranted) {
  //       return true;
  //     } else {
  //       var result = await permission.request();
  //       if (result.isGranted) {
  //         return true;
  //       } else {
  //         return false;
  //       }
  //     }
  //   }
  // }

  //filter operation
  final searchfielter = TextEditingController();
  //convert to docoment

  Future<void> convertToDocx(String doc) async {
    if (isLoading) {
      showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        ),
      );
    } else {
      const Text("");
    }

    print("docx conversion started");

    final String convertUrl = '$baseUrl/doc/textToDoc';

    try {
      // Directory? directory = await getExternalStorageDirectory();

      Directory directory = Directory('/storage/emulated/0/Download');
      if (await directory.exists()) {
        String directoryPath = directory.path;
        String fileName =
            'converted_text_${DateTime.now().millisecondsSinceEpoch}.docx';

        final userData = {"text": doc};
        print(doc);
        http.Response response = await http.post(
          Uri.parse(convertUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(userData),
        );
        print(response.statusCode);
        if (response.statusCode == 200) {
          List<int> docxBytes = response.bodyBytes;
          String filePath = '$directoryPath/$fileName';
          await File(filePath).writeAsBytes(docxBytes);
          showNotification(
              'DOC Conversion Successful', 'Successfully converted to Doc');

          // await OpenFile.open(filePath);
          Future.delayed(const Duration(seconds: 5), () async {
            Navigator.of(context).pop();
            await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Success'),
                content: const Text('Successfully converted to Doc '),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        PageTransition(
                          child: home(datas: const []),
                          type: PageTransitionType.fade,
                          isIos: true,
                          duration: const Duration(milliseconds: 900),
                        ),
                        (route) => false),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          });
        } else {
          setState(() {
            isLoading = false;
          });
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: Text('Failed to convert to DOCX ${response.statusCode}'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );

          print('Failed to convert to DOCX: ${response.statusCode}');
        }
      } else {
        print('External storage directory not available');
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to convert to DOCX'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

//convert to text

  Future<void> downloadTxt(String txt) async {
    if (isLoading) {
      showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        ),
      );
    } else {
      const Text("");
    }
    print("text conversion started");

    // final String convertUrl = 'https://ocr-xj19.onrender.com/txt/textTotxt';
    final String convertUrl = '$baseUrl/txt/textTotxt';

    try {
      // Directory? directory = await getExternalStorageDirectory();
      // if (directory != null) {
      Directory directory = Directory('/storage/emulated/0/Download');
      if (await directory.exists()) {
        String directoryPath = directory.path;
        String fileName =
            'converted_text_${DateTime.now().millisecondsSinceEpoch}.txt';
        final userData = {"text": txt};
        http.Response response = await http.post(
          Uri.parse(convertUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(userData),
        );
        print(response.statusCode);
        if (response.statusCode == 200) {
          List<int> txtBytes = response.bodyBytes;
          String filePath = '$directoryPath/$fileName';
          await File(filePath).writeAsBytes(txtBytes);
          showNotification(
              'TXT Conversion Successful', 'Successfully converted to txt');

          // await OpenFile.open(filePath);
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.of(context).pop();
            // Close the dialog

            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Success'),
                content: const Text('Successfully converted to txt '),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        PageTransition(
                          child: home(datas: const []),
                          type: PageTransitionType.fade,
                          isIos: true,
                          duration: const Duration(milliseconds: 900),
                        ),
                        (route) => false),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
            print("loading");
            setState(() {
              isLoading = false;
            });
          });
        } else {
          setState(() {
            isLoading = false;
          });
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: Text('Failed to convert to TXT ${response.statusCode}'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
          // throw 'Failed to convert to TXT: ${response.statusCode}';
        }
      } else {
        print('External storage directory not available');
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to convert to TXT'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
//convert to pdf

  Future<void> convertToPDF(String pdf) async {
    if (isLoading) {
      showDialog(
        context: context,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: Colors.blue,
          ),
        ),
      );
    } else {
      const Text("");
    }

    print("pdf conversion started");
    // final String convertUrl = 'https://ocr-xj19.onrender.com/pdf/textToPdf';
    final String convertUrl = '$baseUrl/pdf/textToPdf';

    try {
      // Directory? directory = await getExternalStorageDirectory();
      Directory directory = Directory('/storage/emulated/0/Download');
      print(directory);
      if (await directory.exists()) {
        String directoryPath = directory.path;
        String fileName =
            'converted_text_${DateTime.now().millisecondsSinceEpoch}.pdf';

        // here in body add langcode same as language code selected
        final userData = {"text": pdf, "langCode": 'eng'};
        http.Response response = await http.post(
          Uri.parse(convertUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(userData),
        );

        print(response.statusCode);
        if (response.statusCode == 200) {
          List<int> pdfBytes = response.bodyBytes;
          String filePath = '$directoryPath/$fileName';
          await File(filePath).writeAsBytes(pdfBytes);
          // await OpenFile.open(filePath);
          showNotification(
              'PDF Conversion Successful', 'Successfully converted to PDF');
          Future.delayed(const Duration(seconds: 5), () {
            Navigator.of(context).pop();

            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Success'),
                content: const Text('Successfully converted to pdf '),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        PageTransition(
                          child: home(datas: const []),
                          type: PageTransitionType.fade,
                          isIos: true,
                          duration: const Duration(milliseconds: 900),
                        ),
                        (route) => false),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );

            print("loading");
            setState(() {
              isLoading = false;
            });
          });
        } else {
          setState(() {
            isLoading = false;
          });

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Error'),
              content: Text('Failed to convert to pdf ${response.statusCode}'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
          print('Failed to convert to PDF: ${response.statusCode}');
        }
      } else {
        print('External storage directory not available');
      }
    } catch (error) {
      print('Error: $error');
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to convert to pdf'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  setdata1() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> data2list =
        widget.datas.map((data1) => jsonEncode(data1.toJson())).toList();
    pref.setStringList('myData2', data2list);
  }

  getdata() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String>? data2list = pref.getStringList('myData2');
    if (data2list != null) {
      List<data1> finaldata2 = data2list
          //here data and data1 are not same
          .map((data2) => data1.fromJson(json.decode(data2)))
          .toList();
      return finaldata2;
    }
  }

  update() async {
    List<data1> sdata = await getdata();
    setState(() {
      widget.datas = sdata;
    });
  }

  late final AnimationController _controller =
      AnimationController(vsync: this, duration: const Duration(seconds: 10))
        ..repeat();
  @override
  void dispose() {
    _controller.dispose();
    timer?.cancel();
    super.dispose();
  }

  int num = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: AppBar().preferredSize.height,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 55,
                                    width: 200,
                                    padding: const EdgeInsets.only(right: 2),
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 244, 243, 243),
                                      border: Border.all(color: Colors.white),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: TextField(
                                      onTap: () {
                                        _sendAnalyticsEvent("setting", 7);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => recent(
                                                datas: widget.datas,
                                              ),
                                            ));
                                      },
                                      controller: searchfielter,
                                      cursorColor: Colors.black,
                                      style: TextStyle(fontSize: 12),
                                      decoration: const InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: Colors.black,
                                        ),
                                        hintText: "Search",
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        _sendAnalyticsEvent("seetingpage", 5);

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => setting(),
                                            ));
                                      },
                                      icon: const Icon(Icons.settings)),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      // _isadloaded
                      //     ? Container(
                      //         height: _bannerAd.size.height.toDouble(),
                      //         width: _bannerAd.size.width.toDouble(),
                      //         child: AdWidget(ad: _bannerAd),
                      //       )
                      //     : Container(
                      //         height: _bannerAd.size.height.toDouble(),
                      //         width: _bannerAd.size.width.toDouble(),
                      //         color: Colors.amber,
                      //       ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            "Quick Tools",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            quickTools("assets/np.png", "Notes", 1),
                            const SizedBox(width: 10),
                            quickTools("assets/tp1.png", "To-do", 2),
                            // const SizedBox(width: 10),
                            // quickTools(
                            //     "assets/diary.png", "speech\nto text", 3),
                            const SizedBox(width: 10),
                            quickTools("assets/confetti.png", "OCR", 3),
                            const SizedBox(width: 10),
                            quickTools("assets/l3.png", "AI Notes", 4),
                          ],
                        ),
                      ),
                      //
                      // Recents
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            "Suggested",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: suggesion(text, text4),
                      ),
                      SizedBox(
                        height: 30,
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            "Recents",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: widget.datas.length > 10
                              ? 1050
                              : (widget.datas.length % 2 == 0)
                                  ? (widget.datas.length / 2) * 207
                                  : ((widget.datas.length + 1) / 2) * 207,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisExtent: 200,
                              crossAxisCount: 2,
                              mainAxisSpacing: 10.0,
                            ),
                            itemCount: widget.datas.length > 10
                                ? 10
                                : widget
                                    .datas.length, // Total number of containers
                            itemBuilder: (BuildContext context, int index) {
                              int index1 = widget.datas.length - 1 - index;
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(15),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => editnotes(
                                            tittle:
                                                widget.datas[index1].tittle1,
                                            content:
                                                widget.datas[index1].content1,
                                            id: index1,
                                            edit: widget.datas,
                                          ),
                                        ));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color.fromRGBO(0, 0, 0, 0.09),
                                          blurRadius: 1,
                                          spreadRadius: 0,
                                          offset: Offset(-4, 4),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 50,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 2),
                                          width: double.infinity,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                width: 98,
                                                height: 22,
                                                child: Text(
                                                  widget.datas[index1].tittle1,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    showModalBottomSheet(
                                                      context: context,
                                                      builder: (context) =>
                                                          SizedBox(
                                                        height: 350,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          5),
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          6),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          6),
                                                                ),
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      const SizedBox(
                                                                          height:
                                                                              50,
                                                                          width:
                                                                              10),
                                                                      Text(
                                                                        "Quick Note",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          right:
                                                                              10),
                                                                      child:
                                                                          TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          "close",
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                        ),
                                                                      )),
                                                                ],
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Container(
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  color: Color(
                                                                      0xFFF6F6F6),
                                                                ),
                                                                child:
                                                                    SingleChildScrollView(
                                                                  child: Column(
                                                                    children: [
                                                                      const SizedBox(
                                                                          height:
                                                                              2.5),
                                                                      const Padding(
                                                                        padding:
                                                                            EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              5,
                                                                          vertical:
                                                                              2.5,
                                                                        ),
                                                                      ),
                                                                      TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            FlutterClipboard.copy("${widget.datas[index1].tittle1}\n${widget.datas[index1].content1}");
                                                                            Get.snackbar("copied",
                                                                                "");
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                30,
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Row(
                                                                                    children: [
                                                                                      Container(height: 20, width: 30, color: Colors.white, child: Image.asset("assets/copy.png")),
                                                                                      Text(
                                                                                        "copy to clipboard",
                                                                                        style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w400),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Icon(
                                                                                        Icons.arrow_forward_ios,
                                                                                        size: 20,
                                                                                      )
                                                                                    ],
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          )),
                                                                      TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            convertToPDF("${widget.datas[index1].tittle1}\n\n${widget.datas[index1].content1}");
                                                                            print("permission granted");
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                30,
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Row(
                                                                                    children: [
                                                                                      Container(height: 20, width: 30, color: Colors.white, child: Image.asset("assets/pop.png")),
                                                                                      Text(
                                                                                        "PDF",
                                                                                        style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w400),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Icon(
                                                                                        Icons.arrow_forward_ios,
                                                                                        size: 20,
                                                                                      )
                                                                                    ],
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          )),
                                                                      TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            convertToDocx("${widget.datas[index1].tittle1}\n\n${widget.datas[index1].content1}");
                                                                            print("permission granted");
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                30,
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Row(
                                                                                    children: [
                                                                                      Container(height: 20, width: 30, color: Colors.white, child: Image.asset("assets/word.png")),
                                                                                      Text(
                                                                                        "Word",
                                                                                        style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w400),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Icon(
                                                                                        Icons.arrow_forward_ios,
                                                                                        size: 20,
                                                                                      )
                                                                                    ],
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          )),
                                                                      TextButton(
                                                                          onPressed:
                                                                              () {
                                                                            downloadTxt("${widget.datas[index1].tittle1}\n\n${widget.datas[index1].content1}");
                                                                            print("permission granted");
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                30,
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Row(
                                                                                    children: [
                                                                                      Container(height: 20, width: 30, color: Colors.white, child: Image.asset("assets/text.png")),
                                                                                      Text(
                                                                                        "Txt",
                                                                                        style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w400),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Icon(
                                                                                        Icons.arrow_forward_ios,
                                                                                        size: 20,
                                                                                      )
                                                                                    ],
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          )),
                                                                      TextButton(
                                                                          onPressed:
                                                                              () async {
                                                                            await Share.share(widget.datas[index1].tittle1 +
                                                                                "\n" +
                                                                                widget.datas[index1].content1 +
                                                                                "\n" +
                                                                                "https://bit.ly/4bk7ZAV");
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                30,
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Row(
                                                                                    children: [
                                                                                      Container(height: 20, width: 30, color: Colors.white, child: Image.asset("assets/share.png")),
                                                                                      Text(
                                                                                        "Share",
                                                                                        style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w400),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Icon(
                                                                                        Icons.arrow_forward_ios,
                                                                                        size: 20,
                                                                                      )
                                                                                    ],
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          )),
                                                                      TextButton(
                                                                          onPressed:
                                                                              () async {
                                                                            setState(() {
                                                                              widget.datas.removeAt(index1);
                                                                              setdata1();
                                                                            });
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                30,
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Row(
                                                                                    children: [
                                                                                      Container(height: 20, width: 30, color: Colors.white, child: Image.asset("assets/delete.png")),
                                                                                      Text(
                                                                                        "Delete",
                                                                                        style: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w400),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Icon(
                                                                                        Icons.arrow_forward_ios,
                                                                                        size: 20,
                                                                                      )
                                                                                    ],
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          )),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  icon: SizedBox(
                                                    width: 12,
                                                    height: 12,
                                                    child: Image.asset(
                                                        "assets/dot.png"),
                                                  ))
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: SizedBox(
                                              height: 120,
                                              child: SingleChildScrollView(
                                                  child: Text(widget
                                                      .datas[index1]
                                                      .content1))),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      widget.datas.length > 10
                          ? Center(
                              child: Container(
                                width: 120,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 150),
                                  child: Center(
                                      child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => recent(
                                                    datas: widget.datas,
                                                  ),
                                                ));
                                          },
                                          child: Row(
                                            children: [
                                              Text(
                                                "See All",
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              Icon(
                                                Icons.arrow_forward,
                                                color: Colors.black,
                                              )
                                            ],
                                          ))),
                                ),
                              ),
                            )
                          : SizedBox(
                              height: 0,
                            )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CupertinoButton(
        onPressed: () {
          _sendAnalyticsEvent("AI Notes", 4);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ai(),
              ));
        },
        child: Stack(
          children: [
            WaveAnimation(
              size: 60.0,
              color: Color.fromARGB(255, 172, 172, 172),
              centerChild: Stack(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _sendAnalyticsEvent("AI Notes", 4);
                      // Handle button tap
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ai(),
                          ));
                    },
                    child: Text(""),
                  ),
                ],
              ),
            ),
            Positioned(
                top: 11.5,
                left: 7,
                child: Image.asset(
                  "assets/gpt4.png",
                  width: 85,
                ))
          ],
        ),
      ),
    );
  }

  Widget suggesion(List text, List text4) {
    return SizedBox(
      height: 135,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 8 + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 8) {
            return Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(15)),
              child: IconButton(
                  onPressed: () {
                    _sendAnalyticsEvent("suggestions", 6);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => suggesiondetail(
                            suggestedtext: text,
                            suggestedcontent: text4,
                          ),
                        ));
                  },
                  icon: Icon(Icons.send)),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  // showreward();
                  _sendAnalyticsEvent("suggestions", 6);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ai2(
                          givendata: text[index],
                          givencontent: text4[index],
                        ),
                      ));
                },
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        ListView(
                          children: [
                            Text(
                              text[index],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              text4[index],
                              style:
                                  TextStyle(color: Colors.black, fontSize: 9),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.18),
                        blurRadius: 1,
                        spreadRadius: 1,
                        offset: Offset(-2, 2),
                      ),
                    ],
                  ),
                  height: 135,
                  width: 121.59,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget quickTools(
    String imageUrl,
    String title,
    int index,
  ) {
    return Expanded(
      child: InkWell(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        onTap: () {
          if (index == 1) {
            _sendAnalyticsEvent(title, index);
            Get.to(() => const notes());
          } else if (index == 2) {
            _sendAnalyticsEvent(title, index);
            Get.to(() => const detail());
          } else if (index == 3) {
            _sendAnalyticsEvent(title, index);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ocrhome(),
                ));
          } else if (index == 4) {
            _sendAnalyticsEvent(title, index);
            Get.to(() => ai());
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 57,
              height: 57,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.18),
                    blurRadius: 2,
                    spreadRadius: 0.6,
                    offset: Offset(-2, 1.5),
                  ),
                ],
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder<Object>(
                      stream: null,
                      builder: (context, snapshot) {
                        return Container(
                          height: 38,
                          width: 38,
                          child: Image(
                            image: AssetImage(imageUrl),
                            fit: BoxFit.cover,
                          ),
                        );
                      }),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageChanger extends StatefulWidget {
  const ImageChanger({
    Key? key,
  }) : super(key: key);

  @override
  _ImageChangerState createState() => _ImageChangerState();
}

class _ImageChangerState extends State<ImageChanger> {
  int _index = 0; // the current index of the image list
  late Timer _timer; // the timer object
  List images = [
    "assets/all3.png",
    "assets/g.png",
    "assets/s.png",
    "assets/speech.png",
    "assets/to.png"
  ];

  @override
  void initState() {
    super.initState();
    // initialize the timer with the given duration and a callback function
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      // update the index and wrap around if necessary
      setState(() {
        _index = (_index + 1) % images.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // set the decoration property with the image at the current index
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(images[_index]),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  @override
  void dispose() {
    // cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }
}

class WaveAnimation extends StatefulWidget {
  final double size;
  final Color color;
  final Widget centerChild;

  const WaveAnimation({
    this.size = 80.0,
    this.color = Colors.red,
    required this.centerChild,
    Key? key,
  }) : super(key: key);

  @override
  WaveAnimationState createState() => WaveAnimationState();
}

class WaveAnimationState extends State<WaveAnimation>
    with TickerProviderStateMixin {
  late AnimationController animCtr;

  @override
  void initState() {
    super.initState();
    animCtr = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  Widget getAnimatedWidget() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.size),
          gradient: RadialGradient(
            colors: [
              widget.color,
              Color.lerp(widget.color, Colors.black, .05)!
            ],
          ),
        ),
        child: ScaleTransition(
          scale: Tween(begin: 0.95, end: 1.0).animate(
            CurvedAnimation(
              parent: animCtr,
              curve: CurveWave(),
            ),
          ),
          child: Container(
            width: widget.size * 0.4,
            height: widget.size * 0.4,
            margin: const EdgeInsets.all(6),
            child: widget.centerChild,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(context) {
    return CustomPaint(
      painter: CirclePainter(animCtr, color: widget.color),
      child: SizedBox(
        width: widget.size * 1.6,
        height: widget.size * 1.6,
        child: getAnimatedWidget(),
      ),
    );
  }

  @override
  void dispose() {
    animCtr.dispose();
    super.dispose();
  }
}

class CirclePainter extends CustomPainter {
  final Color color;
  final Animation<double> animation;

  CirclePainter(
    this.animation, {
    required this.color,
  }) : super(repaint: animation);

  void circle(Canvas canvas, Rect rect, double value) {
    final double opacity = (1.0 - (value / 4.0)).clamp(0.0, 1.0);
    final Color rippleColor = color.withOpacity(opacity);
    final double size = rect.width / 2;
    final double area = size * size;
    final double radius = math.sqrt(area * value / 4);
    final Paint paint = Paint()..color = rippleColor;
    canvas.drawCircle(rect.center, radius, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    for (int wave = 3; wave >= 0; wave--) {
      circle(canvas, rect, wave + animation.value);
    }
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) => true;
}

class CurveWave extends Curve {
  @override
  double transform(double t) {
    if (t == 0 || t == 1) {
      return 0.01;
    }
    return math.sin(t * math.pi);
  }
}
