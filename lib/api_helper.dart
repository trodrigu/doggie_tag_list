import 'dart:async';
import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:login_app/models/user.dart';
import 'package:path_provider/path_provider.dart';

class ApiHelper {
  static final ApiHelper _instance = new ApiHelper.internal();
  factory ApiHelper() => _instance;

  static Api _api;

  Future<Api> get api async {
    if(_api != null)
      return _api;
    _api = await initDb();
    return _api;
  }

  ApiHelper.internal();

  Future<bool> isLoggedIn() async {
    var apiClient = await api;
    var res = await apiClient.query("User");
    return res.length > 0? true: false;
  }

}