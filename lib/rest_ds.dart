import 'dart:async';

import 'package:doggie_tag_list/utils/network_util.dart';
import 'package:doggie_tag_list/models/user.dart';
import 'package:doggie_tag_list/models/order.dart';
import 'package:doggie_tag_list/auth.dart';
import 'dart:io';

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

  Future<Order> createOrder(String _dogName, String _phoneNumber, String _shippingAddress, String _contactNumber, String _wood, String _design, String _size, AuthStateProvider auth) async {
    String token = await auth.getMobileToken();
    return client.post('http://localhost:4000/api/orders', body: {
      "dog_name": _dogName,
      "phone_number": _phoneNumber,
      "shipping_address": _shippingAddress,
      "contact_number": _contactNumber,
      "wood": _wood,
      "design": _design,
      "size": _size
    }, 
    headers: {HttpHeaders.authorizationHeader: ("Bearer " + token)}
    ).then((dynamic res) {
      _order = new Order.map(res);
      return _order;
    });
  }

  Future<List<Order>> getOrders() {
    return client.get('http://localhost:4000/api/orders').then((dynamic res) {
      res.map(
        (dynamic order) => order
      );
    });
  }
}