import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tmb_merchant_app/authentication/authentication.dart';
import 'package:tmb_merchant_app/login/login.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final LoginBloc _loginBloc = LoginBloc();
  int getColorHexFromStr(String colorStr) {
    colorStr = "FF" + colorStr;
    colorStr = colorStr.replaceAll("#", "");
    int val = 0;
    int len = colorStr.length;
    for (int i = 0; i < len; i++) {
      int hexDigit = colorStr.codeUnitAt(i);
      if (hexDigit >= 48 && hexDigit <= 57) {
        val += (hexDigit - 48) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 65 && hexDigit <= 70) {
        // A..F
        val += (hexDigit - 55) * (1 << (4 * (len - 1 - i)));
      } else if (hexDigit >= 97 && hexDigit <= 102) {
        // a..f
        val += (hexDigit - 87) * (1 << (4 * (len - 1 - i)));
      } else {
        throw new FormatException("An error occurred when converting a color");
      }
    }
    return val;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          // Box decoration takes a gradient
          gradient: RadialGradient(
              center: const Alignment(0, -0.5), // near the top right
              radius: 0.5,
              colors: <Color>[
                // const Color.fromRGBO(1, 6, 100, 162),
                // const Color.fromRGBO(0, 10, 74, 130),
                Color(getColorHexFromStr('#049ede')),
                Color(getColorHexFromStr('#0569a8'))
              ]),
        ),
        child: Container(
          margin: EdgeInsets.all(30.0),
          child: Column(children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15, top: 70),
              child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                          image: AssetImage('assets/white_logo.png'),
                          fit: BoxFit.contain))),
            ),
            SizedBox(
              height: 100,
            ),
            LoginForm(
              authBloc: BlocProvider.of<AuthenticationBloc>(context),
              loginBloc: _loginBloc,
            ),
          ]),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }
}
