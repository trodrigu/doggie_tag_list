import 'dart:async';
import 'dart:developer';

import 'package:doggie_tag_list/utils/network_util.dart';
import 'package:doggie_tag_list/models/user.dart';
import 'package:doggie_tag_list/models/order.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RestDatasource {
  String _token;
  User _user;
  Order _order;
  final client = new Client();

  Future<User> login(String email, String password) {
    return client.post('http://localhost:4000/api/token', body: {
      "email": email,
      "password": password
    }).then((dynamic res) {
        _token = res["token"];
        _user = new User.map(_token);
        return _user;
    });
  }

  Future<Order> createOrder(String _dogName, String _phoneNumber, String _shippingAddress, String _contactNumber, String _wood, String _design, String _size) {
    return client.post('http://localhost:4000/api/orders', body: {
      "dogName": _dogName,
      "phoneNumber": _phoneNumber,
      "shippingAddress": _shippingAddress,
      "contactNumber": _contactNumber,
      "wood": _wood,
      "design": _design,
      "size": _size
    }).then((dynamic res) {
      _order = new Order.map(res["order"]);
      return _order;
    });
  }
}