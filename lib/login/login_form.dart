import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:doggie_tag_list/models/user.dart';
import 'package:doggie_tag_list/auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:doggie_tag_list/authentication/authentication.dart';
import 'package:doggie_tag_list/login/login.dart';



class LoginForm extends StatefulWidget {
  final LoginBloc _loginBloc;
  final AuthenticationBloc _authBloc;

  LoginForm({
    Key key,
    @required LoginBloc loginBloc,
    @required AuthenticationBloc authBloc,
  }) : _loginBloc = loginBloc,
       _authBloc = authBloc,
       super(key: key);

  @override
  State<LoginForm> createState() {
    return LoginFormState(
      loginBloc: _loginBloc,
      authBloc: _authBloc
    );
  }
}

class LoginFormState extends State<LoginForm>
    {

  bool _isLoading = false;
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  String _password, _email;
  AuthStateProvider _authStateProvider;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final LoginBloc _loginBloc;
  final AuthenticationBloc _authBloc;

  LoginFormState({
    @required LoginBloc loginBloc,
    @required AuthenticationBloc authBloc
  }) : _loginBloc = loginBloc,
      _authBloc = authBloc;

  void _submit(BuildContext context) {
    final form = formKey.currentState;

    if (form.validate()) {
      setState(() => _isLoading = true);
      form.save();
      _showSnackBar("Thanks for logging in!", context);
    }
  }

  void _showSnackBar(String text, BuildContext context) {
    Scaffold.of(context).showSnackBar(SnackBar(content: new Text(text)));
  }

  bool _loginSucceeded(LoginState state) => state.token.isNotEmpty;
  bool _loginFailed(LoginState state) => state.error.isNotEmpty;

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  Widget _form(LoginState loginState) {
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
                              controller: _emailController,
                            ),
                          ),
                          new Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new TextFormField(
                              onSaved: (val) => _password = val,
                              decoration: new InputDecoration(labelText: "Password"),
                              controller: _passwordController,
                            ),
                          ),
                        ],
                      ),
                    ),
                    loginState.isLoading ? new CircularProgressIndicator() : new RaisedButton(onPressed: () => _onLoginButtonPressed(), child: new Text("LOGIN"), color: Colors.primaries[0])
                  ],
                  crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                  height: 300.0,
                  width: 300.0,
                  decoration: new BoxDecoration(
                      color: Colors.grey.shade200.withOpacity(0.5)),
            )
          )
        )
      )
    );
    }

  @override
  Widget build(BuildContext _context) {
    return BlocBuilder<LoginEvent, LoginState>(
      bloc: _loginBloc,
      builder: (
        BuildContext context,
        LoginState loginState
      ) {
        if (_loginSucceeded(loginState)) {
          _authBloc.onLogin(token: loginState.token);
          _loginBloc.onLoginSuccess();
          _onWidgetDidBuild(() {
            Navigator.of(context).pushReplacementNamed("/tag_info");
          });
        }

        if (_loginFailed(loginState)) {
          _onWidgetDidBuild(() {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: new Text('${loginState.error}'),
                backgroundColor: Colors.red,
            )
            );
          });
        }
        return _form(loginState);
    }
    );}


  _onLoginButtonPressed() {
    _loginBloc.onLoginButtonPressed(
      email: _emailController.text,
      password: _passwordController.text
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