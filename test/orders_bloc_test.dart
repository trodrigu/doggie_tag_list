import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:doggie_tag_list/rest_ds.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:doggie_tag_list/models/order.dart';
import 'mock_rest_datasource.dart';
import 'package:doggie_tag_list/orders/orders.dart';

void main() {
  OrdersBloc ordersBloc;

  setUp(() {
    final restDs = new MockRestDatasource();
    ordersBloc = OrdersBloc(restDs: restDs);
  });

  test('initial state is correct', () {
    expect(OrdersState.initial(), ordersBloc.initialState);
  });

  test('dispose does not emit new states', () {
    expectLater(
      ordersBloc.state,
      emitsInOrder([]),
    );
    ordersBloc.dispose();
  });

  group('GetOrders', () {

    test('emits orders on success', () {
      final expectedResponse = [
        OrdersState.initial(),
        OrdersState.success([new Order('','','','','','','',)])
      ];

      expectLater(
        ordersBloc.state,
        emitsInOrder(expectedResponse)
      );

      ordersBloc.dispatch(GetOrders());
    });
  });


}