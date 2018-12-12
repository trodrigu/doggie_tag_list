import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:doggie_tag_list/orders/orders.dart';
import 'package:doggie_tag_list/models/order.dart';
import 'package:doggie_tag_list/rest_ds.dart';
import 'package:flutter/foundation.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersState get initialState => OrdersState.initial();
  Order orderSelected;
  final RestDatasource _restDs;

  OrdersBloc({
    Key key,
    @required RestDatasource restDs,
  }) : _restDs = restDs;

  void onOrdersStart() {
    dispatch(GetOrders());
  }

  void resetSnack() {
    dispatch(ResetSnack());
  }


  void onTapItem(Order order) {
    orderSelected = order;
    dispatch(ShowOrder());
  }
      // OrdersButtonPressed(
      //   dogName: order.dogName,
      //   phoneNumber: order.phoneNumber,
      //   shippingAddress: order.shippingAddress,
      //   contactNumber: order.contactNumber,
      //   wood: order.wood,
      //   design: order.design,
      //   size: order.size
      // )

  void onSubmitSuccess() {
  }

  Future<List <Order>> getOrders() async {
    return await _restDs.getOrders();
  }

  @override
  Stream<OrdersState> mapEventToState(
    OrdersState state,
    OrdersEvent event
  ) async* {
    if (event is ResetSnack) {
      yield OrdersState.initial();
    }

    if (event is ShowOrder) {
      yield OrdersState.showSnack(orderSelected);


      /// maybe do something with snack?
      try {
      } catch (error) {
        yield OrdersState.failure(error.toString());
      }
    }

  }
}