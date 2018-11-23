import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:doggie_tag_list/models/user.dart';
import 'package:doggie_tag_list/login_screen_presenter.dart';
import 'package:doggie_tag_list/auth.dart';
import 'package:flutter/foundation.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home>
    implements LoginScreenContract, AuthStateListener {
  BuildContext _ctx;

  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _password, _email;
  AuthStateProvider _authStateProvider;

  @mustCallSuper
  @override
  void initState() {
      _authStateProvider = new AuthStateProvider();
      _authStateProvider.subscribe(this);
  }


  void _submit(BuildContext context) {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      LoginScreenPresenter _presenter = new LoginScreenPresenter(this);
      _presenter.doLogin(_email, _password);
      _showSnackBar("Thanks for logging in!", context);
    }
  }

  void _showSnackBar(String text, BuildContext context) {
    Scaffold.of(context).showSnackBar(SnackBar(content: new Text(text)));
  }


  @override
  onAuthStateChanged(AuthState state) {
   
    if(state == AuthState.LOGGED_IN)
      Navigator.of(_ctx).pushReplacementNamed("/tag_info");
  }

  @override
  Widget build(BuildContext _context) {
    return new Scaffold(
      appBar: null,
      key: scaffoldKey,
      body: Builder (
        builder: (BuildContext context) {
        _ctx = context;
        return Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
              image: new AssetImage("assets/login_background.png"),
              fit: BoxFit.cover),
        ),
        child: new Center(
          child: new ClipRect(
            child: new BackdropFilter(
              filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: new Container(
                child: 
                  new Column(
                    children: <Widget>[
                      new Text(
                        "Login App",
                        textScaleFactor: 2.0,
                      ),
                      new Form(
                        key: formKey,
                        child: new Column(
                          children: <Widget>[
                            new Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new TextFormField(
                                onSaved: (val) => _email = val,
                                validator: (val) {
                                  return val.length < 10
                                      ? "email must have atleast 10 chars"
                                      : null;
                                },
                                decoration: new InputDecoration(labelText: "email"),
                              ),
                            ),
                            new Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new TextFormField(
                                onSaved: (val) => _password = val,
                                decoration: new InputDecoration(labelText: "Password"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _isLoading ? new CircularProgressIndicator() : new RaisedButton(onPressed: () => _submit(_ctx),child: new Text("LOGIN"),color: Colors.primaries[0])
                    ],
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                height: 300.0,
                width: 300.0,
                decoration: new BoxDecoration(
                    color: Colors.grey.shade200.withOpacity(0.5)),
              ),
            ),
          ),
        ),
      );
      }
      )
    );
  }

  @override
  void onLoginError(String errorTxt) {
    setState(() => _isLoading = false);
  }

  @override
  void onLoginSuccess(User user) async {
    _authStateProvider.setMobileToken(user.token);
    _authStateProvider.notify(AuthState.LOGGED_IN);
    setState(() => _isLoading = false);
  }
}