import 'package:flutter/material.dart';
import 'package:todoaiapp/pages/home/concent.dart';

class initializescreen extends StatefulWidget {
  final Widget targetwidget;
  const initializescreen({super.key, required this.targetwidget});

  @override
  State<initializescreen> createState() => _initializescreenState();
}

class _initializescreenState extends State<initializescreen> {
  @override
  void initState() {
    _initialize();
    // TODO: implement initState
    super.initState();
  }

  final _initializationhelper = Initializationhelper();
  Future<void> _initialize() async {
    final navigator = Navigator.of(context);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await _initializationhelper.initialize();
      navigator.pushReplacement(MaterialPageRoute(
        builder: (context) => widget.targetwidget,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
