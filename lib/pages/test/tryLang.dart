import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String selectedLangCode = ''; // Store the selected language code

  // List of languages with their codes
  List<Map<String, String>> languages = [
    {'Lang Code': 'afr', 'Language': 'Afrikaans'},
    {'Lang Code': 'amh', 'Language': 'Amharic'},
    {'Lang Code': 'ara', 'Language': 'Arabic'},
    // Add the remaining languages here
  ];

  List<Map<String, String>> filteredLanguages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language Selection'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Show language selection dialog
            _showLanguageSelectionDialog();
          },
          child: Text('Select Language'),
        ),
      ),
    );
  }

  Future<void> _showLanguageSelectionDialog() async {
    filteredLanguages = List.from(languages);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Select Language'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 90,
                      // width: 200,
                      child: TextField(
                        onChanged: (value) {
                          // Filter languages based on user input
                          setState(() {
                            filteredLanguages = languages
                                .where((language) =>
                                    language['Language']!
                                        .toLowerCase()
                                        .contains(value.toLowerCase()) ||
                                    language['Lang Code']!
                                        .toLowerCase()
                                        .contains(value.toLowerCase()))
                                .toList();
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Search Language',
                          hintText: 'Enter language name or code',
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Container(
                      // height: 300,
                      color: Colors.blue,
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.height * 0.62,
                      child: ListView.builder(
                        itemCount: filteredLanguages.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              // Set the selected language code and close the dialog
                              setState(() {
                                selectedLangCode =
                                    filteredLanguages[index]['Lang Code']!;
                              });
                              Navigator.pop(context);
                            },
                            title: Text(
                              '${filteredLanguages[index]['Language']} (${filteredLanguages[index]['Lang Code']})',
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
