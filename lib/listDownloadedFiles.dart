import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:io' show Platform;

class ListDownloadedFiles extends StatefulWidget {
  @override
  _ListDownloadedFiles createState() => new _ListDownloadedFiles();
}

class _ListDownloadedFiles extends State<ListDownloadedFiles> {
  String directory = '';
  List file;
  int countOfSymbolInAdress = 0;
  String platform;
  @override
  void initState() {
    super.initState();
    _listOfFiles();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Files list"),
      ),
      body: Builder(builder: (context) => list()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Icon(Icons.backspace),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget list() => Container(
        child: Column(
          children: <Widget>[
            // your Content if there
            Expanded(
              child: ListView.builder(
                  itemCount: file.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Text(file[index]
                        .toString()
                        .substring(countOfSymbolInAdress));
                  }),
            )
          ],
        ),
      );

  void _detectPlatform() {
    if (Platform.isAndroid) {
      platform = "android";
    }
    if (Platform.isIOS) {
      platform = "ios";
    }
  }

  void _listOfFiles() async {
    _detectPlatform();
    directory = (await getApplicationDocumentsDirectory()).path + Platform.pathSeparator + 'Download';
    if (platform == "ios") {
      countOfSymbolInAdress = directory.length + 6;
    }
    if (platform == "android") {
      countOfSymbolInAdress = 0;
    }
    setState(() {
      file = Directory("$directory")
          .listSync(); //use your folder name insted of resume.
    });
  }
}
