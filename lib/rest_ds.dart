import 'dart:async';

import 'package:doggie_tag_list/utils/network_util.dart';
import 'package:doggie_tag_list/models/user.dart';
import 'package:doggie_tag_list/models/order.dart';
import 'dart:convert';
import 'package:doggie_tag_list/auth.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class RestDatasource {
  String _token;
  User _user;
  Order _order;
  final Client _client = new Client();

  Future<String> login(String email, String password) {
    return _client.post('http://localhost:4000/api/token', body: {
      "email": email,
      "password": password
    }).then((dynamic res) {
        return res["token"];
    });
  }

  Future<Order> createOrder(String _dogName, String _phoneNumber, String _shippingAddress, String _contactNumber, String _wood, String _design, String _size) async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    return _client.post('http://localhost:4000/api/orders', body: {
      "dog_name": _dogName,
      "phone_number": _phoneNumber,
      "shipping_address": _shippingAddress,
      "contact_number": _contactNumber,
      "wood": _wood,
      "design": _design,
      "size": _size
    }, 
    headers: {HttpHeaders.authorizationHeader: ("Bearer " + prefs.getString('token'))}
    ).then((dynamic res) {
      _order = new Order.map(res);
      return _order;
    });
  }

  List<Order> parseOrders(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Order>((json) => Order.map(json)).toList();
  }

  Future<List<Order>> getOrders() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    return _client.get('http://localhost:4000/api/orders', headers: {HttpHeaders.authorizationHeader: ("Bearer " + prefs.getString('token'))}).then((dynamic res) {
    return res.map<Order>((order) => Order.map(order)).toList();
    });
  }
}