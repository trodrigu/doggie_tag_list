import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doggie_tag_list/authentication/authentication.dart';
import 'package:doggie_tag_list/login/login.dart';
import 'package:doggie_tag_list/rest_ds.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final LoginBloc _loginBloc = LoginBloc(restDs: new RestDatasource());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginForm(
        authBloc: BlocProvider.of<AuthenticationBloc>(context),
        loginBloc: _loginBloc,
      ),
    );
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }
}