import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'listDownloadedFiles.dart';
import 'dowloadFilesFunctions.dart';


void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Деплом',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Деплом хоум'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  static const platformViev =
      const MethodChannel('com.objectbeam.flios/navToLogin');
  DownloadFilesFunction downloadFiles = DownloadFilesFunction();

  Future<void> _navToLogin() async {
    try {
      final int result = await platformViev.invokeMethod('goToLogin');
      print('Resul: $result');
    } on PlatformException catch (e) {
      print("Failed: '${e.message}'.");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  void _incrementCounter() {
    setState(() {});
    _navToLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                _incrementCounter();
              },
              child: Text('кнопочка!!!'),
            ),
            ElevatedButton(
              onPressed: () {
                _incrementCounter();
              },
              child: Text('еще одна кнопочка!!!'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListDownloadedFiles())
                );
              },
              child: Text('а шо там у нас скачалос?'),
            )
          ],
        ),
      ),
    );
  }
}
