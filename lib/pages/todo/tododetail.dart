import 'dart:async';
import 'dart:convert';

import 'package:dropdownfield2/dropdownfield2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoaiapp/pages/todo/data.dart';
import 'package:todoaiapp/pages/todo/notification.dart';

import 'package:todoaiapp/pages/todo/todoedit.dart';

var remindertime1 = "";

class detail extends StatefulWidget {
  final finalcontent;
  final finaltittle;
  final finalindex;
  final finalpriority;
  final finalduedate;
  const detail(
      {super.key,
      this.finalindex,
      this.finalcontent,
      this.finaltittle,
      this.finalpriority,
      this.finalduedate});

  @override
  State<detail> createState() => _detailState();
}

class _detailState extends State<detail> {
  var scheduleTime;
  var duetime;
  Notificationservice notificationservice = Notificationservice();
  @override
  void initState() {
    update();
    super.initState();
    notificationservice.initialisenotification();
  }

  TextEditingController pop = TextEditingController();
  TextEditingController pop1 = TextEditingController();
  TextEditingController date1 = TextEditingController();
  TextEditingController datetimecontroler = TextEditingController();
  TextEditingController priority = TextEditingController();
  List<data> data1s = [];
  int selectedindex = -1;

  setdata() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> data1List =
        data1s.map((data) => jsonEncode(data.toJson())).toList();
    pref.setStringList('myData', data1List);
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

  update() async {
    List<data> sdata = await getdata();
    setState(() {
      data1s = sdata;
    });
  }

  save() {
    if (pop.text != "" &&
        pop1.text != "" &&
        priority.text != "" &&
        date1.text != "") {
      setState(() {
        data1s.add(data(
          tittle: pop.text.trim(),
          content: pop1.text.trim(),
          priority: priority.text.trim(),
          duedate: date1.text.trim(),
          check: check,
        ));
      });
      setdata();
    } else {
      Get.snackbar("Error", "Plese fill all data",
          backgroundColor: Colors.grey);
    }
  }

  String priorityid = "";
  List<String> country = [
    "Priority 1",
    "Priority 2",
    "Priority 3",
    "Priority 4"
  ];
  bool check = false;
  String finaldate = "";
  String b = "";
  String finaltime = "";
  show() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            insetPadding: const EdgeInsets.all(10),
            backgroundColor: Colors.white,
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
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
                    TextField(
                      controller: pop,
                      decoration: InputDecoration(
                          hintText: "What whould you like to do?",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12))),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Description",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    TextField(
                      maxLines: 5,
                      controller: pop1,
                      decoration: InputDecoration(
                          hintText: "Description",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12))),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Priority",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          DropDownField(
                            controller: priority,
                            onValueChanged: (dynamic value) {
                              priorityid = value;
                            },
                            value: priorityid,
                            required: false,
                            hintText: 'Choose a priority',
                            items: country,
                          ),
                        ]),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "DueDate",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    TextField(
                      controller: date1,
                      decoration: InputDecoration(
                          hintText: "Enter Date",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          suffixIcon: IconButton(
                              onPressed: () async {
                                showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) {
                                    return SizedBox(
                                      height: 100,
                                      width: 300,
                                      child: CupertinoDatePicker(
                                        backgroundColor: Colors.white,
                                        onDateTimeChanged: (date) {
                                          setState(() {
                                            date1.text = date.toString();
                                          });
                                          duetime = date;
                                          debugPrint(
                                              'notification scheduked fir $scheduleTime');

                                          // notificationservice
                                          //     .scheduleNotification(
                                          //         title:
                                          //             'complete your task',
                                          //         body: '$scheduleTime',
                                          //         scheduledNotificationDateTime:
                                          //             scheduleTime);
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                              icon: const Icon(Icons.calendar_month))),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Reminder",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Column(
                      children: [
                        TextField(
                          controller: datetimecontroler,
                          decoration: InputDecoration(
                              hintText: "Enter Date",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              suffixIcon: IconButton(
                                  onPressed: () async {
                                    showCupertinoModalPopup(
                                      context: context,
                                      builder: (context) {
                                        return SizedBox(
                                          height: 100,
                                          width: 300,
                                          child: CupertinoDatePicker(
                                            backgroundColor: Colors.white,
                                            onDateTimeChanged: (date) {
                                              setState(() {
                                                datetimecontroler.text =
                                                    date.toString();
                                              });
                                              scheduleTime = date;
                                              debugPrint(
                                                  'notification scheduked fir $scheduleTime');

                                              notificationservice
                                                  .scheduleNotification(
                                                      title:
                                                          'complete your task',
                                                      body: '$scheduleTime',
                                                      scheduledNotificationDateTime:
                                                          scheduleTime);
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.calendar_month))),
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  notificationservice.scheduleminute(
                                      "hello", "hii", duetime);
                                },
                                child: const Text("everyminite"))
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          for (int i = 0; i <= 16; i++) {
                            val = val + datetime.toString()[i];
                          }
                          save();
                          remindertime1 = finaltime;

                          print(remindertime1);
                          Navigator.pop(context);
                          pop.clear();
                          pop1.clear();
                          priority.clear();
                          date1.clear();
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
                        ))
                  ],
                ),
              ),
            ),
            title: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Colors.black,
                    )),
                const Text(
                  "Create Task",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                )
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: IconButton(
                onPressed: () {
                  setState(() {
                    selectedindex = widget.finalindex;
                    data1s[selectedindex].tittle = widget.finaltittle;
                    data1s[selectedindex].content = widget.finalcontent;
                    data1s[selectedindex].priority = widget.finalpriority;
                    data1s[selectedindex].duedate = widget.finalduedate;
                  });
                  setdata();
                },
                icon: const Column(
                  children: [
                    Icon(
                      Icons.refresh,
                      color: Colors.black,
                      size: 20,
                    ),
                    Text(
                      "Upload",
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                )),
          )
        ],
        title: const Text(
          "Tittle",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
              child: Container(
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
                          color: const Color.fromARGB(255, 244, 242, 242)),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => edit(
                                        index: index,
                                        tittlevalue: data1s[index].tittle,
                                        contentvalue: data1s[index].content,
                                        priorityvalue: data1s[index].priority,
                                        duedatevalue: data1s[index].duedate,
                                      )));
                        },
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              tileColor: Colors.white,
                              leading: Image.asset(
                                "assets/icons/menu.png",
                                height: 20,
                                width: 20,
                              ),
                              trailing: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      data1s.removeAt(index);
                                      setdata();
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    size: 30,
                                    color: Colors.black,
                                  )),
                              subtitle: Row(
                                children: [
                                  updatetime(
                                    remindertime: data1s[index],
                                  ),
                                ],
                              ),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    value: data1s[index].check,
                                    onChanged: (value) {
                                      setState(() {
                                        data1s[index].check = value!;
                                      });
                                      setdata();
                                    },
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        data1s[index].tittle,
                                        style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                      )),
                );
              },
            ),
          )),
        ],
      ),
      floatingActionButton: CircleAvatar(
          radius: 30,
          backgroundColor: const Color.fromARGB(255, 211, 211, 211),
          child: IconButton(
              onPressed: () {
                show();
                print(datetime.toString());
              },
              icon: const Icon(
                Icons.add,
                size: 30,
              ))),
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
