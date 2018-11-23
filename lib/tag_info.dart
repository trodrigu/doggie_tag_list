import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:doggie_tag_list/rest_ds.dart';
import 'package:doggie_tag_list/models/order.dart';

class TagInfo extends StatefulWidget {

  @override
  TagInfoPageState createState() => TagInfoPageState();
}

class TagInfoPageState extends State<TagInfo> {

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

  bool _formWasEdited = false;
  bool _isLoading = false;

  void _submit(BuildContext context) {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      _performSave(context);
      print('yay');

    } else {
      print('oops');
    }
  }

  _createOrder(String _dogName, String _phoneNumber, String _shippingAddress, String _contactNumber, String _wood, String _design, String _size, BuildContext context) {
    RestDatasource api = new RestDatasource();
    api.createOrder(_dogName, _phoneNumber, _shippingAddress, _contactNumber, _wood, _design, _size).then((Order order) {
      onOrderSuccess(order, context);
    }).catchError((Exception error) => onOrderError(error.toString(), context));
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
  Widget build(BuildContext context) {
    var submitBtn =
              RaisedButton(
                onPressed: () => _submit(context),
                child: Text('Get Tag!'),
              );
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Add Tag Info'),
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