import 'dart:async';

import 'package:flutter_mvvm_login_example/app/app.dart';
import 'package:flutter_mvvm_login_example/form_observers/login_form_observers.dart';
import 'package:flutter_mvvm_login_example/repository/login_repository.dart';
import 'package:flutter/material.dart';

/// Login View Model Class -> View-model class for Login View
class LoginViewModel{

  // -------------------------------------------------------- Variables -----------------------------------------------------------------------------

  // LoginFormObserver object
  LoginFormObserver _loginFormObserver;

  // LoginRepository object
  LoginRepository _loginRepository;

  // LoginViewModel instance
  static LoginViewModel _instance;

  // TextEditingController for userName
  final userNameController = TextEditingController();
  // TextEditingController for userPassword
  final userPasswordController = TextEditingController();
  // STREAM CONTROLLER for broadcasting login response
  var _loginResponseController = StreamController<bool>.broadcast();

  // ---------------------------------------------------------- Constructor --------------------------------------------------------------------------

  /// LoginViewModel Factory Constructor -> LoginViewModel
  /// @dependency -> App
  /// @usage -> Returns LoginViewModel Singleton-Instance by injecting dependency for private constructor.
  factory LoginViewModel(App app){
    // Check whether instance is NULL otherwise get the instance from private constructor
    _instance
    ??= // NULL Check
    // _instance is NULL. Create instance by injecting dependency to private internal constructor.
    LoginViewModel._internal(loginFormObserver: LoginFormObserver(), loginRepository: app.getLoginRepository(appPreferences: app.getAppPreferences()));
    // Return Singleton-Instance of LoginViewModel
    return _instance;
  }

  /// LoginViewModel Private Constructor -> LoginViewModel
  /// @param -> @required loginFormObserver -> LoginFormObserver
  ///        -> @required loginRepository -> LoginRepository
  /// @usage -> Initialize private variables and invoke _init() method
  LoginViewModel._internal({@required LoginFormObserver loginFormObserver, @required LoginRepository loginRepository}){

    // Initialize loginFormObserver
    _loginFormObserver = loginFormObserver;

    // Initialize loginRepository
    _loginRepository = loginRepository;

    // init method for initializing view-model process
    _init();

  }

  // ---------------------------------------------------------- View Model Methods -------------------------------------------------------------------

  /// Init method -> void
  /// @param -> _
  /// @usage -> Initiate all listeners for view-model
  void _init() {

    // Add listener to userNameController
    userNameController.addListener(() =>
        // Add userNameController's value to userName SINK from LoginFormObserver
        getLoginFormObserver()
            .userName
            .add(userNameController.text));

    // Add listener to userPasswordController
    userPasswordController.addListener(() =>
        // Add userPasswordController's value to userPassword SINK from LoginFormObserver
        getLoginFormObserver()
            .userPassword
            .add(userPasswordController.text));

    // Add login response listener
    _listenLoginResponse();
  }

  /// Listen Login Response Method -> void
  /// @param -> _
  /// @usage -> Subscribe to getLoginResponse() method from LoginRepository.
  void _listenLoginResponse(){
    _loginRepository.getLoginResponse()
        .listen(
            (isSuccessfulLogin){

              if(isSuccessfulLogin){ // Successful login
                // Invoke dispose() method of loginFormObserver
                _loginFormObserver.dispose();
                // Send TRUE event to loginResponseController stream
                _loginResponseController.add(true);
              }else{ // Unsuccessful login
                // Invoke invalidCredentials() method of loginFormObserver
                _loginFormObserver.invalidCredentials();
                // Send FALSE event to loginResponseController stream
                _loginResponseController.add(false);
              }
        }
    );
  }

  // --------------------------------------------------------------------- Getter Methods --------------------------------------------------------------
  /// GETTER LoginFormObserver Method -> LoginFormObserver
  /// @param -> _
  /// @usage -> Returns the current object of loginFormObserver
  LoginFormObserver getLoginFormObserver() => _loginFormObserver;

  // --------------------------------------------------------------- View Models Methods For Views -----------------------------------------------------

  /// CheckLogin Method -> void
  /// @param -> @required userName -> String
  ///           @required userPassword -> String
  ///  @usage -> Initiate process of checking login credentials by passing username and password to repository
  void checkLogin({@required String userName, @required String userPassword}) {
    _loginRepository.isAuthenticUser(userName: userName, userPassword: userPassword);
  }

  /// Get Login Response Method -> Stream<bool>
  /// @param -> _
  /// @usage -> Stream method for streaming login response.
  Stream<bool> getLoginResponse() => _loginResponseController.stream;// Stream the loginResponseController's stream

}