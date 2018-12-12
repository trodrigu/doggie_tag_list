import 'package:flutter/material.dart';
import 'orders/orders.dart';
import 'login/login_page.dart';
import 'tag_info/tag_info.dart';

final routes = {
  '/orders': (BuildContext context) => new OrdersPage(),
  '/login': (BuildContext context) => new LoginPage(),
  '/tag_info': (BuildContext context) => new TagInfoPage()
};