import 'package:flutter_mvvm_login_example/views/dashboard_view.dart';
import 'package:flutter_mvvm_login_example/views/login_view.dart';
import 'package:flutter_mvvm_login_example/views/splash_view.dart';
import 'package:flutter/material.dart';

/// App Routes Class -> Routing class
class AppRoutes{

  //--------------------------------------------------------------- Constants ------------------------------------------------------------------------
  static const String APP_ROUTE_LOGIN = "/login";
  static const String APP_ROUTE_DASHBOARD = "/dashboard";

  //--------------------------------------------------------------- Methods --------------------------------------------------------------------------

  /// Get Routes Method -> Route
  /// @param -> routeSettings -> RouteSettings
  /// @usage -> Returns route based on requested route settings
  Route getRoutes(RouteSettings routeSettings){

    switch(routeSettings.name){

      case APP_ROUTE_LOGIN : {
        return MaterialPageRoute<void>(
          settings: routeSettings,
          builder: (BuildContext context) => Login(),
          fullscreenDialog: true,
        );
      }

      case APP_ROUTE_DASHBOARD : {
        return MaterialPageRoute<void>(
          settings: routeSettings,
          builder: (BuildContext context) => Dashboard(),
        );
      }

      default: {
        return MaterialPageRoute<void>(
          settings: routeSettings,
          builder: (BuildContext context) => Splash(),
          fullscreenDialog: true,
        );
      }

    }

  }

}



