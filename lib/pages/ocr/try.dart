import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        // Show the container with two texts
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Container(
                // Customize the container as needed
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        // sharePdf('${pdfFiles[index].filePath}',
                        //           '${pdfFiles[index].fileName}');
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.share,
                            size: 20,
                          ),
                          Text(
                            'Share',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.0),
                    InkWell(
                      onTap: () {
              //           showNotification(
              // 'PDF Conversion Successful', 'Successfully converted to PDF');
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.download,
                            size: 20,
                          ),
                          Text(
                            'Download',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Text('Open Container with Two Texts'),
    );
  }
}
