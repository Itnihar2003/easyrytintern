import 'package:dropdownfield2/dropdownfield2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoaiapp/pages/todo/tododetail.dart';

class edit extends StatefulWidget {
  final String tittlevalue;
  final String contentvalue;
  final int index;
  final String priorityvalue;
  final String duedatevalue;

  const edit({
    super.key,
    required this.tittlevalue,
    required this.contentvalue,
    required this.index,
    required this.priorityvalue,
    required this.duedatevalue,
  });

  @override
  State<edit> createState() => _editState();
}

class _editState extends State<edit> {
  @override
  void initState() {
    setState(() {
      newpop.text = widget.tittlevalue;
      newpop1.text = widget.contentvalue;
      dropdownValue = widget.priorityvalue;
      newdate.text = widget.duedatevalue;
    });
    // TODO: implement initState
    super.initState();
  }

  int selectedindex = -1;
  String priorityid = "";
  String? dropdownValue;
  var duetime;
  TextEditingController newpop = TextEditingController();
  TextEditingController newpop1 = TextEditingController();
  TextEditingController newdate = TextEditingController();
  // TextEditingController newpriority = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
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
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
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
                            "Priority",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
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
                                  hintText: "Priority",
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                  )),
                              value: dropdownValue,
                              items: [
                                DropdownMenuItem(
                                  value: 'Option 1',
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.bookmark,
                                        color: Colors
                                            .red, // Set color for Option 1
                                      ),
                                      SizedBox(width: 10),
                                      Text('Option 1'),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'Option 2',
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.bookmark,
                                        color: Colors
                                            .yellow, // Set color for Option 2
                                      ),
                                      SizedBox(width: 10),
                                      Text('Option 2'),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'Option 3',
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.bookmark,
                                        color: Colors
                                            .blue, // Set color for Option 3
                                      ),
                                      SizedBox(width: 10),
                                      Text('Option 3'),
                                    ],
                                  ),
                                ),
                                DropdownMenuItem(
                                  value: 'Option 4',
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.bookmark_border,
                                        // Set color for Option 3
                                      ),
                                      SizedBox(width: 10),
                                      Text('Option 4'),
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
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
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
                                  hintText: "Description",
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                  ),
                                  prefixIcon:
                                      Icon(Icons.calendar_month_outlined),
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
                                                                .circular(20)),
                                                    child: CupertinoDatePicker(
                                                      minimumDate:
                                                          DateTime.now(),
                                                      maximumYear:
                                                          DateTime.now().year,
                                                      backgroundColor:
                                                          Colors.white,
                                                      onDateTimeChanged:
                                                          (date) {
                                                        setState(() {
                                                          newdate.text =
                                                              date.toString();
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
                                                              color:
                                                                  Colors.black,
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
                        "Created Task",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      )
                    ],
                  ))),
        ),
      ],
    ));
  }
}
