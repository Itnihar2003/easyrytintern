import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todoaiapp/pages/homepage.dart';

class ResultScreen extends StatelessWidget {
  final String text;

  const ResultScreen({super.key, required this.text});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Result'),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(child: Container(child: Text(text))),
        ),
        floatingActionButton: TextButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => home(datas: const []),
                  ));
              FlutterClipboard.copy(text);
              Get.snackbar("copied", "");
              Navigator.pop(context);
            },
            child: const Icon(Icons.copy)),
      );
}
