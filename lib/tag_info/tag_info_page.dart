import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:doggie_tag_list/models/order.dart';
import 'package:doggie_tag_list/auth.dart';
import 'package:doggie_tag_list/tag_info/tag_info.dart';
import 'package:doggie_tag_list/authentication/authentication.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TagInfoPage extends StatefulWidget {
  final TagInfoBloc tagInfoBloc = TagInfoBloc();
  final AuthenticationBloc authBloc = AuthenticationBloc();

  @override
  TagInfoPageState createState() => TagInfoPageState(tagInfoBloc: tagInfoBloc, authBloc: authBloc);
}

class TagInfoPageState extends State<TagInfoPage>
  implements AuthStateListener {
  final TagInfoBloc tagInfoBloc;
  final AuthenticationBloc _authBloc;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  String token;
  String _dogName;
  String _phoneNumber;
  String _shippingAddress;
  String _contactNumber;
  String _wood;
  String _design;
  String _size;
  AuthStateProvider _authStateProvider;
  final FocusNode _dogNameFocus = FocusNode();
  final FocusNode _phoneNumberFocus = FocusNode();
  final FocusNode _shippingAddressFocus = FocusNode();
  final FocusNode _contactNumberFocus = FocusNode();

  TagInfoPageState({
    @required TagInfoBloc tagInfoBloc,
    @required AuthenticationBloc authBloc
  }) : tagInfoBloc = tagInfoBloc,
       _authBloc = authBloc;

  @override
  void initState() {
      super.initState();
      _authStateProvider = new AuthStateProvider();
      _authStateProvider.subscribe(this);
  }


  @override
  onAuthStateChanged(AuthState state) {
  }

  void _submit() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      Order order = new Order(_dogName,_phoneNumber,_shippingAddress,_contactNumber,_wood,_design,_size);
      tagInfoBloc.onSubmitPressed(order: order);
      form.reset();
      setState(() {
        _wood = null;
        _design = null;
        _size = null;
      });
    } else {
      print('oops online');
    }
  }

  @override
  void dispose() {
    tagInfoBloc.dispose();
    super.dispose();
  }

  _fieldFocusChange(BuildContext context, FocusNode from, FocusNode to){
    from.unfocus();
    FocusScope.of(context).requestFocus(to);
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TagInfoEvent, TagInfoState>(
      bloc: tagInfoBloc,
      builder: (
        BuildContext context,
        TagInfoState tagInfoState
      ) {
          var submitBtn =
                    RaisedButton(
                      onPressed: () => _submit(),
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
                    onTap: () => Navigator.of(context).pushReplacementNamed("/orders")
                  ),
                  new ListTile(
                    title: new Text('Logout'),
                    onTap: () => tagInfoBloc.onLogout()
                  ),
                ],
              )
            ),
            body: Builder (
              builder: (BuildContext _ctx) {
              if (!tagInfoState.authenticated) {
                _onWidgetDidBuild(() {
                  Navigator.of(context).pushReplacementNamed("/login");
                  _authBloc.onLogout();
                });
              }

              if (tagInfoState.order != null) {
                _onWidgetDidBuild(() {
                  String name = tagInfoState.order.dogName;
                  Scaffold.of(_ctx).showSnackBar(SnackBar(content: new Text("$name's tag successfully added!")));
                }
                );
                tagInfoBloc.onSnackBarShown();
              }

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
                    tagInfoState.isLoading ? new CircularProgressIndicator() : submitBtn
                  ],
                ),
              ),
              );
            }
            ),
            resizeToAvoidBottomPadding: false,
          );
      }
      );
}}