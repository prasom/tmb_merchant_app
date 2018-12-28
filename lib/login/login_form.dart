import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tmb_merchant_app/authentication/authentication.dart';
import 'package:tmb_merchant_app/login/login.dart';

class LoginForm extends StatefulWidget {
  final LoginBloc loginBloc;
  final AuthenticationBloc authBloc;

  LoginForm({
    Key key,
    @required this.loginBloc,
    @required this.authBloc,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginEvent, LoginState>(
      bloc: widget.loginBloc,
      builder: (
        BuildContext context,
        LoginState loginState,
      ) {
        if (_loginSucceeded(loginState)) {
          widget.authBloc.dispatch(Login(token: loginState.token));
          widget.loginBloc.dispatch(LoggedIn());
        }

        if (_loginFailed(loginState)) {
          _onWidgetDidBuild(() {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${loginState.error}'),
                backgroundColor: Colors.red,
              ),
            );
          });
        }

        return _form(loginState);
      },
    );
  }

  Widget _form(LoginState loginState) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
                labelText: 'username',
                labelStyle: TextStyle(color: Colors.white)),
            controller: _usernameController,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'password',
              labelStyle: TextStyle(color: Colors.white),
            ),
            controller: _passwordController,
            obscureText: true,
          ),
          RaisedButton(
            disabledColor: Colors.white,
            onPressed:
                loginState.isLoginButtonEnabled ? _onLoginButtonPressed : null,
            child: Text(
              'Login',
              style: TextStyle(color: Colors.blue),
            ),
          ),
          Container(
            child: loginState.isLoading ? CircularProgressIndicator() : null,
          ),
        ],
      ),
    );
  }

  bool _loginSucceeded(LoginState state) => state.token.isNotEmpty;
  bool _loginFailed(LoginState state) => state.error.isNotEmpty;

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  _onLoginButtonPressed() {
    widget.loginBloc.dispatch(LoginButtonPressed(
      username: _usernameController.text,
      password: _passwordController.text,
    ));
  }
}
