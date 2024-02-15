import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoaiapp/pages/todo/data.dart';
import 'package:todoaiapp/pages/todo/deletedata.dart';
import 'package:todoaiapp/pages/todo/tododetail.dart';

class completed extends StatefulWidget {
  final List<data> maindata;
  final List<data4> deletedata;
  const completed(
      {super.key, required this.maindata, required this.deletedata});

  @override
  State<completed> createState() => _completedState();
}

class _completedState extends State<completed> {
  setdata() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> data1List =
        widget.maindata.map((data) => jsonEncode(data.toJson())).toList();
    pref.setStringList('myData', data1List);
  }

  setdata1() async {
    SharedPreferences pref1 = await SharedPreferences.getInstance();
    List<String> deleteList =
        widget.deletedata.map((data4) => jsonEncode(data4.toJson())).toList();
    pref1.setStringList('myData1', deleteList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => detail(),
                  ));
            },
            icon: Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.black,
            )),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  "Complete Task",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.deletedata.length,
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
                        color: Colors.white),
                    child: ListTile(
                      leading: Checkbox(
                        activeColor: Colors.white,
                        checkColor: Colors.red,
                        value: widget.deletedata[index].check,
                        onChanged: (value) {
                          setState(() {
                            widget.maindata.add(data(
                                tittle: widget.deletedata[index].tittle,
                                content: widget.deletedata[index].content,
                                priority: widget.deletedata[index].priority,
                                duedate: widget.deletedata[index].duedate,
                                check: value!,
                                id: widget.deletedata[index].id,
                                reminder: widget.deletedata[index].reminder));
                            widget.deletedata.removeAt(index);
                            setdata();
                            setdata1();
                          });
                        },
                      ),
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.deletedata[index].tittle.length > 20
                                ? widget.deletedata[index].tittle
                                        .substring(0, 20) +
                                    "..."
                                : widget.deletedata[index].tittle,
                            style: TextStyle(color: Colors.grey),
                          ),
                          Text(
                            widget.deletedata[index].duedate,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                                color: Color.fromARGB(255, 207, 37, 25)),
                          )
                        ],
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              widget.deletedata.removeAt(index);
                              setdata1();
                            });
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
