import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:dropdownfield2/dropdownfield2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoaiapp/pages/home/homepage.dart';
import 'package:todoaiapp/pages/todo/complete.dart';
import 'package:todoaiapp/pages/todo/data.dart';
import 'package:todoaiapp/pages/todo/deletedata.dart';
import 'package:todoaiapp/pages/todo/notification.dart';

import 'package:todoaiapp/pages/todo/todoedit.dart';
import 'package:todoaiapp/pages/todo/workdata.dart';
import 'dart:math' as math show sin, pi, sqrt;

var remindertime1 = "";

class detail extends StatefulWidget {
  final finalcontent;
  final finaltittle;
  final finalindex;
  final finalpriority;
  final finalduedate;
  final reminder;
  const detail(
      {super.key,
      this.finalindex,
      this.finalcontent,
      this.finaltittle,
      this.finalpriority,
      this.finalduedate,
      this.reminder});

  @override
  State<detail> createState() => _detailState();
}

class _detailState extends State<detail> {
  var scheduleTime;
  var duetime;
  Notificationservice notificationservice = Notificationservice();
  @override
  void initState() {
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      finalid++;
      upload();
    });
    startrewardad();
    update1();
    update();
    // Timer(Duration(seconds: 2), () {
    //   setState(() {});
    // });
    super.initState();
    notificationservice.initialisenotification();
  }

  TextEditingController pop = TextEditingController();
  TextEditingController pop1 = TextEditingController();
  TextEditingController date1 = TextEditingController();
  TextEditingController datetimecontroler = TextEditingController();
  TextEditingController priority = TextEditingController();
  List<data> data1s = [];
  List<data4> deletedata = [];
  int selectedindex = -1;

  setdata() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> data1List =
        data1s.map((data) => jsonEncode(data.toJson())).toList();
    pref.setStringList('myData', data1List);
  }

  List<workdata> worklist = [];
  setdata1() async {
    SharedPreferences pref1 = await SharedPreferences.getInstance();
    List<String> deleteList =
        deletedata.map((data4) => jsonEncode(data4.toJson())).toList();
    pref1.setStringList('myData1', deleteList);
  }

  DateTime datetime = DateTime.now();
  String finaldatetime = "";
  String val = "";
  getdata() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String>? data1List = pref.getStringList('myData');
    if (data1List != null) {
      List<data> finaldata = data1List
          //here data and data1 are not same
          .map((data1) => data.fromJson(json.decode(data1)))
          .toList();
      return finaldata;
    }
  }

  getdata1() async {
    SharedPreferences pref1 = await SharedPreferences.getInstance();
    List<String>? deleteList = pref1.getStringList('myData1');
    if (deleteList != null) {
      List<data4> finaldata = deleteList
          //here data and data1 are not same
          .map((data3) => data4.fromJson(json.decode(data3)))
          .toList();
      return finaldata;
    }
  }

  update() async {
    List<data> sdata = await getdata();
    setState(() {
      data1s = sdata;
    });
  }

  late Color selectedcolour;
  bool isselected = false;
  update1() async {
    List<data4> delete = await getdata1();
    setState(() {
      deletedata = delete;
    });
  }

  savedeleteitem(
      String tittle,
      String content,
      String priority,
      String duedate,
      bool check,
      String reminder,
      //  String category;
      int id) {
    setState(() {
      deletedata.add(data4(
          tittle: tittle,
          content: content,
          priority: priority,
          duedate: duedate,
          check: check,
          id: id,
          reminder: reminder));
    });

    setdata1();
  }

  late RewardedAd _rewardedAd;
  startrewardad() {
    RewardedAd.load(
        adUnitId: "ca-app-pub-3940256099942544/5224354917",
        // adUnitId: "ca-app-pub-1396556165266132/1772804526",
        request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (RewardedAd ad) {
              this._rewardedAd = ad;
            },
            onAdFailedToLoad: (LoadAdError error) {}));
  }

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

  save(int id) {
    if (pop.text != "" &&
        pop1.text != "" &&
        dropdownValue != "" &&
        date1.text != "") {
      setState(() {
        data1s.add(data(
          tittle: pop.text.trim(),
          content: pop1.text.trim(),
          priority: dropdownValue.toString(),
          duedate: date1.text.trim(),
          check: check,
          id: id,
          reminder: datetimecontroler.text.toString(),
        ));
      });
      setdata();
    } else {
      Get.snackbar("Error", "Plese fill all data",
          backgroundColor: Colors.grey);
    }
  }

  upload() {
    setState(() {
      selectedindex = widget.finalindex;
      data1s[selectedindex].tittle = widget.finaltittle;
      data1s[selectedindex].content = widget.finalcontent;
      data1s[selectedindex].priority = widget.finalpriority;
      data1s[selectedindex].duedate = widget.finalduedate;
      data1s[selectedindex].reminder = widget.reminder;
    });
    setdata();
  }

  String priorityid = "";

  bool check = false;
  String finaldate = "";
  String b = "";
  String finaltime = "";
  int finalid = 0;
  String? dropdownValue;
  DateTime selectedDate = DateTime.now();

  final DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');

  show1() {
    showGeneralDialog(
      barrierColor: Colors.transparent,
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) => Scaffold(
        appBar: AppBar(
          title: Text(
            "Create Task",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 30,
                color: Colors.black,
              )),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 16),
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tittle",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.09),
                            blurRadius: 3,
                            spreadRadius: 2,
                            offset: Offset(0, 0),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    child: TextField(
                      controller: pop,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.white)),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.all(15.0),
                          hintText: "What whould you like to do?",
                          hintStyle: TextStyle(
                            fontSize: 14,
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Description",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.09),
                            blurRadius: 3,
                            spreadRadius: 2,
                            offset: Offset(0, 0),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    child: TextField(
                      maxLines: 3,
                      controller: pop1,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.white)),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.all(15.0),
                          hintText: "Description",
                          hintStyle: TextStyle(
                            fontSize: 14,
                          )),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Category",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.09),
                            blurRadius: 3,
                            spreadRadius: 2,
                            offset: Offset(0, 0),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.white)),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.all(15.0),
                          hintText: "Category",
                          hintStyle: TextStyle(
                            fontSize: 14,
                          )),
                      value: dropdownValue,
                      items: [
                        DropdownMenuItem(
                          value: "Work",
                          child: Row(
                            children: <Widget>[
                              SizedBox(width: 10),
                              Text("Work"),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: "Personal",
                          child: Row(
                            children: <Widget>[
                              SizedBox(width: 10),
                              Text("Personal"),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: "Wishlist",
                          child: Row(
                            children: <Widget>[
                              SizedBox(width: 10),
                              Text("Wishlist"),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: "Birthday",
                          child: Row(
                            children: <Widget>[
                              SizedBox(width: 10),
                              Text("Birthday"),
                            ],
                          ),
                        ),
                      ],
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValue = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "DueDate",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.09),
                            blurRadius: 3,
                            spreadRadius: 2,
                            offset: Offset(0, 0),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white),
                    child: TextField(
                      controller: date1,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.white)),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.all(15.0),
                          hintText: "Enter Date",
                          prefixIcon: Icon(Icons.calendar_month_outlined),
                          hintStyle: TextStyle(
                            fontSize: 14,
                          ),
                          suffixIcon: IconButton(
                              onPressed: () async {
                                showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) {
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 300,
                                            height: 150,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: CupertinoDatePicker(
                                              minimumDate: DateTime.now(),
                                              maximumYear: DateTime.now().year,
                                              backgroundColor: Colors.white,
                                              onDateTimeChanged: (date) {
                                                setState(() {
                                                  date1.text = DateFormat(
                                                          "dd-MM-yyyy (hh:mm a )")
                                                      .format(date);
                                                });
                                                duetime = date;
                                                debugPrint(
                                                    'notification scheduked fir $scheduleTime');
                                              },
                                            ),
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                width: 300,
                                                color: Colors.white,
                                                child: Center(
                                                    child: Text(
                                                  "OK",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 22),
                                                )),
                                              ))
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.calendar_month))),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Reminder",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(0, 0, 0, 0.09),
                                blurRadius: 3,
                                spreadRadius: 2,
                                offset: Offset(0, 0),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white),
                        child: TextField(
                          controller: datetimecontroler,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.white)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(color: Colors.white)),
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: Icon(Icons.calendar_month_outlined),
                              contentPadding: EdgeInsets.all(15.0),
                              hintText: "Enter Date",
                              hintStyle: TextStyle(
                                fontSize: 14,
                              ),
                              suffixIcon: IconButton(
                                  onPressed: () async {
                                    showCupertinoModalPopup(
                                      context: context,
                                      builder: (context) {
                                        return Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 300,
                                                height: 150,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: CupertinoDatePicker(
                                                  minimumDate: DateTime.now(),
                                                  maximumYear:
                                                      DateTime.now().year,
                                                  backgroundColor: Colors.white,
                                                  onDateTimeChanged: (date) {
                                                    setState(() {
                                                      datetimecontroler
                                                          .text = DateFormat(
                                                              "dd-MM-yyyy (hh:mm a )")
                                                          .format(date);
                                                    });
                                                    scheduleTime = date;
                                                    debugPrint(
                                                        'notification scheduked fir $scheduleTime');
                                                    notificationservice
                                                        .scheduleNotification(
                                                            title:
                                                                'complete your task',
                                                            body: pop.text,
                                                            scheduledNotificationDateTime:
                                                                date.subtract(Duration(minutes: 5)),
                                                            id: finalid);
                                                  },
                                                ),
                                              ),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                    width: 300,
                                                    color: Colors.white,
                                                    child: Center(
                                                        child: Text(
                                                      "OK",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 22),
                                                    )),
                                                  ))
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.alarm))),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  // ElevatedButton(
                  //     onPressed: () {
                  //       notificationservice.scheduleminute("complete", "");
                  //     },
                  //     child: Text("everyminute")),
                  Center(
                    child: ElevatedButton(
                        onPressed: () {
                          // showreward();

                          finalid++;
                          for (int i = 0; i <= 16; i++) {
                            val = val + datetime.toString()[i];
                          }
                          save(finalid);
                          remindertime1 = finaltime;

                          print(remindertime1);
                          Navigator.pop(context);
                          pop.clear();
                          pop1.clear();

                          date1.clear();
                          datetimecontroler.clear();
                        },
                        child: const SizedBox(
                          width: 250,
                          height: 50,
                          child: Center(
                              child: Text(
                            "submit",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          )),
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => home(
                        datas: [],
                      ),
                    ),
                    (Route) => false);
              },
              icon: Icon(
                Icons.arrow_back,
                size: 25,
              )),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            TabBar(
                splashFactory: NoSplash.splashFactory,
                automaticIndicatorColorAdjustment: false,
                indicatorColor: Colors.black,
                mouseCursor: MaterialStateMouseCursor.textable,
                dividerColor: Colors.white,
                labelColor: Colors.black,
                unselectedLabelColor: const Color.fromARGB(255, 137, 137, 136),
                isScrollable: true,
                labelPadding: EdgeInsets.only(
                  right: 30,
                ),
                tabs: [
                  Tab(
                    text: "All",
                  ),
                  Tab(
                    text: "Work",
                  ),
                  Tab(
                    text: "Personal",
                  ),
                  Tab(
                    text: "Wishlist",
                  ),
                  Tab(
                    text: "Birthday",
                  )
                ]),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 400,
              child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Container(
                      height: 450,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        itemCount: data1s.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color.fromRGBO(0, 0, 0, 0.09),
                                        blurRadius: 3,
                                        spreadRadius: 1,
                                        offset: Offset(-5, 5),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(15),
                                    color: Colors.white),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(15),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => edit(
                                                  index: index,
                                                  tittlevalue:
                                                      data1s[index].tittle,
                                                  contentvalue:
                                                      data1s[index].content,
                                                  priorityvalue:
                                                      data1s[index].priority,
                                                  duedatevalue:
                                                      data1s[index].duedate,
                                                  edittodo: data1s,
                                                  reminder:
                                                      data1s[index].reminder,
                                                  id: data1s[index].id,
                                                )));
                                  },
                                  child: Container(
                                    height: 60,
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              // Image.asset(
                                              //   "assets/icons/menu.png",
                                              //   height: 20,
                                              //   width: 20,
                                              // ),
                                              Checkbox(
                                                value: data1s[index].check,
                                                onChanged: (value) {
                                                  setState(() {
                                                    data1s[index].check =
                                                        value!;
                                                    savedeleteitem(
                                                        data1s[index].tittle,
                                                        data1s[index].content,
                                                        data1s[index].priority,
                                                        data1s[index].duedate,
                                                        data1s[index].check,
                                                        data1s[index].reminder,
                                                        data1s[index].id);
                                                    setdata1();
                                                    data1s.removeAt(index);
                                                    setdata();
                                                    notificationservice
                                                        .stopNotifications(
                                                            data1s[index].id);
                                                  });
                                                },
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    data1s[index]
                                                                .tittle
                                                                .length >
                                                            20
                                                        ? data1s[index]
                                                                .tittle
                                                                .substring(
                                                                    0, 20) +
                                                            "..."
                                                        : data1s[index].tittle,
                                                    style: const TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black),
                                                  ),
                                                  Text(
                                                    data1s[index].duedate,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 10,
                                                        color: Color.fromARGB(
                                                            255, 207, 37, 25)),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                                onPressed: () {
                                                  notificationservice
                                                      .stopNotifications(
                                                          data1s[index].id);
                                                  setState(() {
                                                    data1s.removeAt(index);
                                                    setdata();
                                                  });
                                                },
                                                icon: const Icon(
                                                  Icons.delete,
                                                  size: 25,
                                                  color: Colors.black,
                                                )),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                          );
                        },
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 450,
                      child: ListView.builder(
                        itemCount: data1s.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (data1s[index].priority == "Work") {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color.fromRGBO(0, 0, 0, 0.09),
                                          blurRadius: 3,
                                          spreadRadius: 1,
                                          offset: Offset(-5, 5),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(15),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => edit(
                                                    edittodo: data1s,
                                                    index: index,
                                                    tittlevalue:
                                                        data1s[index].tittle,
                                                    contentvalue:
                                                        data1s[index].content,
                                                    priorityvalue:
                                                        data1s[index].priority,
                                                    duedatevalue:
                                                        data1s[index].duedate,
                                                    reminder:
                                                        data1s[index].reminder,
                                                    id: data1s[index].id,
                                                  )));
                                    },
                                    child: Container(
                                      height: 60,
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Checkbox(
                                                  value: data1s[index].check,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      data1s[index].check =
                                                          value!;
                                                      savedeleteitem(
                                                          data1s[index].tittle,
                                                          data1s[index].content,
                                                          data1s[index]
                                                              .priority,
                                                          data1s[index].duedate,
                                                          data1s[index].check,
                                                          data1s[index]
                                                              .reminder,
                                                          data1s[index].id);
                                                      setdata1();
                                                      data1s.removeAt(index);
                                                      setdata();
                                                      notificationservice
                                                          .stopNotifications(
                                                              data1s[index].id);
                                                    });
                                                  },
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data1s[index]
                                                                  .tittle
                                                                  .length >
                                                              20
                                                          ? data1s[index]
                                                                  .tittle
                                                                  .substring(
                                                                      0, 20) +
                                                              "..."
                                                          : data1s[index]
                                                              .tittle,
                                                      style: const TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black),
                                                    ),
                                                    Text(
                                                      data1s[index].duedate,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 10,
                                                          color: Color.fromARGB(
                                                              255,
                                                              207,
                                                              37,
                                                              25)),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    notificationservice
                                                        .stopNotifications(
                                                            data1s[index].id);
                                                    setState(() {
                                                      data1s.removeAt(index);
                                                      setdata();
                                                    });
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    size: 25,
                                                    color: Colors.black,
                                                  )),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                            );
                          } else {
                            return SizedBox(
                              height: 0,
                            );
                          }
                        },
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 450,
                      child: ListView.builder(
                        itemCount: data1s.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (data1s[index].priority == "Personal") {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color.fromRGBO(0, 0, 0, 0.09),
                                          blurRadius: 3,
                                          spreadRadius: 1,
                                          offset: Offset(-5, 5),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(15),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => edit(
                                                    edittodo: data1s,
                                                    index: index,
                                                    tittlevalue:
                                                        data1s[index].tittle,
                                                    contentvalue:
                                                        data1s[index].content,
                                                    priorityvalue:
                                                        data1s[index].priority,
                                                    duedatevalue:
                                                        data1s[index].duedate,
                                                    reminder:
                                                        data1s[index].reminder,
                                                    id: data1s[index].id,
                                                  )));
                                    },
                                    child: Container(
                                      height: 60,
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                // Image.asset(
                                                //   "assets/icons/menu.png",
                                                //   height: 20,
                                                //   width: 20,
                                                // ),
                                                Checkbox(
                                                  value: data1s[index].check,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      setState(() {
                                                        data1s[index].check =
                                                            value!;
                                                        savedeleteitem(
                                                            data1s[index]
                                                                .tittle,
                                                            data1s[index]
                                                                .content,
                                                            data1s[index]
                                                                .priority,
                                                            data1s[index]
                                                                .duedate,
                                                            data1s[index].check,
                                                            data1s[index]
                                                                .reminder,
                                                            data1s[index].id);
                                                        setdata1();
                                                        data1s.removeAt(index);
                                                        setdata();
                                                        notificationservice
                                                            .stopNotifications(
                                                                data1s[index]
                                                                    .id);
                                                      });
                                                    });
                                                  },
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data1s[index]
                                                                  .tittle
                                                                  .length >
                                                              20
                                                          ? data1s[index]
                                                                  .tittle
                                                                  .substring(
                                                                      0, 20) +
                                                              "..."
                                                          : data1s[index]
                                                              .tittle,
                                                      style: const TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black),
                                                    ),
                                                    Text(
                                                      data1s[index].duedate,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 10,
                                                          color: Color.fromARGB(
                                                              255,
                                                              207,
                                                              37,
                                                              25)),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    notificationservice
                                                        .stopNotifications(
                                                            data1s[index].id);
                                                    setState(() {
                                                      data1s.removeAt(index);
                                                      setdata();
                                                    });
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    size: 25,
                                                    color: Colors.black,
                                                  )),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                            );
                          } else {
                            return SizedBox(
                              height: 0,
                            );
                          }
                        },
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 450,
                      child: ListView.builder(
                        itemCount: data1s.length,
                        itemBuilder: (BuildContext context, int index) {
                          if (data1s[index].priority == "Wishlist") {
                            return Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                  decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color.fromRGBO(0, 0, 0, 0.09),
                                          blurRadius: 3,
                                          spreadRadius: 1,
                                          offset: Offset(-5, 5),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(15),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => edit(
                                                    edittodo: data1s,
                                                    index: index,
                                                    tittlevalue:
                                                        data1s[index].tittle,
                                                    contentvalue:
                                                        data1s[index].content,
                                                    priorityvalue:
                                                        data1s[index].priority,
                                                    duedatevalue:
                                                        data1s[index].duedate,
                                                    reminder:
                                                        data1s[index].reminder,
                                                    id: data1s[index].id,
                                                  )));
                                    },
                                    child: Container(
                                      height: 60,
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                // Image.asset(
                                                //   "assets/icons/menu.png",
                                                //   height: 20,
                                                //   width: 20,
                                                // ),
                                                Checkbox(
                                                  value: data1s[index].check,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      setState(() {
                                                        data1s[index].check =
                                                            value!;
                                                        savedeleteitem(
                                                            data1s[index]
                                                                .tittle,
                                                            data1s[index]
                                                                .content,
                                                            data1s[index]
                                                                .priority,
                                                            data1s[index]
                                                                .duedate,
                                                            data1s[index].check,
                                                            data1s[index]
                                                                .reminder,
                                                            data1s[index].id);
                                                        setdata1();
                                                        data1s.removeAt(index);
                                                        setdata();
                                                        notificationservice
                                                            .stopNotifications(
                                                                data1s[index]
                                                                    .id);
                                                      });
                                                    });
                                                  },
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      data1s[index]
                                                                  .tittle
                                                                  .length >
                                                              20
                                                          ? data1s[index]
                                                                  .tittle
                                                                  .substring(
                                                                      0, 20) +
                                                              "..."
                                                          : data1s[index]
                                                              .tittle,
                                                      style: const TextStyle(
                                                          fontSize: 17,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black),
                                                    ),
                                                    Text(
                                                      data1s[index].duedate,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 10,
                                                          color: Color.fromARGB(
                                                              255,
                                                              207,
                                                              37,
                                                              25)),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    notificationservice
                                                        .stopNotifications(
                                                            data1s[index].id);
                                                    setState(() {
                                                      data1s.removeAt(index);
                                                      setdata();
                                                    });
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete,
                                                    size: 25,
                                                    color: Colors.black,
                                                  )),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                            );
                          } else {
                            return SizedBox(
                              height: 0,
                            );
                          }
                        },
                      ),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: 450,
                        child: ListView.builder(
                          itemCount: data1s.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (data1s[index].priority == "Birthday") {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                    decoration: BoxDecoration(
                                        boxShadow: const [
                                          BoxShadow(
                                            color:
                                                Color.fromRGBO(0, 0, 0, 0.09),
                                            blurRadius: 3,
                                            spreadRadius: 1,
                                            offset: Offset(-5, 5),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.white),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(15),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => edit(
                                                      edittodo: data1s,
                                                      index: index,
                                                      tittlevalue:
                                                          data1s[index].tittle,
                                                      contentvalue:
                                                          data1s[index].content,
                                                      priorityvalue:
                                                          data1s[index]
                                                              .priority,
                                                      duedatevalue:
                                                          data1s[index].duedate,
                                                      reminder: data1s[index]
                                                          .reminder,
                                                      id: data1s[index].id,
                                                    )));
                                      },
                                      child: Container(
                                        height: 60,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  // Image.asset(
                                                  //   "assets/icons/menu.png",
                                                  //   height: 20,
                                                  //   width: 20,
                                                  // ),
                                                  Checkbox(
                                                    value: data1s[index].check,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        setState(() {
                                                          data1s[index].check =
                                                              value!;
                                                          savedeleteitem(
                                                              data1s[index]
                                                                  .tittle,
                                                              data1s[index]
                                                                  .content,
                                                              data1s[index]
                                                                  .priority,
                                                              data1s[index]
                                                                  .duedate,
                                                              data1s[index]
                                                                  .check,
                                                              data1s[index]
                                                                  .reminder,
                                                              data1s[index].id);
                                                          setdata1();
                                                          data1s
                                                              .removeAt(index);
                                                          setdata();
                                                          notificationservice
                                                              .stopNotifications(
                                                                  data1s[index]
                                                                      .id);
                                                        });
                                                      });
                                                    },
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        data1s[index]
                                                                    .tittle
                                                                    .length >
                                                                20
                                                            ? data1s[index]
                                                                    .tittle
                                                                    .substring(
                                                                        0, 20) +
                                                                "..."
                                                            : data1s[index]
                                                                .tittle,
                                                        style: const TextStyle(
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                      Text(
                                                        data1s[index].duedate,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 10,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    207,
                                                                    37,
                                                                    25)),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      notificationservice
                                                          .stopNotifications(
                                                              data1s[index].id);
                                                      setState(() {
                                                        data1s.removeAt(index);
                                                        setdata();
                                                      });
                                                    },
                                                    icon: const Icon(
                                                      Icons.delete,
                                                      size: 25,
                                                      color: Colors.black,
                                                    )),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )),
                              );
                            } else {
                              return SizedBox(
                                height: 0,
                              );
                            }
                          },
                        )),
                  ]),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => completed(
                        maindata: data1s,
                        deletedata: deletedata,
                      ),
                    ));
              },
              child: Text(
                "Completed Tasks",
                style: TextStyle(color: Colors.black),
              ),
            ),
            Container(
              child: ListView.builder(
                itemCount: deletedata.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.09),
                              blurRadius: 3,
                              spreadRadius: 1,
                              offset: Offset(-5, 5),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(15),
                          color: const Color.fromARGB(255, 244, 242, 242)),
                      child: ListTile(
                        leading: Checkbox(
                          activeColor: Colors.white,
                          checkColor: Colors.red,
                          value: deletedata[index].check,
                          onChanged: (value) {
                            setState(() {
                              data1s.add(data(
                                  tittle: deletedata[index].tittle,
                                  content: deletedata[index].content,
                                  priority: deletedata[index].priority,
                                  duedate: deletedata[index].duedate,
                                  check: value!,
                                  id: deletedata[index].id,
                                  reminder: deletedata[index].reminder));
                              setdata();
                              deletedata.removeAt(index);
                              setdata1();
                            });
                          },
                        ),
                        trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                deletedata.removeAt(index);

                                setdata1();
                              });
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            )),
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              deletedata[index].tittle.length > 20
                                  ? deletedata[index].tittle.substring(0, 20) +
                                      "..."
                                  : deletedata[index].tittle,
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              deletedata[index].duedate,
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                  color: Color.fromARGB(255, 207, 37, 25)),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              height: 200,
            )
          ],
        ),
        floatingActionButton: Stack(
          children: [
            WaveAnimation(
              size: 60.0,
              color: Color.fromARGB(255, 172, 172, 172),
              centerChild: Stack(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle button tap
                      show1();
                    },
                    child: Text(""),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 17,
              left: 18,
              child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.black,
                  child: IconButton(
                      onPressed: () {
                        show1();
                        print(datetime.toString());
                      },
                      icon: const Icon(
                        color: Colors.white,
                        Icons.add,
                        size: 30,
                      ))),
            )
          ],
        ),
      ),
    );
  }
}

class updatetime extends StatefulWidget {
  const updatetime({
    super.key,
    this.remindertime,
  });
  final remindertime;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return updatetime1();
  }
}

class updatetime1 extends State<updatetime> {
  var formatedtime = DateFormat('HH:mm').format(DateTime.now());

  @override
  void initState() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        formatedtime = DateFormat().format(DateTime.now());
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(formatedtime);
  }
}

Future _selectTime(BuildContext context) {
  final now = DateTime.now();

  return showTimePicker(
    context: context,
    initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
  );
}

Future _selectDateTime(BuildContext context) => showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(seconds: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

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
