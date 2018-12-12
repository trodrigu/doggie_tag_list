import 'package:flutter/material.dart';
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'app.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Transition transition) {
    print(transition.toString());
  }
}

Future<void> main() async {
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(App());
}
