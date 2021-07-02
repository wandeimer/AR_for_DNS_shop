import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

class Download extends StatefulWidget {
  final String title;
  final String platform;
  final String modelLink;
  @override
  Download({Key key, this.title, this.platform, this.modelLink})
      : super(key: key);
  _DownloadState createState() => new _DownloadState();
}

class _DownloadState extends State<Download> {
  bool _isBusy = false;
  String _localPath;
  String _link;
  int _progress = 0;
  ReceivePort _port = ReceivePort();
  static const platformViev =
      const MethodChannel('com.objectbeam.flios/navToLogin');

  @override
  void initState() {
    super.initState();
    _isBusy = true;
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState(() {
        _progress = progress;
      });
    });
    FlutterDownloader.registerCallback(downloadCallback);
    _prepareSaveDir();
    _isBusy = false;
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  Future<void> _navToLogin() async {
    try {
      final int result = await platformViev.invokeMethod('goToLogin');
      print('Resul: $result');
    } on PlatformException catch (e) {
      print("Failed: '${e.message}'.");
    }
  }

  void _incrementCounter() {
    setState(() {});
    _navToLogin();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isBusy) {
      _initialize();
    }
    if (_progress == 100) {
      _incrementCounter();
    }
    return Center(
        child: SizedBox(
          child: CircularProgressIndicator(
            value: _progress / 100,
      ),
      height: 200.0,
      width: 200.0,
    ));
  }

  Future<void> _initialize() async {
    _isBusy = true;
    if (widget.modelLink != null) {
      if (Platform.isAndroid) {
        _link = "http://wandeimer.beget.tech/" + widget.modelLink + ".fbx";
      }
      if (Platform.isIOS) {
        _link = "http://wandeimer.beget.tech/" + widget.modelLink + ".usdz";
      }
    }

    if (await _isTaskNew(_link)) {
      final tasks = await FlutterDownloader.loadTasks();
      final taskId = await FlutterDownloader.enqueue(
        url: _link,
        savedDir: _localPath,
      );
    }
    FlutterDownloader.registerCallback(downloadCallback);
    _isBusy = false;
  }

  Future<bool> _isTaskNew(String link) async {
    final tasks = await FlutterDownloader.loadTasks();
    tasks.forEach((element) {
      if (link == element.url) {
        return false;
      }
    });
    for (DownloadTask element in tasks) {
      if (link == element.url) {
        return false;
      }
    }
    return true;
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String> _findLocalPath() async {
    var _directory;
    if (Platform.isAndroid) {
      _directory = await getExternalStorageDirectory();
    } else if (Platform.isIOS) {
      _directory = await getApplicationDocumentsDirectory();
    }
    return _directory.path;
  }
}
