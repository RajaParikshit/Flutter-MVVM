import 'dart:async';
import 'package:flutter_mvvm_login_example/app/app.dart';
import 'package:flutter_mvvm_login_example/resource/values/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mvvm_login_example/app/app_routes.dart';

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppStyles.lightTheme(),
      home: SplashView(),
      onGenerateRoute: AppRoutes().getRoutes,
    );
  }
}

class SplashView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SplashState();
}

class SplashState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  var _iconAnimationController;
  var _iconAnimation;

  startTimeout() async {
    return Timer(const Duration(seconds: 1), handleTimeout);
  }

  void handleTimeout()async {

    await App().getAppPreferences().isPreferenceReady;

    App().getAppPreferences().getLoggedIn().then((isLoggedIn) {
      isLoggedIn
          ? Navigator.pushReplacementNamed(context, AppRoutes.APP_ROUTE_DASHBOARD)
          : Navigator.pushReplacementNamed(context, AppRoutes.APP_ROUTE_LOGIN);
    });
  }

  @override
  void initState() {
    super.initState();

    _iconAnimationController = AnimationController(duration: Duration(milliseconds: 1000), vsync: this);

    _iconAnimation = CurvedAnimation(parent: _iconAnimationController, curve: Curves.fastOutSlowIn);
    _iconAnimation.addListener(() => this.setState(() {}));

    _iconAnimationController.forward();

    startTimeout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      body: Center(
          child: Image(
        image: AssetImage("images/logo.png"),
        width: _iconAnimation.value * 180,
        height: _iconAnimation.value * 180,
      )),
    );
  }
}
