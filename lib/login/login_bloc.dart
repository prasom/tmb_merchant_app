import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tmb_merchant_app/common/prefs_singleton.dart';

import 'package:tmb_merchant_app/login/login.dart';
import 'package:tmb_merchant_app/models/preference_names.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() {
    loadState();
  }

  LoginState get initialState => LoginState.initial();
  // Regular variables
  final SharedPreferences prefs = PrefsSingleton.prefs;

  @override
  Stream<LoginState> mapEventToState(
    LoginState currentState,
    LoginEvent event,
  ) async* {
    if (event is LoginButtonPressed) {
      yield LoginState.loading();

      try {
        final token = await _getToken(
          username: event.username,
          password: event.password,
        );

        inCurrentUser(token.toString());
        await saveUserState();

        yield LoginState.success(token);
      } catch (error) {
        yield LoginState.failure(error.toString());
      }
    }

    if (event is LoggedIn) {
      yield LoginState.initial();
    }
  }

  final _currentUser = BehaviorSubject<String>();

  // Streams
  Observable<String> get outCurrentUser => _currentUser.stream;

  // Sinks
  Function(String) get inCurrentUser => _currentUser.sink.add;

  Future<String> _getToken({
    @required String username,
    @required String password,
  }) async {
    await Future.delayed(Duration(seconds: 1));

    /// uncomment the following line to simulator a login error.
    // throw Exception('Login Error');
    return '$username $password';
  }

  // Persistence Functions
  Future saveUserState() async {
    await prefs.setString(PreferenceNames.currentUser, _currentUser.value);
  }

  String loadState() {
    var currentUser = prefs.getString(PreferenceNames.currentUser);
    inCurrentUser(currentUser);
    return currentUser;
  }

  Future dispose() async {
    // cleanup
    _currentUser.close();
  }
}
