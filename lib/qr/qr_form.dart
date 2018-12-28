import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmb_merchant_app/common/common.dart';
import 'package:tmb_merchant_app/login/login.dart';
import 'package:tmb_merchant_app/qr/qr.dart';

class QrForm extends StatefulWidget {
  final LoginBloc loginBloc;
  final QrBloc qrBloc;

  const QrForm({Key key, @required this.loginBloc, @required this.qrBloc})
      : super(key: key);

  @override
  _QrFormState createState() => _QrFormState();
}

class _QrFormState extends State<QrForm> {
  final priceController = TextEditingController();
  final ref1Controller = TextEditingController();
  final ref2Controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QrEvent, QrState>(
      bloc: widget.qrBloc,
      builder: (BuildContext context, QrState state) {
        if (_generateSucceeded(state)) {
          widget.qrBloc.dispatch(GenerateQrSuccess(price: null, qrUrl: null));
        }

        if (_generateFailed(state)) {
          _onWidgetDidBuild(() {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          });
        }

        return Padding(
          padding: EdgeInsets.all(0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                QrMerchantInfo(
                  loginBloc: widget.loginBloc,
                ),
                SizedBox(
                  height: 20,
                ),
                _form(state)
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _form(QrState qrState) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'เลขที่สัญญา/ref1',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            child: Material(
                elevation: 0.0,
                borderRadius: BorderRadius.circular(2.0),
                child: StreamBuilder(
                  stream: widget.qrBloc.outCurrentRequest,
                  builder: (BuildContext context,
                      AsyncSnapshot<QrRequest> snapshot) {
                    if (snapshot.data != null &&
                        snapshot.data.ref1.isNotEmpty) {
                      ref1Controller.text = snapshot.data.ref1;
                    }
                    return TextFormField(
                      controller: ref1Controller,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'กรุณากรอก เลขที่สัญญา/ref1';
                        }
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          hintText: 'เลขที่สัญญา/ref1',
                          hintStyle: TextStyle(color: Colors.grey)),
                    );
                  },
                )),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'หมายเลขอ้างอิง/ref2',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            child: Material(
                elevation: 0.0,
                borderRadius: BorderRadius.circular(2.0),
                child: StreamBuilder(
                  stream: widget.qrBloc.outCurrentRequest,
                  builder: (BuildContext context,
                      AsyncSnapshot<QrRequest> snapshot) {
                    if (snapshot.data != null &&
                        snapshot.data.ref2.isNotEmpty) {
                      ref2Controller.text = snapshot.data.ref2;
                    }
                    return TextFormField(
                      controller: ref2Controller,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'กรุณากรอก หมายเลขอ้างอิง/ref2';
                        }
                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(10),
                          hintText: 'หมายเลขอ้างอิง/ref2',
                          hintStyle: TextStyle(color: Colors.grey)),
                    );
                  },
                )),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'จำนวนเงิน',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            child: Material(
              elevation: 0.0,
              borderRadius: BorderRadius.circular(2.0),
              child: StreamBuilder(
                stream: widget.qrBloc.outCurrentRequest,
                builder: (context, AsyncSnapshot<QrRequest> snapshot) {
                  if (snapshot.data != null && snapshot.data.price.isNotEmpty) {
                    priceController.text = snapshot.data.price;
                  }
                  return TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'กรุณากรอก จำนวนเงิน';
                      }
                    },
                    textAlign: TextAlign.right,
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.blue, fontSize: 20),
                        contentPadding: EdgeInsets.all(10),
                        hintText: '',
                        hintStyle: TextStyle(color: Colors.grey)),
                  );
                },
              ),
              // child: TextFormField(
              //   validator: (value) {
              //     if (value.isEmpty) {
              //       return 'กรุณากรอก จำนวนเงิน';
              //     }
              //   },
              //   textAlign: TextAlign.right,
              //   controller: priceController,
              //   initialValue: '',
              //   keyboardType: TextInputType.number,
              //   decoration: InputDecoration(
              //       labelStyle: TextStyle(color: Colors.blue, fontSize: 20),
              //       contentPadding: EdgeInsets.all(10),
              //       hintText: '',
              //       hintStyle: TextStyle(color: Colors.grey)),
              // ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.only(top: 5),
            child: ButtonTheme(
                minWidth: double.infinity,
                child: MaterialButton(
                  color: Colors.blue,
                  onPressed: qrState.isGenerateButtonEnabled
                      ? () {
                          if (_formKey.currentState.validate()) {
                            _onGenerateQrButtonPressed();
                          }
                        }
                      : null,
                  child: Text(
                    'สร้าง QR Code',
                    style: TextStyle(color: Colors.white),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  bool _generateSucceeded(QrState state) => state.qr.isNotEmpty;
  bool _generateFailed(QrState state) => state.error.isNotEmpty;

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  _onGenerateQrButtonPressed() {
    widget.qrBloc.dispatch(GenerateQr(
        request: QrRequest(
            ref1: ref1Controller.text,
            ref2: ref2Controller.text,
            price: priceController.text)));
  }
}
