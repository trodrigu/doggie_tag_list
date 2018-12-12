import 'package:meta/meta.dart';
import 'package:flutter/widgets.dart';

abstract class OrdersEvent {}

class OrdersButtonPressed extends OrdersEvent {
  final String dogName;
  final String phoneNumber;
  final String shippingAddress;
  final String contactNumber;
  final String wood;
  final String design;
  final String size;

  OrdersButtonPressed({
    @required this.dogName,
    @required this.phoneNumber,
    @required this.shippingAddress,
    @required this.contactNumber,
    @required this.wood,
    @required this.design,
    @required this.size,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrdersButtonPressed &&
          runtimeType == other.runtimeType &&
          dogName == other.dogName &&
          phoneNumber == other.phoneNumber &&
          shippingAddress == other.shippingAddress &&
          contactNumber == other.contactNumber &&
          wood == other.wood &&
          design == other.design &&
          size == other.size;

  @override
  int get hashCode => dogName.hashCode ^ phoneNumber.hashCode ^ shippingAddress.hashCode ^ contactNumber.hashCode ^ wood.hashCode ^ design.hashCode ^ size.hashCode;
}

class ShowOrder extends OrdersEvent {}

class GetOrders extends OrdersEvent {}

class ResetSnack extends OrdersEvent {}

class LoggedOut extends OrdersEvent {}