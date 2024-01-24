import 'dart:async';
import 'dart:convert';

import 'package:dropdownfield2/dropdownfield2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoaiapp/pages/home/homepage.dart';
import 'package:todoaiapp/pages/todo/data.dart';
import 'package:todoaiapp/pages/todo/deletedata.dart';
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
    update1();
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
  List<data4> deletedata = [];
  int selectedindex = -1;

  setdata() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> data1List =
        data1s.map((data) => jsonEncode(data.toJson())).toList();
    pref.setStringList('myData', data1List);
  }

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

  update1() async {
    List<data4> delete = await getdata1();
    setState(() {
      deletedata = delete;
    });
  }

  savedeleteitem(String data) {
    setState(() {
      deletedata.add(data4(tittle: data));
    });

    setdata1();
  }

  save() {
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
        ));
      });
      setdata();
    } else {
      Get.snackbar("Error", "Plese fill all data",
          backgroundColor: Colors.grey);
    }
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
  show() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            insetPadding: const EdgeInsets.all(7),
            surfaceTintColor: Colors.transparent,
            content: SizedBox(
              height: MediaQuery.of(context).size.height,
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
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.priority_high),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            hint: const Text('Choose a Priority'),
                            value: dropdownValue,
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue = newValue!;
                              });
                            },
                            items: <String>[
                              "Priority 1",
                              "Priority 2",
                              "Priority 3",
                              "Priority 4"
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          )
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
                                                  date1.text = date.toString();
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
                                                      datetimecontroler.text =
                                                          date.toString();
                                                    });
                                                    scheduleTime = date;
                                                    debugPrint(
                                                        'notification scheduked fir $scheduleTime');
                                                    notificationservice.scheduleNotification(
                                                        title:
                                                            'complete your task',
                                                        body: '$scheduleTime',
                                                        scheduledNotificationDateTime:
                                                            scheduleTime,
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
                                  icon: const Icon(Icons.calendar_month))),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: ElevatedButton(
                          onPressed: () {
                            finalid++;
                            for (int i = 0; i <= 16; i++) {
                              val = val + datetime.toString()[i];
                            }
                            save();
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
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    value: data1s[index].check,
                                    onChanged: (value) {
                                      setState(() {
                                        data1s[index].check = value!;
                                        savedeleteitem(data1s[index].tittle);
                                      });
                                      data1s.removeAt(index);
                                      setdata1();
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
          Text("Completed Tasks"),
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
                      leading: Icon(
                        Icons.add_task_rounded,
                        color: Colors.green,
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              deletedata.removeAt(index);
                              setdata1();
                            });
                          },
                          icon: Icon(Icons.delete)),
                      title: Text(
                        deletedata[index].tittle,
                        style: TextStyle(color: Colors.grey),
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
      floatingActionButton: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.black,
          child: IconButton(
              onPressed: () {
                show();
                print(datetime.toString());
              },
              icon: const Icon(
                color: Colors.white,
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
