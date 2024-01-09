import 'package:flutter/material.dart';

class TermCond extends StatelessWidget {
  const TermCond({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
      ),
      body: const Column(
        children: [
          Text(
              "By using EasyRyt OCR, you agree to the following terms and conditions:\n "),
          Text(
              "Usage Restrictions: EasyRyt OCR is intended for personal use only. Any commercial use or distribution without permission is prohibited.\n"),
          Text(
              "Intellectual Property: The app and its content are protected by copyright and other intellectual property laws. Users may not reproduce, distribute, or create derivative works without permission.\n"),
          Text(
              " No Warranty: EasyRyt OCR is provided \"as is \" without any warranty of any kind, express or implied. The app may not be error-free, and the developers are not responsible for any data loss or damage.\n "),
          Text(
              "Limitation of Liability: In no event shall EasyRyt OCR or its developers be liable for any direct, indirect, incidental, special, or consequential damages arising out of or in any way connected with the use of the app. \n"),
          Text(
              "Applicability of Laws: Users are responsible for complying with local laws and regulations regarding the use of OCR technology and data processing.\n"),
        ],
      ),
    );
  }
}
