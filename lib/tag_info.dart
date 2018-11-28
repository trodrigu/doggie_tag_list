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
  var _dogNameController = TextEditingController();
  var _phoneNumberController = TextEditingController();
  var _shippingAddressController = TextEditingController();
  var _contactNumberController = TextEditingController();
  var _woodController = TextEditingController();
  var _designController = TextEditingController();
  var _sizeController = TextEditingController();
  final FocusNode _dogNameFocus = FocusNode();
  final FocusNode _phoneNumberFocus = FocusNode();
  final FocusNode _shippingAddressFocus = FocusNode();
  final FocusNode _contactNumberFocus = FocusNode();
  final FocusNode _woodFocus = FocusNode();
  final FocusNode _designFocus = FocusNode();
  final FocusNode _sizeFocus = FocusNode();

  bool _formWasEdited = false;
  bool _isLoading = false;

  @override
  onAuthStateChanged(AuthState state) {
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
    var repo = FuturePreferencesRepository<Order>(new OrderDesSer());
    repo.save(Order(_dogName,_phoneNumber,_shippingAddress,_contactNumber,_wood,_design,_size));
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
    Navigator.of(_ctx).pushReplacementNamed("/login");
    _authStateProvider.rmMobileToken();
    _authStateProvider.notify(AuthState.LOGGED_OUT);
    _authStateProvider.disposeAll();
  }

  _fieldFocusChange(BuildContext context, FocusNode from, FocusNode to){
    from.unfocus();
    FocusScope.of(context).requestFocus(to);
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
              title: new Text('Orders'),
              onTap: () => Navigator.of(_ctx).pushReplacementNamed("/orders")
            ),
            new ListTile(
              title: new Text('Logout'),
              onTap: () => authOut()
            ),
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
                  controller: _dogNameController,
                  textInputAction:  TextInputAction.next,
                  focusNode: _dogNameFocus,
                  onFieldSubmitted: (term){
                    _fieldFocusChange(context, _dogNameFocus, _phoneNumberFocus);
                  },
                  decoration: InputDecoration(labelText: 'Dog\'s Name'),
                  onSaved: (val) => _dogName = val,
                )
              ),
              new ListTile(
                leading:  const Icon(Icons.phone),
                title: TextFormField(
                  controller: _phoneNumberController,
                  textInputAction: TextInputAction.next,
                  focusNode: _phoneNumberFocus,
                  onFieldSubmitted: (term){
                    _fieldFocusChange(context, _phoneNumberFocus, _shippingAddressFocus);
                  },
                  decoration: InputDecoration(labelText: 'Phone Number On Tag'),
                  onSaved: (val) => _phoneNumber = val,
                  keyboardType: TextInputType.phone,
                )
              ),
              new ListTile(
                leading: const Icon(Icons.local_shipping),
                title: TextFormField(
                  controller: _shippingAddressController,
                  textInputAction: TextInputAction.next,
                  focusNode: _shippingAddressFocus,
                  onFieldSubmitted: (term){
                    _fieldFocusChange(context, _shippingAddressFocus, _contactNumberFocus);
                  },
                  decoration: InputDecoration(labelText: 'Shipping Address'),
                  onSaved: (val) => _shippingAddress = val,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.phone_iphone),
                title: TextFormField(
                  controller: _contactNumberController,
                  textInputAction: TextInputAction.next,
                  focusNode: _contactNumberFocus,
                  onFieldSubmitted: (term){
                    _contactNumberFocus.unfocus();
                  },
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
      ),
      resizeToAvoidBottomPadding: false,
    );
}}

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