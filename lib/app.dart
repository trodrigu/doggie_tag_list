import 'package:flutter/material.dart';

import 'package:doggie_tag_list/routes.dart';
import 'package:doggie_tag_list/authentication/authentication.dart';
import 'package:doggie_tag_list/tag_info/tag_info.dart';
import 'package:doggie_tag_list/login/login.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doggie_tag_list/splash/splash.dart';

class App extends StatefulWidget {
  @override
  State<App> createState() => AppState();

}

class AppState extends State<App> {
  final AuthenticationBloc _authenticationBloc = AuthenticationBloc();

  AppState() {
    _authenticationBloc.onAppStart();
  }

  @override
  void dispose() {
    _authenticationBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      bloc: _authenticationBloc,
      child: MaterialApp(
        title: 'Tag Info!!',
        theme: new ThemeData(
        primarySwatch: Colors.blue,
        ),
        routes: routes,
        home: _rootPage(),
      )
    );
  }

  Widget _rootPage() {
    return BlocBuilder<AuthenticationEvent, AuthenticationState>(
      bloc: _authenticationBloc,
      builder: (BuildContext context, AuthenticationState state) {
        List<Widget> widgets = [];

        if (state.isAuthenticated) {
          widgets.add(TagInfoPage());
        } else {
          widgets.add(LoginPage());
        }

        if (state.isInitializing) {
          widgets.add(SplashPage());
        }

        if (state.isLoading) {
          widgets.add(_loadingIndicator());
        }

        return Stack(
          children: widgets
        );
      }
    );
  }

  Widget _loadingIndicator() {
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.3,
          child: ModalBarrier(dismissible: false, color: Colors.grey),
          ),
          Center(
            child: CircularProgressIndicator(),
          )
      ]
    );
  }
}