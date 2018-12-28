import 'package:flutter/material.dart';
import 'package:tmb_merchant_app/login/login.dart';
import 'package:transparent_image/transparent_image.dart';

class MerchantQr extends StatefulWidget {
  final LoginBloc loginBloc;

  const MerchantQr({Key key, @required this.loginBloc}) : super(key: key);

  @override
  _MerchantQrState createState() => _MerchantQrState();
}

class _MerchantQrState extends State<MerchantQr> {
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
    return Container(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width - 40,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Color(getColorHexFromStr('#0569a8'))),
        borderRadius: BorderRadius.circular(15),
       color: Colors.grey.shade100
      ),
      child: FadeInImage.memoryNetwork(
        image: 'https://i.ibb.co/GFtPFpH/qr-home.png',
        placeholder: kTransparentImage,
      ),
    );
  }
}
