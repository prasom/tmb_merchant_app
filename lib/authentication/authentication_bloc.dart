import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tmb_merchant_app/authentication/authentication.dart';
import 'package:tmb_merchant_app/common/prefs_singleton.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  @override
  AuthenticationState get initialState => AuthenticationState.initializing();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationState currentState,
    AuthenticationEvent event,
  ) async* {
    if (event is AppStart) {
      final bool hasToken = await _hasToken();

      if (hasToken) {
        yield AuthenticationState.authenticated();
      } else {
        yield AuthenticationState.unauthenticated();
      }
    }

    if (event is Login) {
      yield currentState.copyWith(isLoading: true);

      await _persistToken(event.token);
      yield AuthenticationState.authenticated();
    }

    if (event is Logout) {
      yield currentState.copyWith(isLoading: true);

      await _deleteToken();
      yield AuthenticationState.unauthenticated();
    }
  }

  // Regular variables
  final SharedPreferences prefs = PrefsSingleton.prefs;

  Future<void> _deleteToken() async {
    /// delete from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<void> _persistToken(String token) async {
    /// write to keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return;
  }

  Future<bool> _hasToken() async {
    /// read from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return false;
  }
}
