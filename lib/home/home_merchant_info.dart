import 'package:flutter/material.dart';
import 'package:tmb_merchant_app/authentication/authentication.dart';
import 'package:tmb_merchant_app/common/bound_text.dart';
import 'package:tmb_merchant_app/login/login.dart';

class MerchantInfo extends StatefulWidget {
  final LoginBloc loginBloc;

  const MerchantInfo({Key key, @required this.loginBloc}) : super(key: key);

  @override
  _MerchantInfoState createState() => _MerchantInfoState();
}

class _MerchantInfoState extends State<MerchantInfo> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 80,
            padding: EdgeInsets.all(12),
            child: Image(
              image: AssetImage('assets/blue_logo.png'),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                BoundText(widget.loginBloc.outCurrentUser),
                SizedBox(
                  height: 5,
                ),
                Text(
                  'Comp Code : 12345',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
