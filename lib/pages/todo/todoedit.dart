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
                          TextField(
                            controller: newpop,
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
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          TextField(
                            maxLines: 5,
                            controller: newpop1,
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
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
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
                                  hint:
                                      const Text('Select your favourite fruit'),
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
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
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
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          TextField(
                            controller: newdate,
                            decoration: InputDecoration(
                                hintText: "Enter Content",
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
                                              maximumYear: DateTime.now().year,
                                              backgroundColor: Colors.white,
                                              onDateTimeChanged: (date) {
                                                setState(() {
                                                  newdate.text= date.toString();
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
                                      // DateTime? pickeddata =
                                      //     await showDatePicker(
                                      //         context: context,
                                      //         initialDate: DateTime.now(),
                                      //         firstDate: DateTime(2000),
                                      //         lastDate: DateTime(2101));
                                      // if (pickeddata != null) {
                                      //   setState(() {
                                      //     newdate.text = pickeddata.toString();
                                      //   });
                                      // }
                                    },
                                    icon: const Icon(Icons.calendar_month))),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // const Text(
                          //   "Remiinder",
                          //   style: TextStyle(
                          //       fontWeight: FontWeight.bold,
                          //       color: Colors.black),
                          // ),
                          // TextField(
                          //   controller: newpop1,
                          //   decoration: InputDecoration(
                          //       hintText: "Enter Content",
                          //       border: OutlineInputBorder(
                          //           borderRadius: BorderRadius.circular(12))),
                          // ),
                          const SizedBox(
                            height: 30,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => detail(
                                        finalindex: widget.index,
                                        finaltittle: newpop.text,
                                        finalcontent: newpop1.text,
                                        finalduedate: newdate.text,
                                        finalpriority: dropdownValue,
                                      ),
                                    ));
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
