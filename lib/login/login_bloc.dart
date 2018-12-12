import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:doggie_tag_list/login/login.dart';
import 'package:doggie_tag_list/rest_ds.dart';
import 'package:flutter/foundation.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginState get initialState => LoginState.initial();
  final RestDatasource _restDs;

  LoginBloc({
    Key key,
    @required RestDatasource restDs,
  }) : _restDs = restDs;


  void onLoginButtonPressed({String email, String password}) {
    dispatch(
      LoginButtonPressed(
        email: email,
        password: password,
      ),
    );
  }

  void onLoginSuccess() {
    dispatch(LoggedIn());
  }

  @override
  Stream<LoginState> mapEventToState(
    LoginState state,
    LoginEvent event,
  ) async* {
    if (event is LoginButtonPressed) {
      yield LoginState.loading();

      try {
        final token = await _getToken(
          email: event.email,
          password: event.password,
        );

        yield LoginState.success(token);
      } catch (error) {
        yield LoginState.failure(error.toString());
      }
    }

    if (event is LoggedIn) {
      yield LoginState.initial();
    }
  }

  Future<String> _getToken({
    @required String email,
    @required String password,
  }) async {
    /// uncomment the following line to simulator a login error.
    // throw Exception('Login Error');
    return await doLogin(email, password);
  }

  doLogin(String email, String password) async {
    return _restDs.login(email, password);
  }
}
