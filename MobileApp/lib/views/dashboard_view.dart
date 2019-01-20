import 'package:flutter_mvvm_login_example/app/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mvvm_login_example/resource/values/app_styles.dart';

class Dashboard extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppStyles.lightTheme(),
      home: DashboardView(),
      onGenerateRoute: AppRoutes().getRoutes,
    );
  }
}

class DashboardView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => DashboardState();
}

class DashboardState extends State<DashboardView>{

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Setting dark status bar
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Theme.of(context).primaryColorDark, //or set color with: Color(0xFF0000FF)
    ));
    return Scaffold(
      body: Center(
        child: Text("Dashbord"),
      ),
    );
  }

}