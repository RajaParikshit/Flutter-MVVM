import 'dart:async';

import 'package:flutter_mvvm_login_example/databases/app_preferences.dart';
import 'package:meta/meta.dart';

import 'package:flutter_mvvm_login_example/network/nao/login_nao.dart';

/// Login Repository -> Repository Class for Login process
class LoginRepository {

  //--------------------------------------------------------------------- Variables -------------------------------------------------------------------
  // STREAM CONTROLLER for broadcasting success of login process
  var _isSuccessfulLogin = StreamController<bool>.broadcast();

  // AppPreferences private object
  AppPreferences _appPreferences;

  //-------------------------------------------------------------------- Constructors ------------------------------------------------------------------

  /// Login Repository Factory Constructor -> LoginRepository
  /// @dependency -> @required appPreferences -> AppPreferences
  /// @usage -> Returns LoginRepository instance by injecting dependencies for private constructor.
  factory LoginRepository({@required AppPreferences appPreferences})=> LoginRepository._internal(appPreferences);

  /// Login Repository Private Constructor -> LoginRepository
  /// @param -> @required appPreference -> AppPreferences
  /// @usage -> Create Instance of LoginRepository and initialize variables
  LoginRepository._internal(this._appPreferences);

  //---------------------------------------------------------------------- Methods --------------------------------------------------------------------
  /// Is Authentic User Method -> void
  /// @param -> @required userName -> String
  ///        -> @required userPassword -> String
  /// @usage -> Initiate authentication process and listen to response of authentication, therefore notify authentication result to all listeners
  void isAuthenticUser(
      {@required String userName, @required String userPassword}) {
    // Here we are authenticating user over network
    // Invoke Login Network Access Object's static isAuthenticUser() method
    LoginNAO.isAuthenticUser(userName: userName, userPassword: userPassword)

        .then((userModel) {// On Response
          // Check Login Response

          if (userModel.loginResponse == 1) {// Successful login
            // Add TRUE event to _isSuccessfulLogin stream
            _isSuccessfulLogin.add(true);
            // Set IS_LOGGED_IN to TRUE in preference
            _appPreferences.setLoggedIn(isLoggedIn: true);
          } else {// Unsuccessful login
            // Add FALSE event to _isSuccessfulLogin stream
            _isSuccessfulLogin.add(false);
            // Set IS_LOGGED_IN to FALSE in preference
            _appPreferences.setLoggedIn(isLoggedIn: false);
          }
        });
  }

  /// Get Login Response Method -> Stream<bool>
  /// @param -> _
  /// @usage -> Stream of type bool for streaming login response
  Stream<bool> getLoginResponse() {
    return _isSuccessfulLogin.stream;
  }

}
