import 'package:flutter/material.dart';
import 'package:todoaiapp/pages/home/concent.dart';

class initializescreen extends StatefulWidget {
  final Widget targetwidget;
  const initializescreen({super.key, required this.targetwidget});

  @override
  State<initializescreen> createState() => _initializescreenState();
}

class _initializescreenState extends State<initializescreen> {
  final _initializationhelper = Initializationhelper();
  @override
  void initState() {
    _initialize();
    // TODO: implement initState
    super.initState();
  }

  
  Future<void> _initialize() async {
    final navigator = Navigator.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
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
        child: CircularProgressIndicator(color: Colors.black,),
      ),
    );
  }
}
