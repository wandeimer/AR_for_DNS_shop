import 'package:flios/downloadAfterRecieveLink.dart';
import 'package:flios/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'bloc.dart';

class PocWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DeepLinkBloc _bloc = Provider.of<DeepLinkBloc>(context);
    return StreamBuilder<String>(
      stream: _bloc.state,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return MyApp();
        } else {
          return Download(modelLink: snapshot.data);
          // child: Text('Redirected: ${snapshot.data}',
          //     style: Theme.of(context).textTheme.title))));
        }
      },
    );
  }
}
