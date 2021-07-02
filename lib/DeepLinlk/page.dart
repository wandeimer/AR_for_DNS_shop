import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../colorTheme.dart';
import 'poc.dart';

import 'bloc.dart';

class PocApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    DeepLinkBloc _bloc = DeepLinkBloc();
    return MaterialApp(
      title: 'Flutter and Deep Linsk PoC',
      theme: layoutTheme,
      home: Scaffold(
          body: Provider<DeepLinkBloc>(
              create: (context) => _bloc,
              dispose: (context, bloc) => bloc.dispose(),
              child: PocWidget()),
          ),
    );
  }
}
