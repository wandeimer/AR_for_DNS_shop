import 'package:flios/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../downloadPage.dart';
import 'poc.dart';

import 'bloc.dart';

class PocApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    DeepLinkBloc _bloc = DeepLinkBloc();
    return MaterialApp(
      title: 'Flutter and Deep Linsk PoC',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: TextTheme(
            title: TextStyle(
              fontWeight: FontWeight.w300,
              color: Colors.blue,
              fontSize: 25.0,
            ),
          )),
      home: Scaffold(
          body: Provider<DeepLinkBloc>(
              create: (context) => _bloc,
              dispose: (context, bloc) => bloc.dispose(),
              child: PocWidget()),
          floatingActionButton: Builder(
            builder: (context) => FloatingActionButton(onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyApp()));
            }),
          )),
    );
  }
}
