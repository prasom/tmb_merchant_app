import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tmb_merchant_app/authentication/authentication.dart';
import 'package:tmb_merchant_app/common/prefs_singleton.dart';
import 'package:tmb_merchant_app/index/index.dart';
import 'package:tmb_merchant_app/splash/splash.dart';
import 'package:tmb_merchant_app/login/login.dart';
import 'package:tmb_merchant_app/home/home.dart';
import 'package:tmb_merchant_app/common/common.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Transition transition) {
    print(transition.toString());
  }
}

void main() async {
  PrefsSingleton.prefs = await SharedPreferences.getInstance();
  BlocSupervisor().delegate = SimpleBlocDelegate();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  final AuthenticationBloc _authenticationBloc = AuthenticationBloc();

  AppState() {
    _authenticationBloc.dispatch(AppStart());
  }

  @override
  void dispose() {
    _authenticationBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      bloc: _authenticationBloc,
      child: MaterialApp(
        home: BlocBuilder<AuthenticationEvent, AuthenticationState>(
          bloc: _authenticationBloc,
          builder: (BuildContext context, AuthenticationState state) {
            List<Widget> widgets = [];

            if (state.isAuthenticated) {
              widgets.add(IndexPage());
            } else {
              widgets.add(LoginPage());
            }

            if (state.isInitializing) {
              widgets.add(SplashPage());
            }

            if (state.isLoading) {
              widgets.add(LoadingIndicator());
            }

            return Stack(
              children: widgets,
            );
          },
        ),
      ),
    );
  }
}
