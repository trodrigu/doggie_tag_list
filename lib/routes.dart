import 'package:flutter/material.dart';
import 'package:doggie_tag_list/tag_info.dart';
import 'package:doggie_tag_list/home.dart';

final routes = {
  '/login': (BuildContext context) => new Home(),
  '/tag_info': (BuildContext context) => new TagInfo(),
  '/' : (BuildContext context) => new Home(),
};