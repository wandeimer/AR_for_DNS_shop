import 'dart:async';
import 'dart:core';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flios/linkList.dart';
import 'package:flios/taskInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadFilesFunction {
  bool permissionReady;
  String _localPath;
  bool isLoading;
  LinkList linkList;
  List<TaskInfo> _tasks;
  ReceivePort _port;
  var tasks;

  void init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterDownloader.initialize(
        debug: true // optional: set false to disable printing logs to console
        );
    _port = ReceivePort();
  }

  Future<Null> prepare(TargetPlatform platform, var _tasks) async {
    tasks = await FlutterDownloader.loadTasks();

    int count = 0;
    //var _tasks = [];
    var _items = [];

    _tasks.addAll(linkList.links.map((document) =>
        TaskInfo(name: document['name'], link: document['link'])));

    tasks?.forEach((task) {
      for (TaskInfo info in _tasks) {
        if (info.link == task.url) {
          info.taskId = task.taskId;
          info.status = task.status;
          info.progress = task.progress;
        }
      }
    });

    permissionReady = await _checkPermission(platform);

    _localPath =
        (await findLocalPath(platform)) + Platform.pathSeparator + 'Download';

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }

    isLoading = false;
  }

  Future<String> findLocalPath(TargetPlatform platform) async {
    final directory = platform == TargetPlatform.android
        ? await (getExternalStorageDirectory() as FutureOr<Directory>)
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<bool> _checkPermission(TargetPlatform platform) async {
    if (platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  void bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      // log Callback data
      print('UI Isolate Callback: $data');

      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      if (_tasks != null && _tasks.isNotEmpty) {
        final task = _tasks.firstWhere((task) => task.taskId == id);
        if (task != null) {
          task.status = status;
          task.progress = progress;
        }
      }
    });
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      // debug isolate callback
      print('UI Isolate Callback: $data');
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      if (_tasks != null && _tasks.isNotEmpty) {
        final task = _tasks.firstWhere((task) => task.taskId == id);
        if (task != null) {
          task.status = status;
          task.progress = progress;
        }
      }
    });
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    // debug
    print(
        'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }
}
