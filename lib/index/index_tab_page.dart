import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmb_merchant_app/home/home.dart';
import 'package:tmb_merchant_app/login/login.dart';
import 'package:tmb_merchant_app/qr/qr.dart';
import 'package:tmb_merchant_app/setting/setting.dart';

class IndexTabPage extends StatefulWidget {
  @override
  _IndexTabPageState createState() => _IndexTabPageState();
}

class _IndexTabPageState extends State<IndexTabPage> {
  final LoginBloc _loginBloc = LoginBloc();

  int _currentIndex = 0;
  final List<Widget> _children = [
    new HomePage(),
    new QrPage(),
    new SettingPage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
      bloc: _loginBloc,
      child: new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: _children[_currentIndex],
        // body: new Container(),
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex:
              _currentIndex, // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              title: new Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.developer_board),
              title: new Text('Qr Code'),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.menu), title: Text('Settings'))
          ],
        ),
      ),
    );
  }
}
