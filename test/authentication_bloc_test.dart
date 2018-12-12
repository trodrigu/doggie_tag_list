import 'package:flutter_test/flutter_test.dart';

import 'package:doggie_tag_list/authentication/authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';


void main() {
  AuthenticationBloc authenticationBloc;

  setUp(() async {
    authenticationBloc = AuthenticationBloc();
    const MethodChannel('plugins.flutter.io/shared_preferences')
    .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getAll') {
        return <String, dynamic>{}; // set initial values here if desired
      }
      return null;
    });

  });

  test('initial state is correct', () async {
    expect(authenticationBloc.initialState, AuthenticationState.initializing());
  });

  test('dispose does not emit new states', () {
    SharedPreferences.setMockInitialValues({});

    expectLater(
      authenticationBloc.state,
      emitsInOrder([]),
    );
    authenticationBloc.dispose();
  });

  group('AppStarted', () {
    test('emits AuthenticationState.unauthenticated() for invalid token', () async {
      final expectedResponse = [
        AuthenticationState.initializing().copyWith(isLoading: true),
        AuthenticationState.unauthenticated()
      ];

      expectLater(
        authenticationBloc.state,
        emitsInOrder(expectedResponse),
      );

      authenticationBloc.dispatch(AppStarted());
    });
  });

  group('LoggedIn', () {
    test('emits [loading, authenticated] when token is persisted', () {
      final expectedResponse = [
        AuthenticationState.initializing().copyWith(isLoading: true),
        AuthenticationState.authenticated(),
      ];

      expectLater(
        authenticationBloc.state,
        emitsInOrder(expectedResponse),
      );

      authenticationBloc.dispatch(LoggedIn(
        token: 'instance.token',
      ));
    });
  });

  group('LoggedOut', () {
    test('emits [loading, unauthenticated] when token is deleted', () {
      final expectedResponse = [
        AuthenticationState.initializing().copyWith(isLoading: true),
        AuthenticationState.unauthenticated(),
      ];

      expectLater(
        authenticationBloc.state,
        emitsInOrder(expectedResponse),
      );

      authenticationBloc.dispatch(LoggedOut());
    });
  });
}