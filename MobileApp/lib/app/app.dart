import 'package:flutter_mvvm_login_example/app/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mvvm_login_example/databases/app_preferences.dart';
import 'package:flutter_mvvm_login_example/repository/login_repository.dart';

/// App Class -> Application Class
class App extends StatelessWidget {
  //-------------------------------------------------------------- Singleton-Instance --------------------------------------------------------------
  // Singleton-Instance
  static final App _instance = App._internal();

  /// App Private Constructor -> App
  /// @param -> _
  /// @usage -> Create Instance of App
  App._internal();

  /// App Factory Constructor -> App
  /// @dependency -> _
  /// @usage -> Returns the instance of app
  factory App() => _instance;

  //------------------------------------------------------------ Widget Methods --------------------------------------------------------------------

  /// @override Build Method -> Widget
  /// @param -> context -> BuildContext
  /// @returns -> Returns widget as MaterialApp class instance
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: getAppRoutes().getRoutes,
    );
  }

  //------------------------------------------------------------- App Methods -------------------------------------------------------------------------

  /// Get App Routes Method -> AppRoutes
  /// @param -> _
  /// @usage -> Returns the instance of AppRoutes class
  AppRoutes getAppRoutes(){
    return AppRoutes();
  }

  /// Get App Preferences Method -> AppPreferences
  /// @param -> _
  /// @usage -> Returns the instance of AppPreferences class
  AppPreferences getAppPreferences(){
    return AppPreferences();
  }

  /// Get Login Repository Method -> LoginRepository
  /// @param -> appPreferences -> AppPreferences
  /// @usage -> Returns the instance of LoginRepository class by injecting AppPreferences dependency
  LoginRepository getLoginRepository({@required AppPreferences appPreferences}){
    return LoginRepository(appPreferences: appPreferences);
  }

}

