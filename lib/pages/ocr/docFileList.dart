import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:open_file_plus/open_file_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:todoaiapp/main.dart';
import 'package:todoaiapp/pages/ocr/iconFileList.dart';
// import 'package:open_file/open_file.dart';

class DocList extends StatefulWidget {
  @override
  _DocListState createState() => _DocListState();
}

class _DocListState extends State<DocList> {
  List<FileData> filesData = [];

  @override
  void initState() {
    updateFileList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/home/0 5.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              title: Center(child: Text('List of DOC Files')),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Expanded(
              child: (filesData.isNotEmpty)
                  ? ListView.builder(
                      itemCount:
                          filesData.where((file) => file.isDoc).toList().length,
                      itemBuilder: (context, index) {
                        var docFiles =
                            filesData.where((file) => file.isDoc).toList();
                        return ListTile(
                          leading: Image.asset(
                            'assets/home/doc.png',
                            height: 25,
                          ),
                          title: InkWell(
                            onTap: () {
                              print("path :: ${docFiles[index].filePath}");
                              openFile(docFiles[index].filePath);
                            },
                            child: Text(
                              docFiles[index].fileName,
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ),
                          trailing: Container(
                            // color: Colors.red,
                            width: 50,
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    showNotification(
                                        'DOC Conversion Successful',
                                        'Successfully converted to DOC',
                                        docFiles[index].filePath);
                                  },
                                  child: Icon(
                                    Icons.download,
                                    size: 20,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                  onTap: () {
                                    shareDoc('${docFiles[index].filePath}',
                                        '${docFiles[index].fileName}');
                                  },
                                  child: Icon(
                                    Icons.share,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      child: Center(
                        child: Text(
                          "No DOC Files Found",
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void showNotification(String title, String body, String filepath) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id', // Change this to a unique ID for your app
      'Your Channel Name',
      // 'Your Channel Description',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    print(filepath);
    await flutterLocalNotificationsPlugin.show(
      0, // Change this to a unique notification ID
      title,
      body,
      platformChannelSpecifics,
      // payload: 'filepath',
      payload: 'item x',
    );
  }

  Future<void> shareDoc(String pdfPath, String pdfFileName) async {
    try {
      final Uint8List bytes = await File(pdfPath).readAsBytes();

      final tempDir = await getTemporaryDirectory();
      final tempFilePath = '${tempDir.path}/$pdfFileName';

      await File(tempFilePath).writeAsBytes(bytes);

      await Share.shareFiles(
        [tempFilePath],
        text: 'Sharing $pdfFileName',
        subject: 'PDF Share',
        mimeTypes: ['application/pdf'],
      );
    } catch (error) {
      print('Error sharing PDF file: $error');
    }
  }

  Future<void> updateFileList() async {
    try {
      // Directory? directory = await getExternalStorageDirectory();
      // if (directory != null) {
      Directory directory = Directory('/storage/emulated/0/Download');
      print("dir :: $directory");
      if (await directory.exists()) {
        List<FileSystemEntity> fileEntities = directory.listSync();
        List<FileData> allFilesData = fileEntities
            .where((entity) =>
                entity.path.endsWith('.pdf') ||
                entity.path.endsWith('.docx') ||
                entity.path.endsWith('.txt'))
            .map((entity) => FileData(
                  fileName: entity.uri.pathSegments.last,
                  filePath: entity.path,
                  isPdf: entity.path.endsWith('.pdf'),
                  isDoc: entity.path.endsWith('.docx'),
                  istxt: entity.path.endsWith('.txt'),
                ))
            .toList();

        // Sort files by modification time in descending order
        allFilesData.sort((a, b) => File(b.filePath)
            .lastModifiedSync()
            .compareTo(File(a.filePath).lastModifiedSync()));

        setState(() {
          filesData = allFilesData;
        });
      }
    } catch (error) {
      print('Error updating file list: $error');
    }
  }

  Future<void> openFile(String filePath) async {
    try {
      print('Opening file at path: $filePath');
      await OpenFile.open(filePath);
      print('Opened');
    } catch (error) {
      print('Error opening file: $error');
    }

    // try {
    //   print(filePath);
    //   final file = File(filePath);
    //   if (await file.exists()) {
    //     print('Opening file at path: $filePath');
    //     await OpenFile.open(filePath);
    //   } else {
    //     print('File does not exist: $filePath');
    //   }
    // } catch (error) {
    //   print('Error opening file: $error');
    // }
  }
}
// class FileData {
//   final String fileName;
//   final String filePath;
//   final bool isPdf;
//   final bool isDoc;
//   final bool istxt;

//   FileData(
//       {required this.fileName,
//       required this.filePath,
//       required this.isPdf,
//       required this.isDoc,
//       required this.istxt});
// }
