import 'dart:async';

import 'package:flutter_mvvm_login_example/resource/values/app_strings.dart';

/// Login Form Observer Abstract Class - A contract class for Login Form Observer
abstract class LoginFormObserverContract {

  //------------------------------------------------------------ Static Constants ------------------------------------------------------------------
  static const int USER_NAME_VALID_LENGTH = 3;
  static const int USER_PASSWORD_VALID_LENGTH = 8;

  // ---------------------------------------------------------- Contract Variables ---------------------------------------------------------------

  // SINK variables
  /// User Name Variable -> Sink
  /// @usage -> Sink for user name value
  Sink get userName;
  /// User Password Variable -> Sink
  /// @usage -> Sink for user password value
  Sink get userPassword;

  // STREAM variables
  /// Is Valid User Name Variable -> Stream<bool>
  /// @usage -> Stream of type bool for streaming validation result of user name
  Stream<bool> get _isValidUserName;
  /// Is Valid User Password Variable -> Stream<bool>
  /// @usage -> Stream of type bool for streaming validation result of user password
  Stream<bool> get _isValidUserPassword;
  /// Is Login Enabled Variable -> Stream<bool>
  /// @usage -> Stream of type bool for streaming whether login is enabled or not
  Stream<bool> get isLoginEnabled;
  /// User Name Error Text Variable -> Stream<String>
  /// @usage -> Stream of type String for streaming user name error
  Stream<String> get userNameErrorText;
  /// User Password Error Text Variable -> Stream<String>
  /// @usage -> Stream of type String for streaming user password error
  Stream<String> get userPasswordErrorText;

  //------------------------------------------------------------- Contract Constructor -------------------------------------------------------------

  /// Login Form Observer Contract Constructor -> LoginFormObserverContract
  /// @param -> _
  /// @usage -> Initialize init and handleLoginEnableProcess methods for subclass
  LoginFormObserverContract(){
    _init();
  }

  //-------------------------------------------------------- Contract Methods -------------------------------------------------------------------------

  //Receiver Methods
  /// Dispose Method -> void
  /// @param -> _
  /// @usage -> Dispose the state of LoginFormObserver
  void dispose();
  /// Invalid Credentials Method -> void
  /// @param -> _
  /// @usage -> Initiate process for invalid credentials
  void invalidCredentials();


 //Observer Methods
  /// Init Method -> void
  /// @param -> _
  /// @usage -> Initiate all listeners of observers
  void _init(){
    _handleLoginEnableProcess();
  }
  /// Handle Login Enable Process Method -> void
  /// @param -> _
  /// @usage -> Handle process of enabling login
  void _handleLoginEnableProcess();
  /// Check Valid User Name Method -> bool
  /// @param -> username -> String
  /// @usage -> Validating user name

  //Validation Methods
  bool _checkValidUserName(String userName);
  /// Check Valid User Password Method -> bool
  /// @param -> userPassword -> String
  /// @usage -> Validating user password
  bool _checkValidUserPassword(String userPassword);

}

/// Login Form Observer Class - Observer class implementing LoginFormObserverContract
class LoginFormObserver extends LoginFormObserverContract{

  //------------------------------------------------------------ Observer variables -----------------------------------------------------------------

  // STREAM CONTROLLERS
  /// User Name StreamController -> String
  /// @usage -> Control stream of user name by adding sink from 'userName sink' and providing stream of user name
  var _userNameController = StreamController<String>.broadcast();
  /// User Password StreamController -> String
  /// @usage -> Control stream of user password by adding sink from 'userPassword sink' and providing stream of user password
  var _userPasswordController = StreamController<String>.broadcast();
  /// User Name Error Message StreamController -> String
  /// @usage -> Control stream of user name error msg
  var _userNameErrorMsgController = StreamController<String>.broadcast();
  /// User Password Error Message StreamController -> String
  /// @usage -> Control stream of user password error msg
  var _userPasswordErrorMsgController = StreamController<String>.broadcast();
  /// Is Login Valid Toggle StreamController -> bool
  /// @usage -> Control stream of valid login toggle
  var _isLoginValidToggleController = StreamController<bool>.broadcast();

  // bool variable to temporarily store result of username and password validation
  bool _tempValidUserName, _tempValidUserPassword;

  //------------------------------------------------------------- Constructor -----------------------------------------------------------------------

  LoginFormObserver():super();

  //------------------------------------------------------------- Contract Observer Methods ---------------------------------------------------------
  @override
  void _init() {
    // Make call to super class _init() method
    super._init();
    // Initially invalidate temporary user name and password
    _tempValidUserName = _tempValidUserPassword = false;
  }

