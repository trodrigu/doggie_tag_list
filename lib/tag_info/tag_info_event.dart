import 'package:meta/meta.dart';

import 'package:flutter/widgets.dart';
import 'package:doggie_tag_list/models/order.dart';

abstract class TagInfoEvent {}

class TagInfoButtonPressed extends TagInfoEvent {
  final Order order;

  TagInfoButtonPressed({
    @required this.order,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TagInfoButtonPressed &&
          runtimeType == other.runtimeType &&
          order == other.order;

  @override
  int get hashCode => order.hashCode; 
}

class TagSubmitted extends TagInfoEvent {}
class LoggedOut extends TagInfoEvent {}
