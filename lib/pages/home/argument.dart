import 'package:flutter/material.dart';

class argument extends StatelessWidget {
  const argument({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_sharp)),
        title: Text(
          "User Agreement",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                  'NotaAI - Notes, AI Chat, OCR: Terms of Use\n\nWelcome to NotaAI - Notes, AI Chat, OCR (referred to as "App"). These Terms of Use ("Terms") outline the conditions and rules for using the App, provided by Easyryt.com . ("NotaAI," "we," "us," or "our"). Please carefully read and understand these Terms, as they govern your use of the App. By downloading, installing, or using the App, you agree to be bound by these Terms.\n\n1. Acceptance of Terms\nYou must fully accept these Terms before using the NotaAI App. If you disagree with any part of these Terms, do not download, install, or use the App. Your use of the App implies your understanding and agreement with these Terms and the [Privacy Policy]\n\n2. Eligibility\nYou may use the App only if you can form a binding contract with NotaAI and comply with local, national, and international laws. The App is not available to users previously removed by NotaAI. Ensure your device meets minimum specifications and that you have the right to use the App on it.\n\n3. NotaAI App License\nSubject to strict compliance with these Terms, NotaAI grants you a limited, non-exclusive, non-transferable, personal, revocable license for non-commercial, personal entertainment use. Any materials downloaded or used through the App are for personal entertainment and may not be used for commercial purposes without NotaAIs express written consent.\n\n4. Usage Rules\nYou agree not to engage in prohibited activities, including copying, distributing, or modifying the App. Prohibited activities also include using automated systems to access the App excessively, transmitting spam, interfering with system integrity, or violating any laws. The App may contain links to Third Party Content; NotaAI is not responsible for such content.\n\n5. User Code of Conduct\nYou are responsible for your use of the App and agree not to engage in dangerous, fraudulent, or illegal activities. Prohibited actions include hate speech, creating offensive content, and using the App to violate laws or infringe on others rights.\n\n6. Our Proprietary Rights\nThe App contains material owned or licensed by NotaAI ("NotaAI IP"). You may not remove, alter, or exploit NotaAI IP. Your submission of comments or ideas is gratuitous and may be used by NotaAI without additional compensation.\n\n7. Disclaimer and Limitations of Liability\nThe App is provided "as is." NotaAI disclaims any warranties and limits its liability. You use the App at your own risk, and NotaAI is not responsible for illegal or unauthorized use of information transmitted through the App.\n\n 8. Access and Termination\nNotaAI reserves the right to modify, suspend, or discontinue the App without notice. Access to the App may be terminated at any time without notice. You are responsible for maintaining telecommunications and hardware needed for App access.\n\n9. Indemnification\nYou agree to indemnify NotaAI for claims arising from your breach of these Terms. We reserve the right to assume the exclusive defense of any claim.\n\n10. Copyright and Other IP Violations\nIf you believe your copyrighted work is infringed upon, notify us. You warrant that content uploaded on the App does not infringe third-party rights.\n\n 11. Privacy & Security\nYour privacy is important. By using the App, you agree to our privacy policy. The App uses third-party services; their privacy policies apply.\n\n 12. Advertisement Policy\nWe comply with industry self-regulatory guidance for advertisers. Third-party ads must comply with industry standards.\n\n13. Terms of Use for Minors\nIndividuals below the minimum required age must use the App through a parent or legal guardianaccount. NotaAI complies with the Child Online Privacy Protection Act.\n\nBy using NotaAI, you agree to these Terms. If you have questions or concerns, contact us at Easyryt.com (mailto:info@Easyryt.com).\n\n*Last updated: Monday, 29 January 2024*'),
            ),
          ),
        ),
      ),
    );
    ;
  }
}
