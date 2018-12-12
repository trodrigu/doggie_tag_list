import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

enum AuthState{ LOGGED_IN, LOGGED_OUT }

abstract class AuthStateListener {
  void onAuthStateChanged(AuthState state);
}

class AuthStateProvider {
  static final AuthStateProvider _instance = new AuthStateProvider.internal();

  List<AuthStateListener> _subscribers;

  factory AuthStateProvider() => _instance;
  AuthStateProvider.internal() {
    _subscribers = new List<AuthStateListener>();
    initState();
  }

  /// ----------------------------------------------------------
  /// Method that returns the token from Shared Preferences
  /// ----------------------------------------------------------

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<String> getMobileToken() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString("token") ?? '';
  }

  /// ----------------------------------------------------------
  /// Method that removes the token in Shared Preferences
  /// ----------------------------------------------------------
  Future<bool> rmMobileToken() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.remove("token");
  }

  /// ----------------------------------------------------------
  /// Method that saves the token in Shared Preferences
  /// ----------------------------------------------------------
  Future<bool> setMobileToken(String token) async {
    final SharedPreferences prefs = await _prefs;

    return prefs.setString("token", token);
  }


  void initState() async {
    var mobileToken = await getMobileToken();

    var isLoggedIn = mobileToken.length > 0;
    if(isLoggedIn)
      notify(AuthState.LOGGED_IN);
    else
      notify(AuthState.LOGGED_OUT);
  }

  void subscribe(AuthStateListener listener) {
    _subscribers.add(listener);
  }

  void dispose(AuthStateListener listener) {
    _subscribers.remove(listener);
  }

  void disposeAll() {
    _subscribers = [];
  }

  void notify(AuthState state) {
    _subscribers.forEach((AuthStateListener s) => s.onAuthStateChanged(state));
  }
}