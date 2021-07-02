import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'colorTheme.dart';
import 'listDownloadedFiles.dart';
//import 'downloadPage.dart';
import 'DeepLinlk/page.dart';
import 'download.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: false);
  //runApp(MyApp());
  runApp(PocApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Деплом',
      theme: layoutTheme,
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

  void _removeAllTasks() async {
    final tasks = await FlutterDownloader.loadTasks();
    tasks.forEach((e) => FlutterDownloader.remove(taskId: e.taskId, shouldDeleteContent:true));
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
              style: dnsButtonStyle,
              onPressed: () {
                _incrementCounter();
              },
              child: Text('ЕБАНУТЬ МОДЕЛЬ!!!'),
            ),
            ElevatedButton(
              style: dnsButtonStyle,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DownloadPage())
                );
              },
              child: Text('СКАЧАТ МОДЕЛ!!!'),
            ),
            ElevatedButton(
              style: dnsButtonStyle,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListDownloadedFiles())
                );
              },
              child: Text('а шо там у нас скачалос?'),
            ),
            ElevatedButton(
              style: dnsButtonStyle,
              onPressed: () {
                _removeAllTasks();
              },
              child: Text('Удалить все нахуй'),
            )
          ],
        ),
      ),
    );
  }
}
