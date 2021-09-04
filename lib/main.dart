import 'package:duovoc_flutter/src/view/overview_view.dart';
import 'package:flutter/material.dart';

class Duovoc extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        home: OverviewView(),
      );
}
