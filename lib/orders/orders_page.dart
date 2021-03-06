import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doggie_tag_list/rest_ds.dart';
import 'package:doggie_tag_list/models/order.dart';
import 'package:doggie_tag_list/authentication/authentication.dart';
import 'dart:convert';
import 'orders.dart';

class OrdersPage extends StatefulWidget {
  final AuthenticationBloc _authBloc = AuthenticationBloc();

  @override
  OrdersWidgetState createState() => OrdersWidgetState(authBloc: _authBloc);
}

class OrdersWidgetState extends State<OrdersPage>
  {
  final OrdersBloc _ordersBloc = OrdersBloc(restDs: new RestDatasource());
  final AuthenticationBloc _authBloc;

  BuildContext _ctx;

  OrdersWidgetState({
    @required AuthenticationBloc authBloc
  }) : _authBloc = authBloc;

  @override
  void initState() {
    super.initState();
  }

  List<Order> parseOrders(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Order>((json) => Order.map(json)).toList();
  }

  void showMeASnack(BuildContext context, Order order) {
    String orderAsString =
      """
      Dog Name: ${order.dogName}
      Phone Number: ${order.phoneNumber}
      Shipping Address: ${order.shippingAddress}
      Contact Number: ${order.contactNumber}
      Wood: ${order.wood}
      Design: ${order.design}
      Size: ${order.size}
      """;
    Scaffold
        .of(context)
        .showSnackBar(new SnackBar(content: new Text(orderAsString)));
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  bool _showOrder(OrdersState state) => state.order != null;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersEvent, OrdersState>(
      bloc: _ordersBloc,
      builder: (
        BuildContext context,
        OrdersState ordersState
      ) {
        if (!ordersState.authenticated) {
          _onWidgetDidBuild(() {
            Navigator.of(context).pushReplacementNamed("/login");
            _authBloc.onLogout();
          });
        }

        if (_showOrder(ordersState)) {
          _onWidgetDidBuild(() {
            showMeASnack(_ctx, ordersState.order);
          });
          _ordersBloc.resetSnack();
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Orders'),
            ),
          drawer: new Drawer(
            child: new ListView(
              children: <Widget> [
                new DrawerHeader(child: new Text('Menu'),),
                new ListTile(
                  title: new Text('Tag Info'),
                  onTap: () => Navigator.of(_ctx).pushReplacementNamed("/tag_info")
                ),
                new ListTile(
                  title: new Text('Logout'),
                  onTap: () => _ordersBloc.onLogout()
                ),
              ],
            )
          ),
          body: FutureBuilder<List<Order>>(
            future: _ordersBloc.getOrders(),
            builder: (BuildContext context, snapshot) {
              _ctx = context;

              if (snapshot != null) {
                if (snapshot.hasError) {

                }
                return snapshot.hasData
                  ? ListViewOrders(
                      orders: snapshot.data,
                      ordersBloc: _ordersBloc)
                  : new CircularProgressIndicator();
              }
            },)
        );
        }
    );
  }

  @override
  void dispose() {
    _ordersBloc.dispose();
    super.dispose();
  }
}

class ListViewOrders extends StatelessWidget {
  final List<Order> orders;
  final OrdersBloc ordersBloc;

  ListViewOrders({Key key, this.orders, this.ordersBloc }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: orders.length,
          padding: const EdgeInsets.all(15.0),
          itemBuilder: (context, position) {
            return Column(
              children: <Widget>[
                Divider(height: 5.0),
                ListTile(
                  title: Text('${orders[position].dogName}'),
                  onTap: () => ordersBloc.onTapItem(orders[position])
                ),
              ],
            );
          }),
    );
  }
}

