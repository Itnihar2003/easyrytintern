import 'dart:convert';

import 'package:dropdownfield2/dropdownfield2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoaiapp/pages/todo/data.dart';
import 'package:todoaiapp/pages/todo/notification.dart';
import 'package:todoaiapp/pages/todo/tododetail.dart';

class edit extends StatefulWidget {
  final String tittlevalue;
  final String contentvalue;
  final int index;
  final String priorityvalue;
  final String duedatevalue;
  final List<data> edittodo;
  final String reminder;
  final int id;
  const edit({
    super.key,
    required this.tittlevalue,
    required this.contentvalue,
    required this.index,
    required this.priorityvalue,
    required this.duedatevalue,
    required this.edittodo,
    required this.reminder,
    required this.id,
  });

  @override
  State<edit> createState() => _editState();
}

class _editState extends State<edit> {
  Notificationservice notificationservice = Notificationservice();
  @override
  void initState() {
    setState(() {
      newpop.text = widget.tittlevalue;
      newpop1.text = widget.contentvalue;
      dropdownValue = widget.priorityvalue;
      newdate.text = widget.duedatevalue;
      newreminder.text = widget.reminder;
    });
    notificationservice.initialisenotification();
    // TODO: implement initState
    super.initState();
  }

  int selectedindex = -1;
  String priorityid = "";
  String? dropdownValue;
  var duetime;
  var duereminder;
  TextEditingController newpop = TextEditingController();
  TextEditingController newpop1 = TextEditingController();
  TextEditingController newdate = TextEditingController();
  TextEditingController newreminder = TextEditingController();
  // TextEditingController newpriority = TextEditingController();
  String tittle = "";
  String content = "";
  String category = "";
  String duedate = "";
  setdata() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> data1List =
        widget.edittodo.map((data) => jsonEncode(data.toJson())).toList();
    pref.setStringList('myData', data1List);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                size: 30,
                color: Colors.black,
              )),
          title: Text(
            "Created Task",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: Container(
                  child: AlertDialog(
                insetPadding: const EdgeInsets.all(10),
                surfaceTintColor: Colors.transparent,
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
                          child: TextFormField(
                            // initialValue: widget.tittlevalue,
                            // onChanged: (value) {
                            //   setState(() {
                            //     if (value != "") {
                            //       tittle = value;
                            //     } else {
                            //       tittle = widget.tittlevalue;
                            //     }
                            //   });
                            // },

                            controller: newpop,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: Colors.white)),
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
                          child: TextFormField(
                            maxLines: 3,
                            // initialValue: widget.contentvalue,
                            // onChanged: (value) {
                            //   setState(() {
                            //     if (value != "") {
                            //       content = value;
                            //     } else {
                            //       content = widget.contentvalue;
                            //     }
                            //   });
                            // },
                            controller: newpop1,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: Colors.white)),
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
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: Colors.white)),
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
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white),
                          child: TextFormField(
                            controller: newdate,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                        BorderSide(color: Colors.white)),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.all(15.0),
                                hintText: "Enter Date",
                                hintStyle: TextStyle(
                                  fontSize: 14,
                                ),
                                prefixIcon: Icon(Icons.calendar_month_outlined),
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
                                                    backgroundColor:
                                                        Colors.white,
                                                    onDateTimeChanged: (date) {
                                                      setState(() {
                                                        newdate
                                                            .text = DateFormat(
                                                                "dd-MM-yyyy (hh:mm a )")
                                                            .format(date);
                                                      });
                                                      duetime = date;
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
                              child: TextFormField(
                                controller: newreminder,
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide:
                                            BorderSide(color: Colors.white)),
                                    filled: true,
                                    fillColor: Colors.white,
                                    prefixIcon:
                                        Icon(Icons.calendar_month_outlined),
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
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                      child:
                                                          CupertinoDatePicker(
                                                        minimumDate:
                                                            DateTime.now(),
                                                        maximumYear:
                                                            DateTime.now().year,
                                                        backgroundColor:
                                                            Colors.white,
                                                        onDateTimeChanged:
                                                            (date2) {
                                                          setState(() {
                                                            newreminder
                                                                .text = DateFormat(
                                                                    "dd-MM-yyyy (hh:mm a )")
                                                                .format(date2);
                                                          });
                                                          duereminder = date2;
                                                          debugPrint(
                                                              'notification scheduked fir $duereminder');
                                                          notificationservice
                                                              .scheduleNotification(
                                                                  title:
                                                                      'complete your task',
                                                                  body:
                                                                      newreminder
                                                                          .text,
                                                                  scheduledNotificationDateTime:
                                                                      date2.subtract(Duration(minutes: 5)),
                                                                  id: widget
                                                                      .id);
                                                        },
                                                      ),
                                                    ),
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Container(
                                                          width: 300,
                                                          color: Colors.white,
                                                          child: Center(
                                                              child: Text(
                                                            "OK",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
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
                        Center(
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => detail(
                                      finalindex: widget.index,
                                      finaltittle: newpop.text,
                                      finalcontent: newpop1.text,
                                      finalduedate: newdate.text,
                                      finalpriority: dropdownValue,
                                      reminder: newreminder.text,
                                    ),
                                  ),
                                );
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
              )),
            ),
          ],
        ));
  }
}
