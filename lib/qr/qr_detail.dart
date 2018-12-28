import 'package:flutter/material.dart';
import 'package:tmb_merchant_app/common/bound_text.dart';
import 'package:tmb_merchant_app/login/login.dart';
import 'package:tmb_merchant_app/qr/qr.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';

class QrDetail extends StatefulWidget {
  final LoginBloc loginBloc;
  final QrBloc qrBloc;

  const QrDetail({Key key, @required this.loginBloc, @required this.qrBloc})
      : super(key: key);
  @override
  _QrDetailState createState() => _QrDetailState();
}

class _QrDetailState extends State<QrDetail> {
  final formatter = new NumberFormat("#,###");
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32.0),
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image(
                    image: AssetImage('assets/blue_logo.png'),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text('แสดง Qr Code นี้เพื่อรับเงิน'),
            SizedBox(
              height: 10,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2 - 80,
              width: MediaQuery.of(context).size.width - 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.blue),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new QrImage(
                    data: "ร้านค้าสุขใจ",
                    size: 200.0,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 20,
              child: StreamBuilder(
                stream: widget.qrBloc.outCurrentRequest,
                builder:
                  (BuildContext context, AsyncSnapshot<QrRequest> snapshot) {
                String _price = '0';
                if (snapshot.data != null && snapshot.data.price.isNotEmpty) {
                  _price = snapshot.data.price;
                }
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      formatter.format(double.parse(_price)),
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'บาท(BAHT)',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                );
              }),
            ),
            SizedBox(
              height: 10,
            ),
            RaisedButton(
              color: Colors.blue,
              child: Text(
                'แก้ไข QR Code',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                widget.qrBloc.dispatch(EditQr());
              },
            )
          ],
        ),
      ),
    );
  }
}
