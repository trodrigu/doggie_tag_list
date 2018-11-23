import 'dart:async';
import 'package:flutter/material.dart';
import 'package:doggie_tag_list/tag_info.dart';
import 'package:doggie_tag_list/routes.dart';

Future<void> main() async {



    runApp(
    new MaterialApp(
        title: 'Tag Info!!',
        theme: new ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
          // counter didn't reset back to zero; the application is not restarted.
          primarySwatch: Colors.blue,
        ),
        routes: routes,
    )
    );
}
