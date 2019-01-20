import 'package:flutter_mvvm_login_example/network/network_config.dart';

class UserModel {

  String userName;
  String userPassword;

  int loginResponse;

  UserModel({this.userName, this.userPassword, this.loginResponse});


  UserModel.fromJson(dynamic json) {
    this.userName = json[NetworkConfig.API_KEY_USER_NAME];
    this.userPassword = json[NetworkConfig.API_KEY_USER_PASSWORD];
    this.loginResponse = json[NetworkConfig.API_KEY_LOGIN_RESPONSE];
  }

}