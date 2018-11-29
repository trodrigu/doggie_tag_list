import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:doggie_tag_list/rest_ds.dart';
import 'package:doggie_tag_list/models/order.dart';
import 'package:doggie_tag_list/models/ordersList.dart';
import 'package:doggie_tag_list/auth.dart';
import 'package:doggie_tag_list/home.dart';
import 'package:connectivity/connectivity.dart';
import 'package:pref_dessert/pref_dessert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class Orders extends StatefulWidget {
  @override
  OrdersState createState() => OrdersState();
}

class OrdersState extends State<Orders>
  implements AuthStateListener {
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  BuildContext _ctx;
  AuthStateProvider _authStateProvider;

  
  @override
  onAuthStateChanged(AuthState state) {
  }

  @override
  void initState() {
    super.initState();
    _authStateProvider = new AuthStateProvider();
    _authStateProvider.subscribe(this);
    initConnectivity();
    _connectivitySubscription =
      _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
        setState(() => _connectionStatus = result.toString());
        });

    print('ya');
  }

  // initialize some async messages for connectivity
  Future<Null> initConnectivity() async {
    String connectionStatus;
    try {
      connectionStatus = (await _connectivity.checkConnectivity()).toString();
    } on PlatformException catch (e) {
      print(e.toString());
      connectionStatus = 'Failed to get connectivity!';
    }

    if (!mounted) {
      return;
    }

    setState(
      () {
      _connectionStatus = connectionStatus;
    });


  }

  void authOut() async {
    Navigator.of(_ctx).pushReplacementNamed("/login");
    _authStateProvider.rmMobileToken();
    _authStateProvider.notify(AuthState.LOGGED_OUT);
    _authStateProvider.disposeAll();
  }

  List<Order> parseOrders(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Order>((json) => Order.map(json)).toList();
  }

  Future<List<Order>> _getOrders(http.Client client) async {
    String token = await _authStateProvider.getMobileToken();
    final response = await client.get('http://localhost:4000/api/orders/', headers: {HttpHeaders.authorizationHeader: ("Bearer " + token)});
    return parseOrders(response.body);
  }

  @override
  Widget build(BuildContext context) {
    print(_connectionStatus);

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
              onTap: () => authOut()
            ),
          ],
        )
      ),
      body: FutureBuilder<List<Order>>(
        future: _getOrders(http.Client()),
        builder: (BuildContext context, snapshot) {
          _ctx = context;
          if (snapshot.hasError) {

          }
          return snapshot.hasData
            ? ListViewOrders(orders: snapshot.data)
            : new CircularProgressIndicator();
        },)
    );
  }
}

class OrderDesSer extends DesSer<Order>{
  @override
  Order deserialize(String s) {
    if (s == "[]") {
      return new Order("","","","","","","");
    } else {
      var split = s.split(",");
      return new Order(split[0], 
                      split[1],
                      split[2],
                      split[3],
                      split[4],
                      split[5],
                      split[6]);
    }
  }

  @override
  String serialize(Order t) {
    return "${t.dogName},${t.phoneNumber},${t.shippingAddress},${t.contactNumber},${t.wood},${t.design},${t.size}";
  }

  @override
  String get key => "Order";
}

class ListViewOrders extends StatelessWidget {
  final List<Order> orders;

  ListViewOrders({Key key, this.orders}) : super(key: key);

  void _onTapItem(BuildContext context, Order order) {
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
                  onTap: () => _onTapItem(context, orders[position])
                ),
              ],
            );
          }),
    );
  }
}

