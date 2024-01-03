import 'package:avatar_glow/avatar_glow.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  TextEditingController controller = TextEditingController();

  int selectedindex = -1;

  TextEditingController controler = TextEditingController();

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "";
  double _confidence = 1.0;
  String finaltext = "";
  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("speech to text converter"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        duration: const Duration(milliseconds: 4000),
        repeat: true,
        child: GestureDetector(
          onTapDown: (details) async {
            if (!_isListening) {
              bool available = await _speech.initialize(
                onStatus: (val) => print('onStatus: $val'),
                onError: (val) => print('onError: $val'),
              );
              if (available) {
                setState(() {
                  finaltext = finaltext + " " + _text;
                  controler.text = finaltext;
                });
                setState(() => _isListening = true);
                _speech.listen(onResult: (val) {
                  setState(() {
                    _text = val.recognizedWords;
                    if (val.hasConfidenceRating && val.confidence > 0) {
                      _confidence = val.confidence;
                    }
                  });
                });
              }
            }
          },
          onTapUp: (details) {
            setState(() {
              _text = "";
            });
            setState(() => _isListening = false);
            _speech.stop();
          },
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.black,
            child: Icon(
              Icons.mic,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Container(
              height: 600,
              decoration: BoxDecoration(border: Border.all()),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      maxLength: 1000,
                      maxLines: 30,
                      decoration: InputDecoration(
                          hintText: 'Press the button and start speaking',
                          border: OutlineInputBorder()),
                      controller: controler,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "press mic and speak and again press to send text",
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Text(_text),
                  ),
                  Container(
                    child: Center(
                      child: Text(
                        'Confidence: ${(_confidence * 100.0).toStringAsFixed(1)}%',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        FlutterClipboard.copy(controler.text);
                      },
                      child: Text("copy"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
