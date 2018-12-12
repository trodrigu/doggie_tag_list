import 'package:flutter_test/flutter_test.dart';
import 'package:doggie_tag_list/login/login.dart';
import 'package:flutter/services.dart';
import 'package:doggie_tag_list/rest_ds.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:doggie_tag_list/models/order.dart';
import 'mock_rest_datasource.dart';


void main() {
  LoginBloc loginBloc;

  setUp(() {
    final restDs = new MockRestDatasource();
    loginBloc = LoginBloc(restDs: restDs);
    const MethodChannel('plugins.flutter.io/shared_preferences')
    .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getAll') {
        return <String, dynamic>{}; // set initial values here if desired
      }
      return null;
    });
  });

  test('initial state is correct', () {
    expect(LoginState.initial(), loginBloc.initialState);
  });

  test('dispose does not emit new states', () {
    expectLater(
      loginBloc.state,
      emitsInOrder([]),
    );
    loginBloc.dispose();
  });

  group('LoginButtonPressed', () {
    test('emits token on success', () {
      final expectedResponse = [
        LoginState.initial(),
        LoginState.loading(),
        LoginState.success('token')
      ];

      expectLater(
        loginBloc.state,
        emitsInOrder(expectedResponse),
      );
      loginBloc.dispatch(LoginButtonPressed(
        email: 'valid.username',
        password: 'valid.password'
      ));
    });
  });
}