  @override
  void _handleLoginEnableProcess() {

    // Listen to _isValidUserName stream
    _isValidUserName.listen(
            (isValidUserName){
                if(isValidUserName){ // Valid user name
                  // Set temporary valid user name to TRUE i.e. set it valid
                  _tempValidUserName = true;
                  // Now check whether temporary user password is Valid
                  _tempValidUserPassword
                      ? // Conditional operator
                  // VALID
                  // Add TRUE event to isLoginValidToggle stream
                  _isLoginValidToggleController.add(true)
                      :
                  // INVALID
                  // Do nothing
                  null;
                  // ADD NULL event to userNameErrorMsg stream
                  _userNameErrorMsgController.add(null);
                }else{ // Invalid User Name
                  // Set temporary valid user name to FALSE i.e. set it invalid
                  _tempValidUserName = false;
                  // Add FALSE event to isLoginValidToggle stream
                  _isLoginValidToggleController.add(false);
                  // ADD user name error string event to userNameErrorMsg stream
                  _userNameErrorMsgController.add(AppStrings.LOGIN_USER_NAME_ERROR_MSG);
                }
    });

    // Listen to _isValidUserPassword stream
    _isValidUserPassword.listen(
            (isValidUserPassword){
              if(isValidUserPassword){// Valid user password
                // Set temporary valid user password to TRUE i.e. set it valid
                _tempValidUserPassword = true;
                // Now check whether temporary user name is Valid
                _tempValidUserName
                    ? // Conditional operator
                // VALID
                // Add TRUE event to isLoginValidToggle stream
                _isLoginValidToggleController.add(true)
                    :
                //INVALID
                // Do nothing
                null;
                // ADD NULL event to userPasswordErrorMsg stream
                _userPasswordErrorMsgController.add(null);
              }else{
                // Set temporary valid user password to FALSE i.e. set it invalid
                _tempValidUserPassword = false;
                // Add FALSE event to isLoginValidToggle stream
                _isLoginValidToggleController.add(false);
                // ADD user password error string event to userPasswordErrorMsg stream
                _userPasswordErrorMsgController.add(AppStrings.LOGIN_USER_PASSWORD_ERROR_MSG);
              }

    });
  }

  //----------------------------------------------------------- Contract Variables ----------------------------------------------------------------
  @override
  // Read the stream from userNameController and map it to bool with _checkValidUserName() method by skipping first n elements of stream
  // where n = User name valid length
  Stream<bool> get _isValidUserName => _userNameController.stream.skip(LoginFormObserverContract.USER_NAME_VALID_LENGTH).map(_checkValidUserName);

  @override
  // Read the stream from userPasswordController and map it to bool with _checkValidUserPassword() method by skipping first n elements of stream
  // where n = User password valid length
  Stream<bool> get _isValidUserPassword => _userPasswordController.stream.skip(LoginFormObserverContract.USER_PASSWORD_VALID_LENGTH).map(_checkValidUserPassword);

  @override
  // Read stream from _isLoginValidToggleController
  Stream<bool> get isLoginEnabled =>  _isLoginValidToggleController.stream;

  @override
  // Write userName sink to _userNameController
  Sink get userName => _userNameController;

  @override
  // Read userNameErrorText stream from _userNameErrorMsgController
  Stream<String> get userNameErrorText => _userNameErrorMsgController.stream;

  @override
  // Write userPassword sink to _userPasswordController
  Sink get userPassword => _userPasswordController;

  @override
  // Read userPasswordErrorText stream from _userPasswordErrorMsgController
  Stream<String> get userPasswordErrorText => _userPasswordErrorMsgController.stream;


  //------------------------------------------------------- Contract Validation Methods --------------------------------------------------------------

  @override
  // Valid user name string if it is not NULL and its length is greater than defined valid user name length
  bool _checkValidUserName(String userName) => userName != null && userName.length >= LoginFormObserverContract.USER_NAME_VALID_LENGTH;

  @override
  // Valid user password string if it is not NULL and its length is greater than defined valid user password length
  bool _checkValidUserPassword(String userPassword)=> userPassword != null && userPassword.length >= LoginFormObserverContract.USER_PASSWORD_VALID_LENGTH;


  //--------------------------------------------------------- Contract Receiver Methods --------------------------------------------------------------

  @override
  void invalidCredentials() {
    // ADD user name invalid string event to userNameErrorMsg stream
    _userNameErrorMsgController.add(AppStrings.LOGIN_USER_NAME_INVALID_MSG);
    // ADD user password invalid string event to userPasswordErrorMsg stream
    _userPasswordErrorMsgController.add(AppStrings.LOGIN_USER_PASSWORD_INVALID_MSG);
  }

  @override
  void dispose() {
    // Close all stream controllers so that there listener could stop listening

    _userNameController.close();
    _userPasswordController.close();
    _userNameErrorMsgController.close();
    _userPasswordErrorMsgController.close();
    _isLoginValidToggleController.close();
  }

}