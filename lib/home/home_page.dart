import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tmb_merchant_app/authentication/authentication.dart';
import 'package:tmb_merchant_app/common/bound_text.dart';
import 'package:tmb_merchant_app/home/home.dart';
import 'package:tmb_merchant_app/login/login.dart';

class HomePage extends StatelessWidget {
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
    final LoginBloc loginBloc =
        BlocProvider.of<LoginBloc>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(getColorHexFromStr('#0569a8')),
        elevation: 0,
        title: Text('Home'),
      ),
      body: Container(
        child: Center(
            child: Column(
          children: <Widget>[
            MerchantInfo(loginBloc: loginBloc),
            SizedBox(
              height: 20,
            ),
            MerchantQr(loginBloc: loginBloc,)
          ],
        )),
      ),
    );
  }
}
