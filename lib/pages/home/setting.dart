import 'package:flutter/material.dart';
import 'package:todoaiapp/pages/home/argument.dart';
import 'package:todoaiapp/pages/home/helpfeedback.dart';
import 'package:todoaiapp/pages/home/privacy.dart';

class setting extends StatefulWidget {
  const setting({super.key});

  @override
  State<setting> createState() => _settingState();
}

class _settingState extends State<setting> {
  bool isswitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 236, 236),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_sharp)),
        centerTitle: true,
        title: Text(
          "Setting",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                child: Image.asset(
                  "assets/pri.png",
                  fit: BoxFit.fitWidth,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                height: 200,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                width: MediaQuery.of(context).size.width,
                height: 220,
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => feedback(),
                            ));
                      },
                      child: ListTile(
                        trailing: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => feedback(),
                                  ));
                            },
                            icon: Icon(Icons.arrow_forward_ios)),
                        leading: Text(
                          "Help and Feedback",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => privacy(),
                            ));
                      },
                      child: ListTile(
                        trailing: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => privacy(),
                                  ));
                            },
                            icon: Icon(Icons.arrow_forward_ios)),
                        leading: Text(
                          "Privacy Policy",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => argument(),
                              ));
                        },
                        child: ListTile(
                          trailing: IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => argument(),
                                    ));
                              },
                              icon: Icon(Icons.arrow_forward_ios)),
                          leading: Text("User Agreement",
                              style: TextStyle(fontSize: 15)),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
