import 'dart:async';

import 'package:flutter_mvvm_login_example/app/app.dart';
import 'package:flutter_mvvm_login_example/app/app_routes.dart';
import 'package:flutter_mvvm_login_example/resource/values/app_colors.dart';
import 'package:flutter_mvvm_login_example/resource/values/app_strings.dart';
import 'package:flutter_mvvm_login_example/resource/values/app_styles.dart';
import 'package:flutter_mvvm_login_example/view_models/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppStyles.lightTheme(),
      home: LoginView(),
      onGenerateRoute: App().getAppRoutes().getRoutes,
    );
  }
}

class LoginView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<LoginView> {

  // Login ViewModel variable
  LoginViewModel _viewModel;

  // Toggle variable for password visibility
  bool _passwordVisible;

  // Toggle variable for Log-In process
  bool _isLoading;

  // Ratio variable to determine height of main flex
  int mainFlexSize = 55;

  @override
  void initState() {

    // Initialize view-model variable
    _viewModel = LoginViewModel(App());

    // Method to subscribe event of view-model
    subscribeToViewModel();

    // Initially password is obscured
    _passwordVisible = false;

    // Log-in process in not initiated yet
    _isLoading = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    // Setting dark status bar
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Theme.of(context)
          .primaryColorDark, //or set color with: Color(0xFF0000FF)
    ));

    // Material Scaffold Widget
    return Scaffold(
      // Main background color
      backgroundColor: Theme.of(context).primaryColorDark,
      // Using SafeArea Widget to avoid inconsistency in device with Notch
      body: SafeArea(
        // Using Column to vertically aligned children widget
        child: Column(
          children: <Widget>[
            // Here we are using two Expanded widget to divide screen into two parts by ratio

            // Flex Expanded widget to hold app logo and name
            Expanded(
              // This variable will set ratio for height of this widget
              flex: mainFlexSize,
              child: Column(
                // Logo and App-Name will be in center of widget
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Setting Logo
                  Image.asset(
                    'images/logo.png',
                    width: 180,
                    height: 180,
                  ),
                  // Giving Padding to App-Name
                  Padding(
                    padding: EdgeInsets.all(24),
                    // Setting App-Name
                    child: Text(
                      AppStrings.APP_NAME,
                      // Setting text color
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .copyWith(color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),
            ),

            // Flex expanded widget to hold log in process widgets
            Expanded(
              // Flex size will be determine as Rest of height of mainFlex
              flex: 100 - mainFlexSize,
              // Using container to create custom background
              child: Container(
                // Using BoxDecoration widget to for rounded corners and white background
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  boxShadow:[BoxShadow(
                    color: AppColors.PRIMARY_COLOR_LIGHT,
                    blurRadius: 96.0,
                    offset: Offset(0, -24),
                    spreadRadius: 24,
                  ),BoxShadow(
                    color: AppColors.PRIMARY_COLOR,
                    blurRadius: 48.0,
                    offset: Offset(0, -6),
                  )]
                ),

                // ListView widget to hold all log-in process widgets
                child: ListView(
                        // Setting vertical padding to children widgets
                        padding: EdgeInsets.symmetric(vertical: 36.0),
                        children: <Widget>[

                          // StreamBuilder widget to listen to stream of 'userNameErrorText'
                          StreamBuilder<String>(
                            // Subscribing to userNameErrorText stream
                            stream: _viewModel
                                .getLoginFormObserver()
                                .userNameErrorText,
                            // Building child widget with current 'context' and stream 'snapshot' data
                            builder: (context, snapshot) {

                              // Widget with horizontal padding
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.0),

                                // TextFormField widget for username input
                                child: TextFormField(
                                  // Setting expecting text input for username
                                  keyboardType: TextInputType.text,
                                  // Setting username controller
                                  controller: _viewModel.userNameController,
                                  // Rest of input decoration will be automatically inherited from current theme
                                  decoration: InputDecoration(
                                    // Label to input box
                                    labelText: AppStrings.LOGIN_USER_NAME_LABEL,
                                    // Hint to input box
                                    hintText: AppStrings.LOGIN_USER_NAME_HINT,
                                    // Error message => NULL -> No error shown Otherwise Error shown with snapshot.data
                                    errorText: snapshot.data,
                                  ),
                                ),
                              );
                            },
                          ),
                          // SizedBox for separation between two widgets
                          SizedBox(height: 24.0),

                          // StreamBuilder widget to listen to stream of 'userPasswordErrorText'
                          StreamBuilder<String>(
                            // Subscribing to userPasswordErrorText stream
                            stream: _viewModel
                                .getLoginFormObserver()
                                .userPasswordErrorText,
                            // Building child widget with current 'context' and stream 'snapshot' data
                            builder: (context, snapshot) {

                              // Widget with horizontal padding
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.0),

                                // TextFormField widget for password input
                                child: TextFormField(
                                  // Setting expecting text input for username
                                  keyboardType: TextInputType.text,
                                  // Setting userPasswordController
                                  controller: _viewModel.userPasswordController,
                                  // This will obscure password text based on state of passwordVisible variable
                                  obscureText: !_passwordVisible,
                                  // Rest of input decoration will be automatically inherited from current theme
                                  decoration: InputDecoration(
                                    // Label of input text
                                    labelText: AppStrings.LOGIN_USER_PASSWORD_LABEL,
                                    // Hint of input text
                                    hintText: AppStrings.LOGIN_USER_PASSWORD_HINT,
                                    // Error message => NULL -> No error shown Otherwise Error shown with snapshot.data
                                    errorText: snapshot.data,
                                    // Suffix icon for password toggle button
                                    suffixIcon: IconButton(
                                      // Setting Icon widget
                                      icon: Icon(
                                        // Setting toggle icons based on state of passwordVisible variable
                                        _passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Theme.of(context).primaryColorDark,
                                      ),
                                      onPressed: () {
                                        // On pressed toggle the state of passwordVisible variable
                                        setState(() {
                                          _passwordVisible
                                              ? _passwordVisible = false
                                              : _passwordVisible = true;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),

                          // Based on state of isLoading variable i.e. TRUE -> Show progress indicator; FALSE -> Show button bar for login and reset button
                          _isLoading
                              ? // Here we have used conditional operator
                          // Loading
                          // Padding widget for setting top padding to progress indicator
                          Padding(
                            padding: EdgeInsets.only(top: 36.0),
                            // Using LinearProgressIndicator
                            child: const LinearProgressIndicator(
                              backgroundColor: AppColors.PRIMARY_COLOR,
                            ),
                          )
                              :
                          // Not Loading
                          // ButtonBar widget to hold Reset and Login button
                          ButtonBar(
                            // Setting alignment to 'end'
                            alignment: MainAxisAlignment.end,
                            children: <Widget>[
                              // FlatButton widget for Reset button
                              FlatButton(
                                child: Text( AppStrings.LOGIN_RESET_BUTTON_LABEL,),
                                onPressed: () {
                                  // On Pressed clear all text of username and password input field
                                  _viewModel.userNameController.clear();
                                  _viewModel.userPasswordController.clear();
                                },
                              ),

                              // StreamBuilder widget to listen 'isLoginEnabled' stream
                              StreamBuilder(
                                // Subscribing to isLoginEnabled stream
                                stream: _viewModel
                                    .getLoginFormObserver()
                                    .isLoginEnabled,
                                // Building child widget with current 'context' and stream 'snapshot' data
                                builder: (context, snapshot) {
                                  return RaisedButton(
                                    child: Text(AppStrings.LOGIN_LOGIN_BUTTON_LABEL),
                                    elevation: 12.0,
                                    animationDuration: Duration(seconds: 2),
                                    onPressed: snapshot.data ?? false // First we are checking if isLoginEnabled stream is NULL or not. If NULL then set it to FALSE
                                        // To enable or disable login button we are using this hack i.e. when isLoginEnabled gives FALSE value we are providing NULL
                                        // for onPressed function and hence button is disabled
                                        ? // Using conditional operator
                                        // isLoggedIn is TRUE
                                        () {
                                            // Set isLoading to true
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            // Invoke view-model checkLogin method with userName and userPassword parameters
                                            _viewModel.checkLogin(
                                                // Get userName from userNameController
                                                userName: _viewModel.userNameController.text,
                                                // Get userPassword from userPasswordController
                                                userPassword: _viewModel.userPasswordController.text);
                                          }
                                        :
                                        // isLoggedIn is TRUE
                                        // Provide NULL to disable button
                                        null,
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// Method to subscribing view model methods
  void subscribeToViewModel() {

    // Subscribe to getLoginResponse() method to listen log-in response
    _viewModel.getLoginResponse()
        .listen(
            (isSuccessfulLogin){

              // Update state
              setState(() {

                // Set the isLoading state to false
                _isLoading = false;

                if(isSuccessfulLogin){ // Successful Login
                  // Show toast
                  Fluttertoast.showToast(msg: AppStrings.LOGIN_SUCCESSFUL_LOGIN_MSG);
                  // Set mainFlex ratio size to full
                  mainFlexSize = 99;
                  // Navigate to Dashboard with some delay for showing app logo
                  Timer(const Duration(milliseconds: 500), ()=> Navigator.pushReplacementNamed(context, AppRoutes.APP_ROUTE_DASHBOARD));
                }else{ // Unsuccessful login
                  // Show toast
                  Fluttertoast.showToast(msg: AppStrings.LOGIN_UNSUCCESSFUL_LOGIN_MSG);
                }
      });

    });

  }
}
