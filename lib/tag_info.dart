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


class TagInfo extends StatefulWidget {

  @override
  TagInfoPageState createState() => TagInfoPageState();
}

class TagInfoPageState extends State<TagInfo> 
  implements AuthStateListener {
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  String _dogName;
  String _phoneNumber;
  String _shippingAddress;
  String _contactNumber;
  String _wood;
  String _design;
  String _size;
  BuildContext _ctx;
  AuthStateProvider _authStateProvider;

  bool _formWasEdited = false;
  bool _isLoading = false;

  @override
  onAuthStateChanged(AuthState state) {
   
    if(state == AuthState.LOGGED_OUT)
      Navigator.of(_ctx).pushReplacementNamed("/login");
  }

  void _submit(BuildContext context) {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      _performSave(context);
      form.reset();
      print('yay online');

    } else {
      print('oops online');
    }
  }

  void _submitOffline(BuildContext context) {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      _performSaveOffline(context);
      form.reset();
      print('yay offline');

    } else {
      print('oops offline');
    }
  }

  _createOrder(String _dogName, String _phoneNumber, String _shippingAddress, String _contactNumber, String _wood, String _design, String _size, BuildContext context) {
    RestDatasource api = new RestDatasource();
    api.createOrder(_dogName, _phoneNumber, _shippingAddress, _contactNumber, _wood, _design, _size).then((Order order) {
      onOrderSuccess(order, context);
    }).catchError((Exception error) => onOrderError(error.toString(), context));
  }

  Future<dynamic> _performSaveOffline(BuildContext context) async {
    var repo = FuturePreferencesRepository<OrdersList>(new OrdersDesSer());
    var list = repo.findAll();
    print(list);
    repo.save(OrdersList.map([]));
  }

  Future<String> getOrdersList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('Orders');
  }

  Future<bool> setOrdersList(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('Orders', value);
  }

  Future<dynamic> _performSave(BuildContext context) async {
      final Map<String, dynamic> data = 
        {
          'contactNumber': _contactNumber,
          'design': _design,
          'dogName': _dogName,
          'phoneNumber': _phoneNumber,
          'shippingAddress': _shippingAddress,
          'size': _size,
          'wood': _wood
        };

      _createOrder(_dogName,_phoneNumber,_shippingAddress,_contactNumber,_wood,_design,_size, context);
      print(data);
      return data;
  }

  void _showSnackBar(String text, BuildContext context) {
    Scaffold.of(_ctx).showSnackBar(SnackBar(content: new Text(text)));
  }

  @override
  void onOrderError(String errorTxt, BuildContext context) {
    _showSnackBar(errorTxt, context);
    setState(() => _isLoading = false);
  }

  @override
  void onOrderSuccess(Order order, BuildContext context) async {
    _showSnackBar("Thank you!", context);
    setState(() => _isLoading = false);
  }
  
  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @mustCallSuper
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
    _authStateProvider.rmMobileToken();
    _authStateProvider.notify(AuthState.LOGGED_OUT);
    _authStateProvider.disposeAll();
  }

  @override
  Widget build(BuildContext context) {
    print(_connectionStatus);
    var submitBtn =
              RaisedButton(
                onPressed: () => (_connectionStatus == 'ConnectivityResult.wifi' ? _submit(context) : _submitOffline(context)),
                child: Text('Get Tag!'),
              );
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Add Tag Info'),
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget> [
            new DrawerHeader(child: new Text('Menu'),),
            new ListTile(
              title: new Text('Logout'),
              onTap: () => authOut()
            )
          ],
        )
      ),
      body: Builder (
        builder: (BuildContext context) {
        _ctx = context;
        return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          autovalidate: true,
          child: Column(
            children: <Widget>[
              new ListTile(
                leading:  const Icon(Icons.pets),
                title: TextFormField(
                  decoration: InputDecoration(labelText: 'Dog\'s Name'),
                  onSaved: (val) => _dogName = val,
                )
              ),
              new ListTile(
                leading:  const Icon(Icons.phone),
                title: TextFormField(
                  decoration: InputDecoration(labelText: 'Phone Number On Tag'),
                  onSaved: (val) => _phoneNumber = val,
                  keyboardType: TextInputType.phone,
                )
              ),
              new ListTile(
                leading: const Icon(Icons.local_shipping),
                title: TextFormField(
                  decoration: InputDecoration(labelText: 'Shipping Address'),
                  onSaved: (val) => _shippingAddress = val,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.phone_iphone),
                title: TextFormField(
                  decoration: InputDecoration(labelText: 'Good Contact Number For You'),
                  onSaved: (val) => _contactNumber = val,
                ),
              ),
              DropdownButton(
                hint: Text('Pick a wood'),
                items: [
                   DropdownMenuItem (value: 'Avocado', child: Text('Avocado') ),
                   DropdownMenuItem (value: 'Sugar Gum', child: Text('Sugar Gum') ),
                   DropdownMenuItem (value: 'Black Acacia', child: Text('Black Acacia') ),
                   DropdownMenuItem (value: 'Red Gum', child: Text('Red Gum') )
                ],
                value: _wood,
                onChanged: (String newValue) {
                  setState(() { _wood = newValue; });
                }
              ),
              DropdownButton(
                hint: Text('Pick a design'),
                items: [
                   DropdownMenuItem (value: 'Adventure Awaits', child: Text('Adventure Awaits') ),
                   DropdownMenuItem (value: 'Pawsitive Vibes', child: Text('Pawsitive Vibes') ),
                   DropdownMenuItem (value: 'Loved', child: Text('Loved') ),
                   DropdownMenuItem (value: 'Dog Life', child: Text('Dog Life') )
                ],
                value: _design,
                onChanged: (String newValue) {
                  setState(() { _design = newValue; });
                }
              ),
              DropdownButton(
                hint: Text('Pick a size'),
                items: [
                   DropdownMenuItem (value: 'Large', child: Text('Large') ),
                   DropdownMenuItem (value: 'Small', child: Text('Small') ),
                ],
                value: _size,
                onChanged: (String newValue) {
                  setState(() { _size = newValue; });
                }
              ),
              _isLoading ? new CircularProgressIndicator() : submitBtn
            ],
          ),
        ),
        );
      }
      )
    );
}}

class OrdersDesSer extends DesSer<OrdersList>{
  @override
  OrdersList deserialize(String s) {
    // "[{tom,dude,234234,jkl},{man,bro,23432,sdf}]"
    var orders = s.split(new RegExp(r"{"));
    print(orders);
    //return new OrdersList(split);
    return OrdersList.map([]);
  }

  @override
  String serialize(OrdersList o) {
    return "[]";
  }

  @override
  String get key => "Orders";
}